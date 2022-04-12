# From Jesse 
# INIT: http://wavedrom.com/editor.html?%7Bsignal%3A%20%5B%0A%20%20%7Bname%3A%20%27OSC_CLK%27%2C%09%09wave%3A%20%270101010101010101010101010%27%7D%2C%0A%20%20%7Bname%3A%20%27NVM_HVS_CLK%27%2C%09wave%3A%20%270........................%27%7D%2C%0A%20%20%7Bname%3A%20%27TIM_CLK%27%2C%09%09wave%3A%20%270101010101010101010101010%27%7D%2C%0A%20%20%7Bname%3A%20%27CD_CLK%27%2C%09%09wave%3A%20%270.10.....................%27%7D%2C%0A%20%20%7Bname%3A%20%27MIF_CLK%27%2C%20%09wave%3A%20%270.......10....10.........%27%7D%2C%0A%20%20%7Bname%3A%20%27NVM_SCLK%27%2C%09wave%3A%20%270........10....10........%27%7D%2C%0A%20%20%7Bname%3A%20%27SM_CLK%27%2C%20%20%09wave%3A%20%270.....10.................%27%7D%2C%0A%20%20%7B%7D%2C%0A%20%20%7Bname%3A%20%27TX_LF_CLK%27%2C%09wave%3A%20%270........................%27%7D%2C%0A%20%20%7Bname%3A%20%27TX_D_CLK%27%2C%09wave%3A%20%270...10...................%27%7D%2C%0A%20%20%7Bname%3A%20%27tx_m_clk%27%2C%09wave%3A%20%270........................%27%7D%2C%0A%20%20%7B%7D%2C%0A%20%20%7Bname%3A%20%27RX_CLOCK%27%2C%09wave%3A%20%271010101010101010101010101%27%7D%2C%0A%20%20%7Bname%3A%20%27RX_CLK_DIV2%27%2C%09wave%3A%20%2710.......................%27%7D%2C%0A%20%20%7Bname%3A%20%27RX_SCLK%27%2C%09%09wave%3A%20%2710.......................%27%7D%2C%0A%20%20%7Bname%3A%20%27RX_CLKN_B%27%2C%09wave%3A%20%271........................%27%7D%2C%0A%20%20%0A%5D%2C%0A%20%20%0A%20%20%20head%3A%7B%0A%20%20%20text%3A%27TIM%20clock%20Edges.%20Worst%20Case%20at%20INIT.%20OSC_CLK%3D1920%27%2C%0A%20%20%20tick%3A0%2C%0A%20%7D%2C%0A%20foot%3A%7B%0A%20%20%20tick%3A0%2C%0A%20%7D%2C%0A%7D%0A%20%20%0A%0A

# TX: https://wavedrom.com/editor.html?%7Bsignal%3A%20%5B%0A%20%20%7Bname%3A%20%27OSC_CLK%27%2C%09%09wave%3A%20%27010101010101010%27%7D%2C%0A%20%20%7Bname%3A%20%27NVM_HVS_CLK%27%2C%09wave%3A%20%27010101010101010%27%7D%2C%0A%20%20%7Bname%3A%20%27TIM_CLK%27%2C%09%09wave%3A%20%27010101010101010%27%7D%2C%0A%20%20%7Bname%3A%20%27CD_CLK%27%2C%09%09wave%3A%20%270.10..10..10..1%27%7D%2C%0A%20%20%7Bname%3A%20%27MIF_CLK%27%2C%20%09wave%3A%20%270...10..10..10.%27%7D%2C%0A%20%20%7Bname%3A%20%27NVM_SCLK%27%2C%09wave%3A%20%270....10..10..10%27%7D%2C%0A%20%20%7Bname%3A%20%27SM_CLK%27%2C%20%20%09wave%3A%20%270.....10..10..1%27%7D%2C%0A%20%20%7B%7D%2C%0A%20%20%7Bname%3A%20%27TX_LF_CLK%27%2C%09wave%3A%20%270..1.0.1.0.1.0.%27%7D%2C%0A%20%20%7Bname%3A%20%27TX_D_CLK%27%2C%09wave%3A%20%270.1.0.1.0.1.0.1%27%7D%2C%0A%20%20%7Bname%3A%20%27tx_m_clk%27%2C%09wave%3A%20%270.1.0.1.0.1.0.1%27%7D%2C%0A%20%20%7B%7D%2C%0A%20%20%7Bname%3A%20%27RX_CLOCK%27%2C%09wave%3A%20%27101010101010101%27%7D%2C%0A%20%20%7Bname%3A%20%27RX_CLK_DIV2%27%2C%09wave%3A%20%2710..10..10..10.%27%7D%2C%0A%20%20%7Bname%3A%20%27RX_SCLK%27%2C%09%09wave%3A%20%2710......10.....%27%7D%2C%0A%20%20%7Bname%3A%20%27RX_CLKN_B%27%2C%09wave%3A%20%271.0.1.....0.1..%27%7D%2C%20%20%0A%5D%2C%0A%20%20%0A%20%20%20head%3A%7B%0A%20%20%20text%3A%27TIM%20clock%20Edges.%20Based%20on%20worst%20case%20backscatter%20(TX)%20with%20RX%20clock%20relationships%20built%20in%27%2C%0A%20%20%20tick%3A0%2C%0A%20%7D%2C%0A%20foot%3A%7B%0A%20%20%20tick%3A0%2C%0A%20%7D%2C%0A%7D%0A%20%20%0A%0A

set PORT_OSC_CLK       [get_ports OSC_CLK]
set PORT_DTI_DIN_CLK   [get_ports DTI_DIN]
set PORT_DTI_CLK       [get_ports DTI_CLK]

