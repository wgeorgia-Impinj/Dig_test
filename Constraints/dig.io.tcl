#######################################################################
# This file will have 4 sections for specifying the external conditions 
# at the input/output ports.
# 1. Drive characteristics at input ports
# 2. Timing external to the input ports
# 3. Load (capacitance) at output ports
# 4. Timing external to the output ports
#######################################################################

#Used these values instead of fixed numbers to over constrain io delays for dc/icc
set sc_150 [expr 150 / $scaling_factor]
set sc_100 [expr 100 / $scaling_factor]
set sc_75 [expr 75 / $scaling_factor]
set sc_50 [expr 50 / $scaling_factor]

set inports    [get_ports * -filter direction==in]
set outports   [get_ports * -filter direction==out]
set inoutports [get_ports * -filter direction==inout]

# 1. Drive characteristics at input ports

    # Setting a minimum driving cell for all inputs (pessimistic)
    # Any port-specific revilements will follow this, 
    # so that they override the pessimistic requirement set above.
    set_driving_cell -lib_cell INVXL -input_transition_rise 2.0 -input_transition_fall 2.0 \
    [all_inputs]

    # Deriving DEMOD_SLICER_UT numbers from RX5 actuals.
    # (Looking at the DTI->DEMOD->RX path)
    # John H. confirms driver is INVX5 -- wgeorgia 1.28.22
    set_driving_cell -lib_cell INVX5 -input_transition_rise 30.0 -input_transition_fall 30.0 \
    [get_ports { DEMOD_SLICER_UT }]

    # From schematic INVX7. Using an INVX3 to be conservative.
    # We're having issues with loading on this net. Going very conservative.
    set_driving_cell -lib_cell INVX2 -input_transition_rise 1.0 -input_transition_fall 1.0 \
    [get_ports OSC_CLK]

    # From schematic BUFX12/BUFX6. Using a BUFX2 to be conservative.
    set_driving_cell -lib_cell BUFX2 -input_transition_rise 10.0 -input_transition_fall 10.0 \
    [get_ports "DTI_DIN DTI_CLK" ]


# 2. Timing external to the input ports

    # These are tie-offs at tag-level. 
    set tied_inputs [get_ports "DIE_LOCATION* " ]    
    set_false_path -from $tied_inputs

    # These are semi-static inputs. They stabilize before TC does anything.
    # So giving a large part of the clock cycle to the TC.
    set semistatic_inputs [get_ports "ATUNE_CAP* DTI_CONFIG* DTI_TEST_EN \
    DTI_RX_INPUT_SELECT DTI_LOCAL_CONFIG*"]
    set_false_path -from $semistatic_inputs

    # DTI_LOCAL_CONFIG values are used by the TC many clock cycles later. 
    # Multicycle-path. 
    # Starting with a single cycle path, giving a large part of the clock cycle to the TC.
    set multicycle_inputs [get_ports "DTI_LOCAL_CONFIG* SR_DETECTED"]
    set_input_delay $sc_50 $multicycle_inputs -clock OSC_CLK

    # From tag schematic: PMU_RESET_B is
    # asserted asynchronously and deasserted synchronously
    # There is at least CK-->Q, AND gate, BUFFER, top-level routing delay w.r.t.
    # OSC_CLK before it gets to the TC port. Constraining accordingly below. 
    set_input_delay -max $sc_150 [get_ports PMU_RESET_B] -clock OSC_CLK
    set_input_delay -min 20  [get_ports PMU_RESET_B] -clock OSC_CLK

    # NVMC --> TC inputs
    # Some of these are half cycle paths.
    # For now giving 100ns to NVMC and routing, rest to TC.