set PIN_TIM_CLK   "I_tc_tim/I_tim_clk_FORCE_KEEP/Y"
set PIN_TIM_CLK_B "I_tc_tim/I_tim_clk_b_FORCE_KEEP/Y"
set PIN_TIM_CD_CLK    "I_tc_tim/I_tim_cd_clk_FORCE_KEEP/Y"
set PIN_TIM_SM_CLK    "I_tc_tim/I_tim_sm_clk_FORCE_KEEP/Y"
set PIN_TIM_MIF_CLK   "I_tc_tim/I_tim_mif_clk_FORCE_KEEP/Y"
set PIN_TIM_NVM_SREG_CLK_PRE "I_tc_tim/I_nvm_sreg_clk_1_ssff_FORCE_KEEP/Q"
set PIN_TIM_NVM_SREG_CLK "I_tc_tim/I_tim_nvm_sreg_clk_FORCE_KEEP/Y"
set PIN_TIM_NVM_CLK "I_tc_tim/I_tim_nvm_clk_FORCE_KEEP/Y"
set PIN_TX_D_CLK  "I_tc_tim/I_tim_tx_d_clk_FORCE_KEEP/Y"
set PIN_TX_LF_CLK  "I_tc_tim/I_tim_tx_lf_clk_FORCE_KEEP/Y"
set PIN_RNG_CLK    "I_tc_tim/I_tim_rng_clk_FORCE_KEEP/Y"
set PIN_ARNG_CLK    "I_tc_tim/I_tim_arng_clk_FORCE_KEEP/Y"
set PIN_EARLY_Y_CLK "I_tc_tim/i_tc_tim_timers/i_EARLY_EXPIRED_Y_FORCE_KEEP/Q";
set PIN_EXPIRED_Y_CLK "I_tc_tim/i_tc_tim_timers/i_expired_Y_FORCE_KEEP/QN";
 
set PIN_RX_CLOCK   "I_tc_rx/AT/CK_FORCE_KEEP_v/U3_BUF_FORCE_KEEP/Y"
set PIN_RX_CLK_DIV2 "I_tc_rx/AT/CK_FORCE_KEEP_v/U6_BUF_FORCE_KEEP/Y"
set PIN_RX_CLOCK_B "I_tc_rx/AT/EDGE_v/clk_inv_FORCE_KEEP_0/Y"
set PIN_RX_CLK     "I_tc_rx/AT/EDGE_v/clk_inv_FORCE_KEEP_1/Y"
set PIN_RX_SCLK    "I_tc_rx/AT/NPF_v/sclk_gate_FORCE_KEEP_0/Y"
set PIN_RX_CLKN_B  "I_tc_rx/AT/EDGE_v/i_CLKN_B_FORCE_KEEP/Y";
set PIN_RX_CLKP    "I_tc_rx/AT/EDGE_v/i_CLKP_FORCE_KEEP/Y";
set PIN_CNTP_EN    "I_tc_rx/AT/NPF_v/I_cntp_en_buf_FORCE_KEEP/Y";

## Not tying this to a leaf cell causes Warnings in our flows
#set PIN_TIM_DTI_CLK "I_tc_mif/MIF_DTI_CLK"
set PIN_TIM_DTI_CLK [filter_collection [get_pins -of [filter_collection [all_fanin -to [get_pin I_tc_mif/MIF_DTI_CLK] -flat -only_cells -levels 1] is_hierarchical==false]] direction==out]

set PIN_TIM_WAIT_WRITE "I_tc_tim/i_tim_st_waitorwrite_buf_FORCE_KEEP/Y"
set PIN_TIM_SM_ST_CLK     "I_tc_tim/i_tim_st_sm_inv_FORCE_KEEP/Y"
if {$env(design_phase) == "SYNTH"} {
    set PIN_TIM_RX1_CLK     "I_tc_crc/CRC_PASS_reg/enable"
    set PIN_TIM_RX2_CLK     "I_tc_tim/tim_state_wait_vs_write_reg/enable"
} elseif {$env(design_phase) == "STA" || $env(design_phase) == "PNR"} {
    set PIN_TIM_RX1_CLK    "I_tc_crc/CRC_PASS_reg/GN"
    set PIN_TIM_RX2_CLK    "I_tc_tim/tim_state_wait_vs_write_reg/GN"
}

set PIN_FIRSTCLOCKS "I_tc_tim/I_firstclocksdone_buf_FORCE_KEEP/Y"

set PIN_HVS_CLK   "I_tc_tim/I_tim_nvm_hvs_clk_FORCE_KEEP/Y"

create_clock    -name OSC_CLK       -period $OSC_CLK_PERIOD $PORT_OSC_CLK
#The DTI_DIN_CLK max freq is half that of OSC_CLK when performing the compare_valid strobes. Punctured clock.
create_clock    -name DTI_DIN_CLK   -period [expr $OSC_CLK_PERIOD*2] -waveform " 0.0 [expr $OSC_CLK_PERIOD/2]" $PORT_DTI_DIN_CLK
create_clock    -name DTI_CLK       -period $OSC_CLK_PERIOD $PORT_DTI_CLK

# Outputs of TIM block 
create_generated_clock -name TIM_CLK      -source $PORT_OSC_CLK -divide_by 1 [get_pins $PIN_TIM_CLK]
create_generated_clock -name TIM_CLK_B    -source $PORT_OSC_CLK -divide_by 1 -invert [get_pins $PIN_TIM_CLK_B]
create_generated_clock -name FIRSTCLKDONE_CLK -source $PIN_TIM_CLK -divide_by 8 [get_pins $PIN_FIRSTCLOCKS]

if { $CASE_ANALYSIS == "INIT" } {

    #MIF / NVM clocks only
    set_case_analysis 0 [get_pins $PIN_TIM_CD_CLK]
    
    set_case_analysis 0 [get_pins $PIN_TIM_SM_CLK ]
    set_case_analysis 0 [get_pins $PIN_RX_CLOCK  ]
    set_case_analysis 0 [get_pins $PIN_RX_CLOCK_B ]
    set_case_analysis 0 [get_pins $PIN_RX_CLK  ]
    set_case_analysis 0 [get_pins $PIN_RX_CLK_DIV2  ]
    set_case_analysis 0 [get_pins $PIN_RX_SCLK  ]
    set_case_analysis 0 [get_pins $PIN_RX_CLKN_B  ]
    set_case_analysis 0 [get_pins $PIN_RX_CLKP  ]
    ##set_case_analysis 0 [get_pins $PIN_TIM_TX_CLK  ]
    set_case_analysis 0 [get_pins $PIN_TX_D_CLK  ]
    set_case_analysis 0 [get_pins $PIN_TX_LF_CLK  ]

    set_case_analysis 0 $PORT_DTI_DIN_CLK
    set_case_analysis 0 $PORT_DTI_CLK

    #MIF CLK at every 3 tim clocks
    create_generated_clock -name TIM_MIF_CLK      -source $PIN_TIM_CLK -master TIM_CLK \
        -add -combinational -edges { 4 5 10 } [get_pins $PIN_TIM_MIF_CLK];

    # Jesse 04/27/21 - RNG_CLK should match MIF_CLK due to the INIT sequence. 
    create_generated_clock -name RNG_CLK      -source $PIN_TIM_CLK -master TIM_CLK \
        -add -combinational -edges { 4 5 10 }  [get_pins $PIN_RNG_CLK]; 

} elseif { $CASE_ANALYSIS == "RX" || $CASE_ANALYSIS == "TX" } {

    #Combining RX and TX into a single case right now.
    #If we were to separate the cases, we could run the rx/cd at a lower speed, but those aren't usually the worst case setup paths. 

    #MIF CLK at every 2 tim clocks
    create_generated_clock -name TIM_MIF_CLK      -source $PIN_TIM_CLK -master TIM_CLK \
        -add -combinational -edges { 4 5 8 } [get_pins $PIN_TIM_MIF_CLK];
    #This is much faster than the RNG clock runs during normal operation, but should be good for timing analysis.
    create_generated_clock -name RNG_CLK      -source $PIN_TIM_CLK -master TIM_CLK \
        -add -combinational -preinvert [get_pins $PIN_RNG_CLK]; 



} else {
    puts "Error: CASE_ANALYSIS not found. 'CASE_ANALYSIS'='${CASE_ANALYSIS}"
    exit 1
}




create_generated_clock -name TIM_CD_CLK       -source $PIN_TIM_CLK -master TIM_CLK \
    -add -combinational -edges { 2 3 6 } [get_pins $PIN_TIM_CD_CLK];


#Rises when tim_clk rises
create_generated_clock -name wait_or_write_clk -source $PIN_TIM_CLK -master TIM_CLK \
    -add -divide_by 4 [get_pins $PIN_TIM_WAIT_WRITE]
#Falls when tim_clk rises
create_generated_clock -name tim_smst_clk -source $PIN_TIM_CLK -master TIM_CLK \
    -add -divide_by 4 -invert [get_pins $PIN_TIM_SM_ST_CLK]

create_generated_clock -name tim_rx1_clk -source $PIN_TIM_CLK -master TIM_CLK \
     -add -divide_by 4 [get_pins $PIN_TIM_RX1_CLK]
create_generated_clock -name tim_rx2_clk -source $PIN_TIM_CLK -master TIM_CLK \
     -add -divide_by 4 [get_pins $PIN_TIM_RX2_CLK]

create_generated_clock -name TIM_SM_CLK       -source $PIN_TIM_CLK -master TIM_CLK \
    -add -combinational -edges { 2 3 6 } [get_pins $PIN_TIM_SM_CLK];
create_generated_clock -name EARLY_Y_CLK -source $PIN_TIM_CLK -master TIM_CLK \
    -add -edges { 2 4 6 } [get_pins $PIN_EARLY_Y_CLK];
create_generated_clock -name TX_D_CLK      -source $PIN_EARLY_Y_CLK  -master EARLY_Y_CLK \
    -add -combinational -divide_by 1  [get_pins $PIN_TX_D_CLK];
create_generated_clock -name EXPIRED_Y_CLK -source $PIN_TIM_CLK -master TIM_CLK \
    -add -edges { 3 5 9 } [get_pins $PIN_EXPIRED_Y_CLK];
# set_case_analysis 0 I_tc_tim/I_tx_lf_clk_mux_FORCE_KEEP/S0
create_generated_clock -name TX_LF_CLK    -source $PIN_EXPIRED_Y_CLK -master EXPIRED_Y_CLK \
    -add -divide_by 1 -combinational [get_pins $PIN_TX_LF_CLK];
#TIM_NVM_SCLK in case analysis
create_generated_clock -name ARNG_CLK     -source $PORT_OSC_CLK -divide_by 32 [get_pins $PIN_ARNG_CLK]; # Jesse 03/20/18

create_generated_clock -name TIM_NVM_CLK -source $PIN_TIM_CLK -divide_by 1 $PIN_TIM_NVM_CLK 

create_generated_clock -name tim_nvm_sreg_clk_pre  -source $PIN_TIM_CLK -master TIM_CLK \
        -add -divide_by 2 [get_pins $PIN_TIM_NVM_SREG_CLK_PRE];
create_generated_clock -name TIM_NVM_SREG_CLK      -source $PIN_TIM_NVM_SREG_CLK_PRE -master tim_nvm_sreg_clk_pre \
        -add -divide_by 1 [get_pins $PIN_TIM_NVM_SREG_CLK];