#    set nvmc_inputs [get_ports "NVM_READ_VALID NVM_READ_DATA_OUT NVM_DONE \
#        NVM_WRITE_VLTG_CHK_FAIL NVM_STEP NVM_CONFIG_OUT"] 
#    set_input_delay 100.0 $nvmc_inputs -clock [get_clocks MIF_NVM_SCLK]

    # FLAGS_Q
    # There is an async handshake with the flags block
    # REN, RST_B generated off of TIM_CNT_4 
    # FLAGS_Q captured on ~TIM_CNT_4
    # Setup time is easy to meet - TIM_CNT_4 is divide-by 32 of TIM_CLK 
    # Hold time is met by design TIM_CNT_4 --> RST_B --> Thold_out --> FLAGS_Q
    set_input_delay $sc_50 [get_ports FLAGS_Q] -clock [get_clocks Fbit4_clk] -clock_fall

    # DEMOD_SLICER_UT
    # Asynchronous signal from DEMOD analog block, goes to RX block in TC
    # Critical for Tag operation
    # Give it 200ns w.r.t. OSC_CLK (larger number = lax constraint)
    # using the unscaled period will result in a larger delay for synth
    set_input_delay [expr $OSC_CLK_PERIOD_UNSCALED/2 - 200.0] [get_ports DEMOD_SLICER_UT] \
        -clock OSC_CLK

    # ARNG_DATA
    # Driven from the ARNG analog block on inverted ARNG_CLK.
    # Captured on RNG_CLK.
    # ARNG_CLK is divide-by-32 of TIM_CLK
    # Setup and hold is met by mid-bit clocking
    set_input_delay $sc_50 [get_ports ARNG_DATA] -clock [get_clocks ARNG_CLK] -clock_fall

    # DTI_DIN is considered asynchronous to OSC_CLK.
    # Setting a small input delay to have some constraint on it. (not required)
    set_false_path -from [get_ports "DTI_DIN DTI_CLK" ] -to [get_clocks OSC_CLK]    

# 3. Load (capacitance) at output ports

    # Marc generated this file from RX3 tag level dfII database. 
    # Will be updated with the latest loads from RX4 tag database. 
    source -echo $env(proj_root)/syn_spar/constraints/dig.loads.tcl

# 4. Timing external to the output ports

    # Following 3 clocks are output by the TC to the NVMC
    # TIM_NVM_HVS_CLK, MIF_NVM_SCLK, MIF_NVM_CONFIG_CLK
    # MIF_NVM_SCLK has been defined as a clock, so cannot apply output delay on it.
    # Constraining remaining w.r.t. OSC_CLK
    # They should come out in a reasonable time, no hard constraint
#set output_clks_to_nvm [get_ports "HVS_CLK"]
#set_output_delay 0 $output_clks_to_nvm -clock [get_clocks OSC_CLK]
    
    # Following 10 output ports of TC go to NVMC: 
    # MIF_NVM_WORD_ADDR[4:0], MIF_NVM_READ, MIF_NVM_WRITE
    # MIF_MEM_ADDR_IN_NVM, MIF_NVM_WRITE_LENGTH, MIF_NVM_SIN_DATA,
    # MIF_MARGIN_READ_DTI_EN, MIF_MARGIN_READ_AIR_EN, MIF_CAL_DONE
    
    # Captured within the NVMC by READ_SAMP_CLK. 1/2 clock path.
#    set outputs_to_nvm1 [get_ports "MIF_NVM_READ MIF_NVM_WRITE \
#        MIF_NVM_WORD_ADDR* MIF_CAL_DONE MIF_MARGIN_READ_DTI_EN"]
    # Captured within NVMC by SREG_AND_SAMP_CLK. Maybe a 1.5 or 0.5 clock path.
#    set outputs_to_nvm2 [get_ports "MIF_NVM_WRITE_LENGTH \
#        MIF_NVM_SIN_DATA MIF_MARGIN_READ_AIR_EN"]
#    if {$env(design_phase) == "SYNTH"} {
#        set_output_delay [expr $OSC_CLK_PERIOD/2 - 110.0] $outputs_to_nvm1 \
#            -clock MIF_NVM_SCLK
#        set_output_delay [expr $OSC_CLK_PERIOD/2 - 130.0] $outputs_to_nvm2 \
#            -clock MIF_NVM_SCLK
#    } elseif {$env(design_phase) == "STA"} {
#        set_output_delay [expr $OSC_CLK_PERIOD/2 - 150.0] $outputs_to_nvm1 \
#            -clock MIF_NVM_SCLK
#        set_output_delay [expr $OSC_CLK_PERIOD/2 - 200.0] $outputs_to_nvm2 \
#            -clock MIF_NVM_SCLK
#    }

    # Launched on TIM_NVM_SCLK which is a precursor to MIF_NVM_SCLK.
    # Captured on READ_SAMP_CLK inside NVMC.
    # Give 1/2 clock to TC, 1/2 clock to routing and NVMC