create_generated_clock -name TIM_DTI_CLK      -source $PIN_TIM_MIF_CLK -divide_by 1 [get_pins $PIN_TIM_DTI_CLK]; 



# Clocks generated within RX block
create_generated_clock -name RX_CLOCK    -source $PIN_TIM_CLK  -combinational -invert -divide_by 1 [get_pins $PIN_RX_CLOCK]
create_generated_clock -name RX_CLOCK_B  -source $PIN_RX_CLOCK -combinational -invert -divide_by 1 [get_pins $PIN_RX_CLOCK_B ]
create_generated_clock -name RX_CLK      -source $PIN_RX_CLOCK_B -combinational -invert -divide_by 1         [get_pins $PIN_RX_CLK ]
create_generated_clock -name RX_CLK_DIV2 -source $PIN_TIM_CLK  -combinational -edges { 2 3 6 }   [get_pins $PIN_RX_CLK_DIV2]
create_generated_clock -name RX_SCLK     -source $PIN_RX_CLOCK  -edges { 3 4 11 }    [get_pins $PIN_RX_SCLK ]
create_generated_clock -name RX_CLKN_B   -source $PIN_RX_CLOCK  -edges { 7 13 15 }  [get_pins $PIN_RX_CLKN_B ]
create_generated_clock -name RX_CLKP     -source $PIN_RX_CLOCK  -edges { 1 3 9 } [get_pins $PIN_RX_CLKP ]

#Due to the extensive clock gating, almost all logic in the tag ends up being treated at a clock. 
#This is an attempt to prevent the clock paths from propagating through the datapaths. 
#In icc check the output of report_clock_tree to inspect the clocks
if { $env(design_phase) == "PNR" || $env(design_phase) == "STA"} {

    #FIXME: need to run these in PT and confirm all clocks can find their path to their master?
    if { $env(design_phase) == "PNR" } {
        set_clock_tree_exceptions -clocks OSC_CLK -stop_pins [list I_tc_tim/I_tim_clk_FORCE_KEEP/Y I_tc_tim/I_tim_clk_b_FORCE_KEEP/Y]
    } else {
       # set_clock_sense -clocks OSC_CLK -stop_propagation [list I_tc_tim/I_tim_clk_FORCE_KEEP/Y I_tc_tim/I_tim_clk_b_FORCE_KEEP/Y]
    }

    set_clock_sense -clocks TIM_CLK -stop_propagation [list I_tc_sm/SM_TRCAL_reg*_/Q* ]
    #set_clock_sense -clocks TIM_CLK -stop_propagation I_tc_tim/I_tim_sm_clk_FORCE_KEEP/A
    #set_clock_sense -clocks TIM_CLK -stop_propagation [list I_tc_tim/tim_state_ff*_FORCE_KEEP/Q*]
    #set_clock_sense -clocks TIM_CLK -stop_propagation I_tc_tim/I_tim_nvm_hvs_clk_FORCE_KEEP/A
    set_clock_sense -clocks TIM_CLK -stop_propagation [list I_tc_tim/i_tc_tim_timers/i_EARLY_EXPIRED_*_FORCE_KEEP/Q*]
    #set_clock_sense -clocks TIM_CLK -stop_propagation [list I_tc_tim/I_nvm_sclk_*_ssff_FORCE_KEEP/CK]
    set_clock_sense -clocks TIM_CLK -stop_propagation [list I_tc_rx/AT/NPF_v/I_sym_clk_pre_reg_FORCE_KEEP/Q \
   I_tc_rx/AT/NPF_v/U_sym_clk_pre_buf_FORCE_KEEP/A \
   I_tc_rx/AT/STATE_v/RX_PI_SYNCWORD_reg/Q ]

    #Applying only to TIM_CLK did not work. Applying to all clocks.
    #set_clock_sense -stop_propagation [list I_tc_tim/tim_state_ff*_FORCE_KEEP/Q*]

  #set_clock_sense -clocks TIM_MIF_CLK -stop_propagation [list I_tc_mif/I_tc_mif_cache/pc_word_cache_reg*/Q*]    
#set_clock_sense -clocks TIM_MIF_CLK -stop_propagation [list I_tc_mif/I_tc_mif_state_machine/MIF_STATE_reg_*_FORCE_KEEP/Q*]    
#set_clock_sense -clocks TIM_MIF_CLK -stop_propagation [list I_tc_mif/I_tc_mif_rules/I_mif_mem_limit_check/LAST_MEM_BIT_ENC_KEY_reg/Q*]    
#set_clock_sense -clocks TIM_MIF_CLK -stop_propagation [list I_tc_mif/I_tc_mif_state_machine/MIF_NVM_READ_reg_FORCE_KEEP/Q*]    

    set_clock_sense -clocks wait_or_write_clk -stop_propagation [list  I_tc_tim/I_tx_m_clk_buf_FORCE_KEEP/A ]

    set_clock_sense -clocks tim_rx2_clk -stop_propagation [list I_tc_tim/tim_state_wait_vs_write_reg/Q* ]
    set_clock_sense -clocks TIM_SM_CLK -stop_propagation [list I_tc_sm/SM_*reg*/Q*]
    set_clock_sense -clocks [list  RX_CLOCK RX_CLOCK_B RX_CLK RX_SCLK ] -stop_propagation [list I_tc_rx/AT/STATE_v/rx_state_3_0_reg*/Q* \
                                                              I_tc_rx/AT/STATE_v/RX_PI_SYNCWORD_reg/Q* ]
}



# Create clocks on latch enable pins for these to get timed
# create_generated_clock -name cal_cache_lat_en -source

# Async ripple counters = FUN
# X timer within tc_tim_timers
set Xbit1_ckpin "I_tc_tim/i_tc_tim_timers/i_bit1_X_FORCE_KEEP/CK"
set Xbit2_ckpin "I_tc_tim/i_tc_tim_timers/i_bit2_X_FORCE_KEEP/CK"
set Xbit3_ckpin "I_tc_tim/i_tc_tim_timers/i_bit3_X_FORCE_KEEP/CK"
set Xbit4_ckpin "I_tc_tim/i_tc_tim_timers/i_bit4_X_FORCE_KEEP/CK"
set Xbit5_ckpin "I_tc_tim/i_tc_tim_timers/i_bit5_X_FORCE_KEEP/CK"
set Xbit6_ckpin "I_tc_tim/i_tc_tim_timers/i_bit6_X_FORCE_KEEP/CK"
set Xbit7_ckpin "I_tc_tim/i_tc_tim_timers/i_bit7_X_FORCE_KEEP/CK"
set Xbit8_ckpin "I_tc_tim/i_tc_tim_timers/i_bit8_X_FORCE_KEEP/CK"
set Xbit9_ckpin "I_tc_tim/i_tc_tim_timers/i_bit9_X_FORCE_KEEP/CK"
create_generated_clock -name Xbit1_clk  -source $PIN_TIM_CLK  -divide_by 2 [get_pins $Xbit1_ckpin]
create_generated_clock -name Xbit2_clk  -source $Xbit1_ckpin  -divide_by 2 [get_pins $Xbit2_ckpin]
create_generated_clock -name Xbit3_clk  -source $Xbit2_ckpin  -divide_by 2 [get_pins $Xbit3_ckpin]
create_generated_clock -name Xbit4_clk  -source $Xbit3_ckpin  -divide_by 2 [get_pins $Xbit4_ckpin]
create_generated_clock -name Xbit5_clk  -source $Xbit4_ckpin  -divide_by 2 [get_pins $Xbit5_ckpin]
create_generated_clock -name Xbit6_clk  -source $Xbit5_ckpin  -divide_by 2 [get_pins $Xbit6_ckpin]
create_generated_clock -name Xbit7_clk  -source $Xbit6_ckpin  -divide_by 2 [get_pins $Xbit7_ckpin]
create_generated_clock -name Xbit8_clk  -source $Xbit7_ckpin  -divide_by 2 [get_pins $Xbit8_ckpin]
create_generated_clock -name Xbit9_clk  -source $Xbit8_ckpin  -divide_by 2 [get_pins $Xbit9_ckpin]

# Y timer within tc_tim_timers
set Ybit2_ckpin "I_tc_tim/i_tc_tim_timers/i_bit2_Y_FORCE_KEEP/CK"
set Ybit3_ckpin "I_tc_tim/i_tc_tim_timers/i_bit3_Y_FORCE_KEEP/CK"
set Ybit4_ckpin "I_tc_tim/i_tc_tim_timers/i_bit4_Y_FORCE_KEEP/CK"
set Ybit5_ckpin "I_tc_tim/i_tc_tim_timers/i_bit5_Y_FORCE_KEEP/CK"
set Ybit6_ckpin "I_tc_tim/i_tc_tim_timers/i_bit6_Y_FORCE_KEEP/CK"
set Ybit7_ckpin "I_tc_tim/i_tc_tim_timers/i_bit7_Y_FORCE_KEEP/CK"
set Ybit8_ckpin "I_tc_tim/i_tc_tim_timers/i_bit8_Y_FORCE_KEEP/CK"
set Ybit9_ckpin "I_tc_tim/i_tc_tim_timers/i_bit9_Y_FORCE_KEEP/CK"
set Ybit10_ckpin "I_tc_tim/i_tc_tim_timers/i_bit10_Y_FORCE_KEEP/CK"
set Ybit11_ckpin "I_tc_tim/i_tc_tim_timers/i_bit11_Y_FORCE_KEEP/CK"
set Ybit12_ckpin "I_tc_tim/i_tc_tim_timers/i_bit12_Y_FORCE_KEEP/CK"
set Ybit13_ckpin "I_tc_tim/i_tc_tim_timers/i_bit13_Y_FORCE_KEEP/CK"
create_generated_clock -name Ybit2_clk  -source $PIN_TIM_CLK  -divide_by 2 [get_pins $Ybit2_ckpin]
create_generated_clock -name Ybit3_clk  -source $Ybit2_ckpin  -divide_by 2 [get_pins $Ybit3_ckpin]
create_generated_clock -name Ybit4_clk  -source $Ybit3_ckpin  -divide_by 2 [get_pins $Ybit4_ckpin]
create_generated_clock -name Ybit5_clk  -source $Ybit4_ckpin  -divide_by 2 [get_pins $Ybit5_ckpin]
create_generated_clock -name Ybit6_clk  -source $Ybit5_ckpin  -divide_by 2 [get_pins $Ybit6_ckpin]
create_generated_clock -name Ybit7_clk  -source $Ybit6_ckpin  -divide_by 2 [get_pins $Ybit7_ckpin]
create_generated_clock -name Ybit8_clk  -source $Ybit7_ckpin  -divide_by 2 [get_pins $Ybit8_ckpin]
create_generated_clock -name Ybit9_clk  -source $Ybit8_ckpin  -divide_by 2 [get_pins $Ybit9_ckpin]
create_generated_clock -name Ybit10_clk -source $Ybit9_ckpin  -divide_by 2 [get_pins $Ybit10_ckpin]
create_generated_clock -name Ybit11_clk -source $Ybit10_ckpin  -divide_by 2 [get_pins $Ybit11_ckpin]
create_generated_clock -name Ybit12_clk -source $Ybit10_ckpin  -divide_by 2 [get_pins $Ybit12_ckpin]
create_generated_clock -name Ybit13_clk -source $Ybit10_ckpin  -divide_by 2 [get_pins $Ybit13_ckpin]