#    set outputs_to_nvm3 [get_ports "MIF_MEM_ADDR_IN_NVM"]
#    set_output_delay [expr $OSC_CLK_PERIOD/2] $outputs_to_nvm3 \
#        -clock MIF_NVM_SCLK


    # PARITY_TEST_CONTROL[1:0] bits to NVMC
    # These are semi-static (Jesse), dont have specific timing
#    set outputs_to_nvm3 [ get_ports PARITY_TEST_CONTROL*]
#    set_output_delay 0 $outputs_to_nvm3 -clock [get_clocks OSC_CLK]



    # TC --> FLAGS

    # From the RX2 Flags Datasheet, timing requirements on the
    # FIF_FLAGS_D, FIF_FLAGS_WEN, FIF_FLAGS_REN, FIF_FLAGS_RST_B outputs from TC.
    # Twrite (minimum) 2ms - addressed by design
    # Thold_in (minimum) 20ns - addressed by design
    # Treset (minimum) 5us - addressed by design
    # Tinit (minimum 1ms - addressed by design
    # Trise & Tfall (maximum) 50ns - addressed through set_max_transition
    # No specific timing requirements - will constrain these ports with a loose 
    # output delay constraint.
    # Generated off of Fbit3_clk  
    set flag_outputs [get_ports "FIF_FLAGS_D* FIF_FLAGS_WEN* \
                                 FIF_FLAGS_REN* FIF_FLAGS_RST_B"]
    set_output_delay -max $sc_100 $flag_outputs -clock [get_clocks Fbit3_clk]
    set_output_delay -min 10  $flag_outputs -clock [get_clocks Fbit3_clk]

    
    # TC --> DTI
    # Goes to analog logic, no specified timing constraints.
    set dti_outputs [get_ports "MIF_LTEST_SEL 
        TIF_DOUT1 TIF_DOUT2 TIM_DOUT1_IO_DIR "]
    set_false_path -to $dti_outputs
   
    # MIF_DTI_CLK, MIF_DTI_SEL, CD_WRITE_DATA
    # CD_WRITE_DATA, MIF_DTI_SEL are registered within DTI block on MIF_DTI_CLK
    # The timing for these signals is handled in design. The tag controller sets
    # DATA and SEL 1 clock ahead of the CLK edge and holds it for many clocks
    # after. 
    set dti_outputs2 [get_ports "MIF_DTI_SEL CD_WRITE_DATA"]
    # set_output_delay 0 $dti_outputs2 -clock [get_clocks OSC_CLK]
    set_false_path -to $dti_outputs2
               
    
    # DEMOD Outputs 
    # Discussed with John H. 6/29/18.
    # The following outputs from TC have analog destinations.
    # No setup, hold, skew requirements. Functional requirements
    # and implementation unchanged from RX3. 
    set demod_outputs [get_ports "RX_DEMOD_EN_UT RX_DEMOD_FT_EN \
        TIM_DEMOD_ENV_EN TIM_DEMOD_HOLD"]
    # set_output_delay 0 $demod_outputs -clock [get_clocks OSC_CLK]
    set_false_path -to $demod_outputs

    # OSC Outputs
    # RX4 Tag DS - section 11.12.2
    # In order to have glitchless switching between full-rate and reduced rate
    # clocks on OSC_CLK, it is important to ensure that TIM_CLK_DIV2_EN and 
    # TIM_CLK_DIV4_EN signals arrive at the rx4po_osc_digital block inputs
    # well advance of the falling edge of clk_main signal in this block.
    # Which means these signals have less than half cycle from OSC_CLK to TC
    # output. The constraint below gives (half clock - 100ns) to TC and gives
    # 100ns for routing and delay within rx4po_osc_digital.
    set osc_outputs [get_ports "TIM_CLK_DIV2_EN TIM_CLK_DIV4_EN"]
    set_output_delay [expr $OSC_CLK_PERIOD_UNSCALED/2 + 100.0] $osc_outputs \
                     -clock [get_clocks OSC_CLK]
    # Analog destination for TIM_OSC_BOOST[2:0]. No specific timing requirement.
    # set_false_path -to [get_ports "TIM_OSC_BOOST* MIF_OSC_CAL* MIF_CAL_DONE"]

    # TC --> ARNG
    # No specific timing requirements, need to reach ARNG block within a reasonable time.
    # Giving 1 clock cycle to both
    set arng_outputs [get_ports "TIM_ARNG_CLK TIM_ARNG_EN"]
    set_output_delay 0 $arng_outputs -clock [get_clocks OSC_CLK]
    
    # Other signals which do not have any timing requirements
    # Analog destinations: MIF_AT_DIS,  
    #set noconn_outputs [get_ports "TIM_PACKET_FAST_TARI"]
    #set_false_path -to $noconn_outputs

    set other_outputs [get_ports "MIF_AT_DIS TIM_STATE_RX"]
    # set_output_delay 0 $other_outputs -clock [get_clocks OSC_CLK]
    set_false_path -to $other_outputs

    
    # TC --> MOD
    # TX_MOD_DATA has an analog destination. No capture clock involved.
    # No specific timing requirements, 
    # needs to reach MOD block within a reasonable time. Giving 1 clock cycle.
    set mod_output [get_ports "TX_MOD_DATA"]
    set_output_delay 0 $mod_output -clock [get_clocks OSC_CLK]



    # CM / Countermeasure outputs
    # Timing is fairly lose on these, but would like to keep them within a clock cycle




######################################## Merged from the NVM Controller ##################################################



#################################################################################
# Constraining input and output ports set_input_delay set_output_delay          #
#################################################################################

# Set the driving cell default from TC -> NVM ports to be worst case
# driven by an INVXL. Should this include the drive strength of an
# analog -> Controller port or just a digital to digital port?
#set_driving_cell  -lib_cell INVXL  [ all_inputs ]

# Confirmed that in TC the driving strength of the buffer is higher than this
#set_driving_cell  -lib_cell BUFX9 [get_ports SREG_AND_SAMP_CLK ]
#set_driving_cell  -lib_cell BUFX9  [get_ports HVS_CLK ]
#set_driving_cell  -lib_cell BUFX9 [get_ports CONFIG_CLK ]



# Combinational Delay (Input Delay) on Input Ports from previous block
# specified relative to a virtual or real clock
# ex: BIT_ADDR changes in MIF on TIM_MIF_CLOCK, which is virtual to NVM controller
#
# set_input_delay  -clock [ get_ports ]

# TIM_MIF_CLK
# These TC to NVMC 1/2 clock cycle paths.
# 150ns given to TC_top-level routing, rest used inside NVMC
#if {$env(design_phase) == "SYNTH"} {
#    set_input_delay -max 140 -clock TIM_MIF_CLK [ get_ports WORD_ADDR ]
#    set_input_delay -max 140 -clock TIM_MIF_CLK [ get_ports BIT_ADDR ]
#} else {
#    set_input_delay -max 150 -clock TIM_MIF_CLK [ get_ports WORD_ADDR ]
#    set_input_delay -max 150 -clock TIM_MIF_CLK [ get_ports BIT_ADDR ]
#}
#set_input_delay -max 150 -clock TIM_MIF_CLK [ get_ports READ ]
#set_input_delay -max 150 -clock TIM_MIF_CLK [ get_ports WRITE ]
#set_input_delay -max 150 -clock TIM_MIF_CLK [ get_ports MARGIN_READ_DTI_EN ]
#set_input_delay -max 150 -clock TIM_MIF_CLK [ get_ports MIF_CAL_DONE ]
#set_input_delay -min 1   -clock TIM_MIF_CLK [ get_ports WORD_ADDR ]
#set_input_delay -min 1   -clock TIM_MIF_CLK [ get_ports BIT_ADDR ]
#set_input_delay -min 1   -clock TIM_MIF_CLK [ get_ports READ ]
#set_input_delay -min 1   -clock TIM_MIF_CLK [ get_ports WRITE ]
#set_input_delay -min 1   -clock TIM_MIF_CLK [ get_ports MARGIN_READ_DTI_EN ]
#set_input_delay -min 1   -clock TIM_MIF_CLK [ get_ports MIF_CAL_DONE ]
#set_input_delay -min 1   -clock TIM_MIF_CLK [ get_ports NVM_READ_DONE ]
#set_input_delay -max 150 -clock TIM_MIF_CLK [ get_ports NVM_READ_DONE ]
#set_input_delay -min 1   -clock TIM_MIF_CLK [ get_ports NVM_READ_ERROR ]
#set_input_delay -max 150 -clock TIM_MIF_CLK [ get_ports NVM_READ_ERROR ]


# Sense amp resolution time spec is in reference to the falling edge of READ_SAMP_CLK
# this needs to add in the high time for read_samp_clk to work with DC cons
#
# NOTE: the 990 samp resolution spec does not account for any additional margin
# ( $scaling_factor ), so when constraining with regular osc_period to account for the
# clock high time, we don't have any time for logic AKA the input_delay
# is greater than the clock period. We must loosen the input delay on this path to be
# realistic to account for some additional synthesis margin on the SREG_AND_SAMP_CLK
#
# the reason we are scaling by a smaller number than scaling_factor
# is because we want to shorten the input delay on the path
# ( shorter amount of clock "high time" )
#
# set samp_resolution [ expr 990.0 + $osc_period/2.0 ]

# set samp_resolution [ expr 990.0 + ($osc_cal_period * $osc_samp_input_delay_margin)/2.0 ]
# FIXME: check with Charles 6/14/18
set samp_resolution 990.0

# Max delay comes from Sense Amp resolution time
# Min delay should not be an issue because the edge of the clock causes
# the signals to toggle and then they get captured back on the same clock
# By design there should not be a hold issue unless there are weird skews
# MIF_NVM_SCLK and READ_SAMP_CLK


# WRITE_SREG_EXPECTED is generated by col_en_b, which is decoded col_addr, col_addr from read_samp_clk
# WRITE_SREG_EXPECTED is generated from a FF inside NVM core clocked by WRITE_SREG_CLK
#Min time is the minimum amount of time for the signal to go from known to unknown from
# read_ctrl_clk changing at our Output to WRITE_SREG_* going invalid at our Input. 
#The smaller this value, the more buffers the nvmc will add to meet hold timing
#Setting ICC constraint to be harder than PT

## MIF_NVM_SCLK
#set_input_delay  -max 5 -clock MIF_NVM_SCLK [ get_ports MIF_MEM_ADDR_IN_NVM ]
#set_input_delay  -min 1 -clock MIF_NVM_SCLK [ get_ports MIF_MEM_ADDR_IN_NVM ]


# TIM_CD_CLK
#set_input_delay  -max 150 -clock TIM_CD_CLK [ get_ports CORE_CONFIG_MRAIR_DATA ]
#set_input_delay  -max 150 -clock TIM_CD_CLK [ get_ports WRITE_LENGTH ]
#set_input_delay  -max 150 -clock TIM_CD_CLK [ get_ports MARGIN_READ_AIR_EN ]
#set_input_delay  -min   1 -clock TIM_CD_CLK [ get_ports CORE_CONFIG_MRAIR_DATA ]
#set_input_delay  -min   1 -clock TIM_CD_CLK [ get_ports WRITE_LENGTH ]
#set_input_delay  -min   1 -clock TIM_CD_CLK [ get_ports MARGIN_READ_AIR_EN ]




# HVS
#
# Per RX2 Datasheet: 
# The high voltage system updates its outputs on the falling edge of HVS_CLK 
# while the NVM controller samples these signals on the rising edge.
set_input_delay  -max 5 -clock HVS_CLK -clock_fall [ get_ports HVS_FB_OK ]
set_input_delay  -max 5 -clock HVS_CLK -clock_fall [ get_ports HVS_BG_OK ]
set_input_delay  -min 1 -clock HVS_CLK -clock_fall [ get_ports HVS_FB_OK ]
set_input_delay  -min 1 -clock HVS_CLK -clock_fall [ get_ports HVS_BG_OK ]







# Combinational Delay (Output Delay: other block combo max delay + Tsetup)
# on Output ports from current block 
#
# this will be the timing constraint being placed inside current block
# combo in reg -> my_combo -> output
# set_output_delay 
#
# will need to create a virtual clock for the MIF clock that captures
# as it related to READ_SAMP_CLK the output signals that go back to the TC
#

#####################################################################################
# NVM Control -> TC
#        output    reg                                   READ_DATA_AND_MR_MATCH,
#        output                                          READ_PARITY_ERROR,
#        output    reg                                   READ_AND_MR_VALID,
#        output    reg                                   MR_VALID,
#        output                                          WRITE_DONE,
#        output                                          HVS_CHK_FAIL,




# NVM_DONE is inputted into the MIF and the TIM
# NVM_DONE goes into TIM line 683 ( else if TIM_STATE_WRITE )
#       appears to be used in tim SM and is clocked by TIM_CLK
#       this updates the clock_state_d (clocked by TIM_CLK) and turns on TIM_MIF_CLK
#
# NVM_DONE goes into MIF for 
#set_output_delay  -max 10 -clock TIM_CLK [ get_ports WRITE_DONE ]
#set_output_delay  -min  1 -clock TIM_CLK [ get_ports WRITE_DONE ]


# MR_VALID clocked by TIM_MIF_CLK on line 180 of mif_rules
# registers if MR_AIR_POWER is ok. If we are not in margin read mode, MR_VALID will always be
# stable. All components contributing to MR_VALID ( hvs_mr_ok_filt, mr_done, hvs_bg_ok_filt_mr )
# are multi-cycle state machine driven signals that are guranteed to be stable
#
# either turn off timing for this or set_multicycle_path?
#
# not doing wildcard bc READ_AND_MR_VALID is not routed to TC
# set_output_delay  10 -clock TIM_MIF_CLK [ get_ports *MR_VALID ]
#set_output_delay  -max 10 -clock TIM_MIF_CLK [ get_ports MR_VALID ]
#set_output_delay  -min  1 -clock TIM_MIF_CLK [ get_ports MR_VALID ]




# READ_DATA_AND_MR_MATCH
# line 36 of tc_register_mem_data clocks on TIM_NVM_SCLK (SREG_AND_SAMP_CLK)
# line 189 of mif_rules clocks on TIM_MIF_CLK during margin read for mr_air_fail
#
# what is the tighter timing constraint?
# is appears as if the TIM_MIF_CLK timing constraint is always failing for this and read_and_mr_valid
#
#
# there is a violation when capturing on TIM_MIF_CLK for this signal... talk
# to jesse about potential problem with margin read speeds at 640+8%.
# set_output_delay  10 -clock TIM_MIF_CLK [ get_ports READ_DATA_AND_MR_MATCH ]

#set_output_delay  -max 10 -clock SREG_AND_SAMP_CLK [ get_ports READ_DATA_AND_MR_MATCH ]
#set_output_delay  -min  1 -clock SREG_AND_SAMP_CLK [ get_ports READ_DATA_AND_MR_MATCH ]




# HVS_CHK_FAIL
# contributes to mif state machine on TIM_MIF_CLK line 526
#
#set_output_delay  -max 10 -clock TIM_MIF_CLK [ get_ports HVS_CHK_FAIL ]
#set_output_delay  -min  1 -clock TIM_MIF_CLK [ get_ports HVS_CHK_FAIL ]


# CONFIG_OUT
#   Drives RULES_CACHED_DATA in the MIF, which drives MIF_MEM_DATA in CD.
#   Half-cycle path from CONFIG_CLK to TIM_CD_CLK. Give 100% margin for global route.
#set_output_delay  -max [expr 100.0 * 2.0] -clock TIM_CD_CLK [ get_ports CONFIG_OUT ]
#set_output_delay  -min  1 -clock TIM_CD_CLK [ get_ports CONFIG_OUT ]


#SREG_AND_SAMP_CLK renamed to MIF_NVM_SCLK
########################################################################

# NVM Control -> NVM Core
#
# the majority of these signals go straight to combinational logic
# and are not sampled by any registers inside the NVM
#


########################################################################

# NVM Control -> HVS
#



########################################################################

# FIXME: All of these outputs go into the CORE or the HVS (or RECT). The
# delay and capture are unclear. Give a liberal amount of delay and
# assume capture on the fastest clock.


#These ports are causing us trouble in P&R and have been confirmed with the analog
#designer that their timing relation to the HVS_CLK is not important








    