# Free timer within tc_tim_timers
set Fbit3_ckpin "I_tc_tim/i_tc_tim_timers/i_bit3_free_FORCE_KEEP/CK"
set Fbit4_ckpin "I_tc_tim/i_tc_tim_timers/i_bit4_free_FORCE_KEEP/CK"
set Fbit5_ckpin "I_tc_tim/i_tc_tim_timers/i_bit5_free_FORCE_KEEP/CK"
set Fbit6_ckpin "I_tc_tim/i_tc_tim_timers/i_bit6_free_FORCE_KEEP/CK"
set Fbit7_ckpin "I_tc_tim/i_tc_tim_timers/i_bit7_free_FORCE_KEEP/CK"
set Fbit8_ckpin "I_tc_tim/i_tc_tim_timers/i_bit8_free_FORCE_KEEP/CK"
set Fbit9_ckpin "I_tc_tim/i_tc_tim_timers/i_bit9_free_FORCE_KEEP/CK"
create_generated_clock -name Fbit3_clk  -source $PIN_TIM_CLK  -divide_by 4 [get_pins $Fbit3_ckpin]
create_generated_clock -name Fbit4_clk  -source $Fbit3_ckpin  -divide_by 2 [get_pins $Fbit4_ckpin]
create_generated_clock -name Fbit5_clk  -source $Fbit4_ckpin  -divide_by 2 [get_pins $Fbit5_ckpin]
create_generated_clock -name Fbit6_clk  -source $Fbit5_ckpin  -divide_by 2 [get_pins $Fbit6_ckpin]
create_generated_clock -name Fbit7_clk  -source $Fbit6_ckpin  -divide_by 2 [get_pins $Fbit7_ckpin]
create_generated_clock -name Fbit8_clk  -source $Fbit7_ckpin  -divide_by 2 [get_pins $Fbit8_ckpin]
create_generated_clock -name Fbit9_clk  -source $Fbit8_ckpin  -divide_by 2 [get_pins $Fbit9_ckpin]

# 4-bit RCTR
if {$env(design_phase) == "SYNTH"} {
    set rctr0_ckpin "I_tc_tim/i_tc_rctr_4b_dn/genblk1[0].genblk1.i_bit_FORCE_KEEP/CK"
    set rctr1_ckpin "I_tc_tim/i_tc_rctr_4b_dn/genblk1[1].genblk1.i_bit_FORCE_KEEP/CK"
    set rctr2_ckpin "I_tc_tim/i_tc_rctr_4b_dn/genblk1[2].genblk1.i_bit_FORCE_KEEP/CK"
    set rctr3_ckpin "I_tc_tim/i_tc_rctr_4b_dn/genblk1[3].genblk1.i_bit_FORCE_KEEP/CK"
} elseif {$env(design_phase) == "STA" || $env(design_phase) == "PNR"} {
    set rctr0_ckpin "I_tc_tim/i_tc_rctr_4b_dn/genblk1_0__genblk1_i_bit_FORCE_KEEP/CK"
    set rctr1_ckpin "I_tc_tim/i_tc_rctr_4b_dn/genblk1_1__genblk1_i_bit_FORCE_KEEP/CK"
    set rctr2_ckpin "I_tc_tim/i_tc_rctr_4b_dn/genblk1_2__genblk1_i_bit_FORCE_KEEP/CK"
    set rctr3_ckpin "I_tc_tim/i_tc_rctr_4b_dn/genblk1_3__genblk1_i_bit_FORCE_KEEP/CK"
}
create_generated_clock -name rctr0_clk  -source $PIN_EARLY_Y_CLK -combinational -multiply_by 1 [get_pins $rctr0_ckpin]
create_generated_clock -name rctr1_clk  -source $rctr0_ckpin -divide_by 2 [get_pins $rctr1_ckpin]
create_generated_clock -name rctr2_clk  -source $rctr1_ckpin -divide_by 2 [get_pins $rctr2_ckpin]
create_generated_clock -name rctr3_clk  -source $rctr2_ckpin -divide_by 2 [get_pins $rctr3_ckpin]

# FIF 5-bit ripple counter
set fif_rctr0_ckpin "I_tc_fif/I_tc_rctr_5b_up/i_bit0_FORCE_KEEP/CK"
set fif_rctr1_ckpin "I_tc_fif/I_tc_rctr_5b_up/i_bit1_FORCE_KEEP/CK"
set fif_rctr2_ckpin "I_tc_fif/I_tc_rctr_5b_up/i_bit2_FORCE_KEEP/CK"
set fif_rctr3_ckpin "I_tc_fif/I_tc_rctr_5b_up/i_bit3_FORCE_KEEP/CK"
set fif_rctr4_ckpin "I_tc_fif/I_tc_rctr_5b_up/i_bit4_FORCE_KEEP/CK"

create_generated_clock -name fif_rctr0_clk  -source $PIN_TIM_CLK     -divide_by 128 [get_pins $fif_rctr0_ckpin]
create_generated_clock -name fif_rctr1_clk  -source $fif_rctr0_ckpin -divide_by 2   [get_pins $fif_rctr1_ckpin]
create_generated_clock -name fif_rctr2_clk  -source $fif_rctr1_ckpin -divide_by 2   [get_pins $fif_rctr2_ckpin]
create_generated_clock -name fif_rctr3_clk  -source $fif_rctr2_ckpin -divide_by 2   [get_pins $fif_rctr3_ckpin]
create_generated_clock -name fif_rctr4_clk  -source $fif_rctr3_ckpin -divide_by 2   [get_pins $fif_rctr4_ckpin]

set_clock_groups -asynchronous -group DTI_DIN_CLK

## End Clock Definitions ######################
###############################################




######################################## Merged from the NVM Controller ##################################################

##############################################################
#                   Waveform Calculation                     #
##############################################################
#   0    1    2    3    4    5    6    7    8
#
# OSC_CLK, tim_clk, tim_nvm_hvs_clk (HVS_CLK)
#   /----\____/----\____/----\____/----\____/
#   .    .    .    .    .    .    .    .    .
# tim's clock_state
#   |    0    |    1    |   2/3   |    0    |
#   .    .    .    .    .    .    .    .    .
# tim_cd_clk
#   _____/----\________________________/----\
#   .    .    .    .    .    .    .    .    .
# tim_mif_clk
#   _______________/----\____________________
#   .    .    .    .    .    .    .    .    .
# tim_nvm_sclk, mif_nvm_sclk (SREG_AND_SAMP_CLK), mif_nvm_config_clk (CONFIG_CLK)
#   ____________________/----\_______________
#   .    .    .    .    .    .    .    .    .
# tim_sm_clk
#   _________________________/----\__________
#


##############################################################
#                  Clock Creation - Ports                    #
##############################################################


############ VIEW ALL UNCONSTRAINED PATHS COMMAND #############
# report_timing -to [ get_pins * ] -max_paths 1000000 -slack_greater_than infinity
###############################################################

create_generated_clock -name HVS_CLK      -source $PORT_OSC_CLK -divide_by 1 $PIN_HVS_CLK
#create_clock  -name HVS_CLK -period $OSC_CLK_PERIOD $PIN_HVS_CLK
#SREG_AND_SAMP_CLK is MIF_NVM_SCLK from the TC
#create_clock -name SREG_AND_SAMP_CLK -period $sreg_samp_period  -waveform $sreg_samp_waveform [ get_ports SREG_AND_SAMP_CLK ] 
#create_clock -name CONFIG_CLK        -period $config_period     -waveform $config_waveform [ get_ports CONFIG_CLK ]

#Clock Stop for HVS CLK
if { $env(design_phase) == "PNR"} {
    #Can't get this to work applying directly to HVS_CLK, so applying globally
    #set_clock_sense -clocks HVS_CLK  -stop_propagation I_tc_nvm/I_cg_hvs_clk_640b/CG_BUF_FORCE_KEEP/Y
}


##############################################################
#                  Clock Creation - Generated                #
##############################################################


# General Rule: clocks do not propagate through registers
# you need to create a generated clock when its a down
# divided clock


# WRITE (and margin read) State Machine Clock
if {$env(design_phase) == "SYNTH"} {
    create_generated_clock -name ctrl_clk_buf \
                           -edges { 1 3 5 } \
                           -source $PIN_HVS_CLK \
                           [ get_pins I_tc_nvm/i_rctr_1b_clk_div/gen_rctr_dn[0].genblk1.i_bit_FORCE_KEEP/Q ]

} elseif {$env(design_phase) == "STA" || $env(design_phase) == "PNR"} {
    create_generated_clock -name ctrl_clk_buf \
                           -edges { 1 3 5 } \
                           -source $PIN_HVS_CLK \
                           [ get_pins I_tc_nvm/i_rctr_1b_clk_div/gen_rctr_dn_0__genblk1_i_bit_FORCE_KEEP/Q ]


}

# ctrl_clk_dly
#create_generated_clock -name ctrl_clk_dly \
#                       -edges { 2 4 6 } \
#                       -source $PIN_HVS_CLK \
#                       [ get_pins I_tc_nvm/I_ctrl_clk_dly_FORCE_KEEP/Q ]

#Definition moved up top to be scenario specific
# WRITE_SREG_CLK and READ_SAMP_CLK used during WRITE word swapping and write_verify
#create_generated_clock -name read_ctrl_clk \
#                       -edges { 2 3 6 } \
#                       -source $PIN_HVS_CLK \
#                       [ get_pins I_tc_nvm/I_read_ctrl_clk_FORCE_KEEP/Y ]


#create_generated_clock -name hvs_clk_640b \
#                       -add \
#                       -edges { 3 4 7 } \
#                       -source $PIN_HVS_CLK \
#                       -master_clock HVS_CLK \
#                       [ get_pins I_tc_nvm/I_or_hvs_step_FORCE_KEEP/Y ]

create_generated_clock -name hvs_clk_320a \
                       -add \
                       -edges { 1 3 9 } \
                       -source $PIN_HVS_CLK \
                       -master_clock HVS_CLK \
                       [ get_pins I_tc_nvm/I_or_hvs_phi1_clk_FORCE_KEEP/Y ]

create_generated_clock -name hvs_clk_320b \
                       -add \
                       -edges { 5 7 13 } \
                       -source $PIN_HVS_CLK \
                       -master_clock HVS_CLK \
                       [ get_pins I_tc_nvm/I_or_hvs_step_FORCE_KEEP/Y ]

create_generated_clock -name hvs_clk_80a \
                       -add \
                       -edges { 1 9 33 } \
                       -source $PIN_HVS_CLK \
                       -master_clock HVS_CLK \
                       [ get_pins I_tc_nvm/I_or_hvs_phi1_clk_FORCE_KEEP/Y ]

create_generated_clock -name hvs_clk_80b \
                       -add \
                       -edges { 17 25 49 } \
                       -source $PIN_HVS_CLK \
                       -master_clock [get_clocks HVS_CLK] \
                       [ get_pins I_tc_nvm/I_or_hvs_step_FORCE_KEEP/Y ]



# FB_OK and BG_OK from ctrl_clk_buf (removed ripple counters)
#create_generated_clock -name fb_ok_cnt_clk \
#                       -divide_by 1 \
#                       -source [ get_ports HVS_CLK ] \
#                       [ get_pins I_fb_ok_clock_gate/CG_AND_FORCE_KEEP/Y ]


# FB_OK & BG_OK ripple counter filter
#create_generated_clock -name fb_bit1_clk  -divide_by 2 -source [ get_pins *fb_bit0*/CK ] [ get_pins *fb_bit1*/CK ]
#create_generated_clock -name bg_bit1_clk  -divide_by 2 -source [get_pins *bg_bit0*/CK]   [ get_pins *bg_bit1*/CK ]
#create_generated_clock -name bg_bit2_clk  -divide_by 2 -source [get_pins *bg_bit1*/CK]   [ get_pins *bg_bit2*/CK ]
#if {$env(design_phase) == "SYNTH"} {
#    create_generated_clock -name fb_buf1_clk -divide_by 2 -source [ get_pins *fb_bit1*/CK ] [ get_pins hvs_fb_ok_filt_reg/clocked_on ] 
#    create_generated_clock -name bg_buf2_clk -divide_by 2 -source [get_pins *bg_inv1*/Y]    [ get_pins hvs_bg_ok_filt_mr_reg/clocked_on ]
#    create_generated_clock -name hvs_bg_ok_filt_clk -divide_by 2 -source [get_pins *bg_bit1*/CK] [ get_pins hvs_bg_ok_filt_reg/clocked_on ]
#} elseif {$env(design_phase) == "STA"} {
#    create_generated_clock -name fb_buf1_clk -divide_by 2 -source [ get_pins *fb_bit1*/CK ] [ get_pins hvs_fb_ok_filt_reg/CK ]
#    create_generated_clock -name bg_buf2_clk -divide_by 2 -source [get_pins *bg_inv1*/Y]    [ get_pins hvs_bg_ok_filt_mr_reg/CK ]
#    create_generated_clock -name hvs_bg_ok_filt_clk -divide_by 2 -source [get_pins *bg_bit1*/CK]   [ get_pins hvs_bg_ok_filt_reg/CK ]
#}

# step_cntr ripple counter
# Removed redundant definition on bit0/CK pin. Previously defined clocks can be inferred.
create_generated_clock -name step_cntr_bit1_clk -divide_by 2 -preinvert \
                       -master_clock hvs_clk_320b -add \
                       -source [ get_pins I_tc_nvm/I_or_hvs_step_FORCE_KEEP/Y ] \
                       [ get_pins I_tc_nvm/*step_cntr*/i_bit1*/CK ]
create_generated_clock -name step_cntr_bit2_clk -divide_by 2 -source [ get_pins I_tc_nvm/*step_cntr*/i_bit1*/CK ] [ get_pins I_tc_nvm/*step_cntr*/i_bit2*/CK ]
create_generated_clock -name step_cntr_bit3_clk -divide_by 2 -source [ get_pins I_tc_nvm/*step_cntr*/i_bit2*/CK ] [ get_pins I_tc_nvm/*step_cntr*/i_bit3*/CK ]
create_generated_clock -name step_cntr_bit4_clk -divide_by 2 -source [ get_pins I_tc_nvm/*step_cntr*/i_bit3*/CK ] [ get_pins I_tc_nvm/*step_cntr*/i_bit4*/CK ]
create_generated_clock -name step_cntr_bit5_clk -divide_by 2 -source [ get_pins I_tc_nvm/*step_cntr*/i_bit4*/CK ] [ get_pins I_tc_nvm/*step_cntr*/i_bit5*/CK ]
create_generated_clock -name step_cntr_bit6_clk -divide_by 2 -source [ get_pins I_tc_nvm/*step_cntr*/i_bit5*/CK ] [ get_pins I_tc_nvm/*step_cntr*/i_bit6*/CK ]
create_generated_clock -name step_cntr_bit7_clk -divide_by 2 -source [ get_pins I_tc_nvm/*step_cntr*/i_bit6*/CK ] [ get_pins I_tc_nvm/*step_cntr*/i_bit7*/CK ]

# False Paths / Logically Exclusive Clock Groupings
# set_clock_groups -logically_exclusive -group CLK1 -group CLK2

# Clock MUX for READ_SAMP_CLK will never have these two clocks on
# at the same time. One used for reading, one used for write_verify / word swapping
#
set_clock_groups -physically_exclusive -group hvs_clk_320a -group hvs_clk_80a
set_clock_groups -physically_exclusive -group hvs_clk_320b -group hvs_clk_80b
set_clock_groups -logically_exclusive  \
                                       -group {hvs_clk_320a hvs_clk_320b} \
                                       -group {hvs_clk_80a  hvs_clk_80b}

## End Clock Definitions ######################
###############################################


###################################################################
#################### Common constraints ###########################
###################################################################

### Set clock uncertainty ####################
set_clock_uncertainty -setup $setup_uncertainty [ all_clocks ]
set_clock_uncertainty -hold  $hold_uncertainty  [ all_clocks ]

### Set clock slew limit ####################
set_max_transition $clk_slew_limit [get_ports *CLK* -filter "@port_direction == out"]; #IOs
set_max_transition $data_slew_limit [ all_clocks ] ; #data pins driven by clks

if {$env(design_phase) == "SYNTH"} {
    set_max_transition $clk_slew_limit -clock_path [ all_clocks ] ;# all of the clocks defined in this file
    #set_max_transition $clk_slew_limit [get_ports -nocase *CLK* -hier ]; #anything with the letters CLK in it which isn't quite what we want
}

if {$env(design_phase) == "STA"} {
    set_max_transition $clk_slew_limit [get_pins * -hier -filter "is_clock_pin == true"] ;#every and any pin that acts like a clk
#    set_max_transition $clk_slew_limit -clock_path [ all_clocks ] ;# all of the clocks defined in this file
}

if {$env(design_phase) == "PNR"} {
    #FYI, this command does't really do anything. Its overridden by set_clock_tree_options -max_tran later in the PNR flow
    set_max_transition $clk_slew_limit -clock_path [get_clocks]
}


