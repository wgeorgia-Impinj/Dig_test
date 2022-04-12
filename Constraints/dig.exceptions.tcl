# 6/18/18 Only the following 2 latches now have timing disabled on them.
# Consider swapping them out for FFs.
# 2021.03.31 -- Arcs go from D to QN instead of D to Q
if {$env(design_phase) == "SYNTH"} {
    set_disable_timing -from data_in -to Q [ get_cells I_tc_tim/tim_state_wait_vs_write_reg]
    set_disable_timing -from data_in -to Q [ get_cells I_tc_tim/osc_dac_int_lat_reg*]
} elseif {$env(design_phase) == "STA" || $env(design_phase) == "PNR"} {
    set_disable_timing -from D -to QN [ get_cells I_tc_tim/tim_state_wait_vs_write_reg]
    set_disable_timing -from D -to QN [ get_cells I_tc_tim/osc_dac_int_lat_reg*]
}

#these two latches were commented out in the clocks block for rx5. 
#I see why now. it's impossible to multi-cycle path them correctly. 
#one day, someone should look at these, but the timing is pretty safe
#Both are latches on tim_state_rx
set_false_path -from tim_rx2_clk
set_false_path -to tim_rx2_clk
set_false_path -from tim_rx1_clk
set_false_path -to tim_rx1_clk



#Locks cache to anywhere is multi cycle
#latches based on tim state rx are loose on timing too
set_multicycle_path 2 -setup -from [list [get_clocks tim_rx1_clk] [get_clocks tim_rx2_clk] ]
set_false_path -hold  -from [list [get_clocks tim_rx1_clk] [get_clocks tim_rx2_clk] ] 


set_disable_timing -from A -to Y [ get_cells I_tc_tim/I_rng_clk_nor_FORCE_KEEP]

#Some broader exceptions. CD_CMD has sufficient setup/hold time to mif_clk/tx_d_clk
set_multicycle_path 2 -setup -through [list I_tc_cd/Icd_cmd/CD_CMD[*] \
                              I_tc_cd/CD_CMD[*] \
                              I_tc_cd/RX_PR_DETECT ] \
                              -to [list [get_clocks TIM_MIF_CLK] [get_clocks TX_D_CLK ] ]
set_false_path -hold -through [list I_tc_cd/Icd_cmd/CD_CMD[*] \
                              I_tc_cd/CD_CMD[*] \
                              I_tc_cd/RX_PR_DETECT ] \
                              -to [list [get_clocks TIM_MIF_CLK] [get_clocks TX_D_CLK ] ]




# FIXME Sonal 05/08/2018
# The following path is a replacement for disable_timing for TIM_NVM_TIMEOUT_reg/enable
set_false_path -through [get_cells I_tc_tim/TIM_NVM_TIMEOUT_reg] \
    -to [get_cells I_tc_tim/clock_state_reg*]

# CD_CLK and MIF_CLK never overlap.
# There always at least 1 clock cycle apart.
# As a result data launched from CD_CLK domain and captured in MIF_CLK domain,
# will be held by design for atleast 1 clk cycle.
set_multicycle_path 2 -setup -from [list [get_clocks wait_or_write_clk] ]
set_false_path -hold  -from [list [get_clocks wait_or_write_clk] ] 

#TIM_STATE_WAIT_OR_WRITE aka wait_or_write_clk is used as a sync reset for MIF_CLK driven flops
#There is no single cycle path from MIF_CLK to wait_or_write_clk
#Write an MCP for the flagging path, hold FP for the resulting hold timing path based on the mcp.
set_multicycle_path 2 -setup -from [get_clocks TIM_MIF_CLK ] -to [list [get_clocks wait_or_write_clk] ]
set_false_path -hold  -from [get_clocks TIM_MIF_CLK ] -to [list [get_clocks wait_or_write_clk] ]

#wait_or_write_clk will be stable for latches that are triggered off EXPIRED_Y_CLK 
set_false_path -from [list [get_clocks wait_or_write_clk] ] \
                -to [get_clocks EXPIRED_Y_CLK]
set_false_path -from [list [get_clocks wait_or_write_clk]]\
                -to I_tc_tim/i_tc_tim_timers/i_expired_Y_FORCE_KEEP/D

                
#Note - This false path from mz1 causes the tool to crash for lx1. 
#JPC: removing SM_CLK and adding tim_clk_b. I think sm_clk is what's causing this to crash since it sort of creates an exception loop. (Still a bug in the tool though...)                
#wait_or_write_clock is 1.5x a tim_clk (multi-cycle path is not working well enough.)
#set_false_path -from [list [get_clocks wait_or_write_clk] ]\
#               -to [list [get_clocks TIM_CLK] [get_clocks TIM_SM_CLK] [get_clocks TIM_CD_CLK] [get_clocks TIM_MIF_CLK] [get_clocks  TIM_NVM_CLK] [get_clocks TIM_NVM_SREG_CLK]]
set_false_path -from [list [get_clocks wait_or_write_clk] ]\
               -to [list  [get_clocks TIM_CLK] [get_clocks TIM_CLK_B] [get_clocks TIM_CD_CLK] [get_clocks TIM_MIF_CLK] [get_clocks  TIM_NVM_CLK] [get_clocks TIM_NVM_SREG_CLK]]


set_false_path -hold -from [get_clocks TIM_CLK] -to [get_clocks RX_SCLK]
set_false_path -hold -from [get_clocks RX_CLOCK_B] -to [get_clocks RX_SCLK]

#RX is stable before SM
set_multicycle_path 2 -setup -from [get_clocks RX_SCLK] -to [get_clocks TIM_SM_CLK] 
set_false_path -hold -from [get_clocks RX_SCLK] -to [get_clocks TIM_SM_CLK]

#RX and MIF clks don't overlap by design
set_multicycle_path 2 -setup -from [get_clocks RX_SCLK] -to [get_clocks TIM_MIF_CLK] 
set_false_path -hold -from [get_clocks RX_SCLK] -to [get_clocks TIM_MIF_CLK]

set_multicycle_path 2 -setup -from [get_clocks TIM_MIF_CLK] -to [get_clocks RX_CLOCK] 
set_false_path -hold -from [get_clocks TIM_MIF_CLK] -to [get_clocks RX_CLOCK]

#SM to TIM is a 1.5 cycle path. #TIM to SM can still be a 1/2 cycle path.
set_multicycle_path 2  -setup -from [get_clocks TIM_SM_CLK] -to [ list [ get_clocks TIM_CLK] [ get_clocks TX_D_CLK] \
                                                    [get_clocks TX_LF_CLK ] [get_clocks  TIM_NVM_CLK] [get_clocks TIM_NVM_SREG_CLK]]
set_false_path -hold -from [get_clocks TIM_SM_CLK] -to [ list [ get_clocks TIM_CLK] [ get_clocks TX_D_CLK] \
                                                    [get_clocks TX_LF_CLK ]  [get_clocks  TIM_NVM_CLK] [get_clocks TIM_NVM_SREG_CLK]]




#The CD clock stops running well before the tx_d_clk start. 
#At the end of a packet when things are resetting, then there's a 1 cycle cycle timing path between the two
#But since this is a reset path, going to allow it. 
set_multicycle_path 2  -setup -from [get_clocks TIM_CD_CLK]   -to [get_clocks TX_D_CLK ] 
set_multicycle_path 2  -setup -from [get_clocks TX_D_CLK] -to [get_clocks TIM_CD_CLK ] 
set_false_path -hold -from [get_clocks TIM_CD_CLK]   -to [get_clocks TX_D_CLK ] 
set_false_path -hold -from [get_clocks TX_D_CLK] -to [get_clocks TIM_CD_CLK ] 

#CD and SM clk never overlap
set_multicycle_path 2  -setup -from [get_clocks TIM_CD_CLK]   -to [get_clocks TIM_SM_CLK ] 
set_multicycle_path 2  -setup -from [get_clocks TIM_SM_CLK] -to [get_clocks TIM_CD_CLK ] 
set_false_path -hold -from [get_clocks TIM_CD_CLK]   -to [get_clocks TIM_SM_CLK ] 
set_false_path -hold -from [get_clocks TIM_SM_CLK] -to [get_clocks TIM_CD_CLK ] 


#The CRC logic is stable 1 full clock cycle before timers start.     
set_false_path -through I_tc_crc/CRC_PASS_reg/Q* \
    -to I_tc_tim/i_tc_tim_timers/i_EARLY_EXPIRED_Y_FORCE_KEEP/D
set_false_path -through I_tc_crc/CRC_PASS_reg/Q* \
    -to I_tc_tim/i_tc_tim_timers/i_start_X_FORCE_KEEP/D 
set_false_path -through I_tc_crc/CRC_PASS_reg/Q* \
    -to I_tc_tim/i_tc_tim_timers/i_start_Y_FORCE_KEEP/D 
set_false_path -through I_tc_crc/CRC_PASS_reg/Q* \
    -to I_tc_tim/i_tc_tim_timers/i_expired_Y_FORCE_KEEP/D
set_false_path -through I_tc_crc/CRC_PASS_reg/Q* \
    -to I_tc_tim/i_tc_tim_timers/i_expired_X_FORCE_KEEP/D

# Multicycle path of 1.5 clocks
set_false_path -through I_tc_crc/CRC_PASS_reg/Q \
    -to I_tc_tim/tim_state_ff*_FORCE_KEEP/D

#There are valid paths between NVM_SCLK to CD_CLK (MIF_NVM_PARITY_ERROR, CD_POINTER),
# but this occurs during the forward link when there is more than a half cycle between
# CD_CLK -> NVM_SCLK 1.5
# NVM_SCLK -> CD_CLK 3.5++
# The tool sees this because we constrained the clocks for the max rate TX case
# where the CD doesn't run. 
set_false_path -from [get_clocks TIM_CD_CLK] \
   -to [list [get_clocks TIM_NVM_CLK]  [get_clocks HVS_CLK] ]
set_false_path -from [list [get_clocks TIM_NVM_CLK] ] \
   -to [list [get_clocks TIM_CD_CLK] [get_clocks TIM_NVM_SREG_CLK]]

#SM clk is stable before a HVS_CLK matters
set_multicycle_path -setup 2 -from [get_clocks TIM_SM_CLK] \
   -to [list  [get_clocks HVS_CLK] ]   
set_false_path -hold -from [get_clocks TIM_SM_CLK] \
   -to [list  [get_clocks HVS_CLK] ]

#The SM is separated from the  TIM_NVM_CLK
set_multicycle_path -setup 2 -from [get_clocks TIM_SM_CLK] \
    -to [list [get_clocks TIM_NVM_CLK] [get_clocks TIM_NVM_SREG_CLK]]
set_false_path -hold -from [get_clocks TIM_SM_CLK] \
    -to [list [get_clocks TIM_NVM_CLK] [get_clocks TIM_NVM_SREG_CLK]]


#The EPC_length will be stable when it is used as an address for the CD_POINTER or tx
set_false_path -through I_tc_mif/MIF_EPC_LENGTH* \
               -through [list I_tc_cd/CD_POINTER* I_tc_tx/Itc_tx_state_machine/NEXT_BIT_CTR* ]
foreach mifnet [get_net I_tc_mif/MIF_EPC_LENGTH[*]] {
  foreach cdnet [get_net I_tc_cd/CD_POINTER[*]] {
    set_false_path -through $mifnet -through $cdnet
  }
}
set_false_path -through I_tc_cd/Icd_params/pointer*_sr_reg* \
-through I_tc_mif/I_tc_mif_rules/MIF_END_ADDR_TX*

#TX_MUX_BIT_ADDR is only used for rng/idcode backscatter which doesn't come from the mif
#error_bit_sel is not driven from a mif clk. 
set_false_path -from [get_clocks TIM_MIF_CLK] -through [list I_tc_mif/MIF_DONE* [get_pins -of_objects I_tc_tx/error_bit_sel* -leaf] ]

#If tim_state changes, there will always be a mif_clk before a nvm_sclk,
#so we have more than the 1/2cycle clk the tool is seeing   
set_false_path -through I_tc_tim/tim_state* \
    -to [list [get_clocks TIM_NVM_CLK] [get_clocks TIM_NVM_SREG_CLK]]

#TIM_STATE will be stable for 2 clock cycles before the first tx_d_clk
#There are 1.5 clks from tim_state changing to the first mif_clk
set_false_path -from I_tc_tim/tim_state_ff*_FORCE_KEEP/CK       \
    -to [list [get_clocks TX_D_CLK] [get_clocks TIM_MIF_CLK]]

#RX is disabled 2 cycles before TX_D_CLK
set_false_path -from I_tc_tim/I_rx_disable_FORCE_KEEP/CK       \
    -to [get_clocks TX_D_CLK]
    

#Paths from the CD/SM to the timers are used for calculating the t2 time
#This timer doesn't start until after TX, so the inputs will be stable
set_false_path -from [ list [get_clocks  TIM_CD_CLK] [get_clocks TIM_SM_CLK] [get_clocks tim_smst_clk] ]      \
    -to [list I_tc_tim/i_tc_tim_timers/i_EARLY_EXPIRED_Y_FORCE_KEEP \
              I_tc_tim/i_tc_tim_timers/i_start_Y_FORCE_KEEP  \
              I_tc_tim/i_tc_tim_timers/i_expired_Y_FORCE_KEEP \
              I_tc_tim/i_tc_tim_timers/i_expired_X_FORCE_KEEP \
              I_tc_tim/i_tc_tim_timers/i_start_X_FORCE_KEEP ]           


#The OSC_CLK goes through a giant mux in the TIF. Don't count this as a clock
set_false_path -from [get_clocks OSC_CLK] -to [list TIF_DOUT1 TIF_DOUT2]

#During INIT, there are 2 clock cycles between the mif_clk and rng_clk 
#this includes all the clocks generated from the ripple counters   
#The RNG_CLK will be disabled when passing data to the ENC_CLK
set_false_path -from [list [get_clocks TIM_MIF_CLK ]] \
               -to [get_clocks RNG_CLK]

#RNG clk is stopped before enc clk latches it
#set_multicycle_path -setup 3 -from [list [get_clocks RNG_CLK ] ] \
#               -to [get_clocks ENC_CLK]
#set_multicycle_path -hold 2 -from [list [get_clocks RNG_CLK ] ] \
#               -to [get_clocks ENC_CLK]
#multicycle path is still causing hold violations in PT

#timer_suppress_expired_Y is only used for suppressing the last lf clock           
set_false_path -from [get_clocks TIM_MIF_CLK]  \
    -through I_tc_tim/i_tc_tim_timers/SUPPRESS_EXPIRED_Y

set_false_path -through I_tc_tim/TIM_STATE_TX \
   -to [get_clocks TIM_CD_CLK]

# RX_SCLK is not running when T1/T2 are being calculated
set_false_path -from [ list [get_clocks RX_SCLK] [get_clocks RX_CLK] [get_clocks RX_CLOCK_B ]  [get_clocks RX_CLOCK ] [get_clocks TIM_CD_CLK] ] \
    -through [list I_tc_tim/I_tc_tim_tcalc/TRCAL*  \
                   I_tc_tim/RX_RTCAL* \
                   I_tc_tim/I_tc_tim_tcalc/DR* \
                   I_tc_tim/I_tc_tim_tcalc/T1_FINAL*  \
                   I_tc_tim/I_tc_tim_tcalc/OSC_N_OUT * \
                   I_tc_tim/RX_FT_EN \
                   I_tc_tim/i_tc_tim_timers/DONE_X ] \
    -to [list I_tc_tim/i_tc_tim_timers/i_start_Y_FORCE_KEEP/D \
              I_tc_tim/i_tc_tim_timers/i_start_X_FORCE_KEEP/D \
              I_tc_tim/i_tc_tim_timers/i_expired_Y_FORCE_KEEP/D \
              I_tc_tim/i_tc_tim_timers/i_expired_X_FORCE_KEEP/D \
              I_tc_tim/i_tc_tim_timers/i_EARLY_EXPIRED_Y_FORCE_KEEP/D ]

#Tcalc block isn't active until well after the cd_cmd is stable
set_false_path  -through I_tc_cd/Icd_cmd/CD_CMD  \
                -through [list I_tc_tim/I_tc_tim_tcalc/DR* \
                   I_tc_tim/I_tc_tim_tcalc/T1_FINAL*  \
                   I_tc_tim/I_tc_tim_tcalc/OSC_N_OUT * ]


#CD clock isn't active when calculations are used. 
set_false_path  -through I_tc_cd/Icd_cmd/*  \
                -through [list I_tc_tim/I_tc_tim_tcalc/* \
                ]
#CD Select Phoenix look ahead will not affect the value in MIF_MR_AIR_FAIL_reg 
#This is a false path
set_false_path -through I_tc_cd/CD_SELECT_PHOENIX_LOOK_AHEAD \
               -to I_tc_mif/I_tc_mif_registers/MIF_MR_AIR_FAIL_reg    

#MIF_CUR_SEL reg will be stable long before MIF_MR_AIR_FAIL_reg is set. 
set_false_path -through I_tc_mif/I_tc_mif_state_machine/MIF_CURR_SEL_REG[*] \
               -to I_tc_mif/I_tc_mif_registers/MIF_MR_AIR_FAIL_reg    

# Many cycles from when RX is enabled till we need to turn on SREG clock
# This is a false path.    
set_false_path -from I_tc_tim/I_rx_disable_FORCE_KEEP \
               -through I_tc_cd/CD_READ_NVM \
               -to I_tc_tim/I_nvm_sreg_clk_*_dff_FORCE_KEEP

# Tim state ffs will be stable long before CD is decoded. 
# CD read NVM will happen long before nvm_sreg_clk needs to be enabled.      
set_false_path -from I_tc_tim/tim_state_ff*_FORCE_KEEP \
               -through I_tc_cd/CD_READ_NVM \
               -to I_tc_tim/I_nvm_sreg_clk_*_dff_FORCE_KEEP
set_false_path -from I_tc_tim/tim_state_ff*_FORCE_KEEP \
               -through I_tc_cd/CD_READ_NVM \
               -to I_tc_cd/Icd_params/password_parity_error_reg

# Ample time from demod being enable to the cd being done. 
set_false_path -from I_tc_tim/TIM_DEMOD_ENABLE \
               -through I_tc_cd/CD_DONE


# Multiple cycles from when RX is enabled till we need to turn on SREG clock
# This is a false path.    
set_multicycle_path -setup 2  -from I_tc_tim/I_rx_disable_FORCE_KEEP \
               -to I_tc_tim/I_nvm_sreg_clk_*_dff_FORCE_KEEP
set_false_path -hold  -from I_tc_tim/I_rx_disable_FORCE_KEEP \
               -to I_tc_tim/I_nvm_sreg_clk_*_dff_FORCE_KEEP

# multiple cycles from when the RX is enabled/disabled to when a parity bit would need to 
# be read as a result of an NVM needs to be read or an error needs to be acted on.
# Through the NVM_PARITY_ERROR net, this is a mcp.     
set_multicycle_path -setup 2  -from I_tc_tim/I_rx_disable_FORCE_KEEP \
               -to I_tc_cd/Icd_params/password_parity_error_reg
set_false_path -hold  -from I_tc_tim/I_rx_disable_FORCE_KEEP \
               -to I_tc_cd/Icd_params/password_parity_error_reg

#Multiple cycles from when the RX is enabled to when get around to setting the command
set_multicycle_path -setup 2 -from I_tc_tim/I_rx_disable_FORCE_KEEP \
                -through [list I_tc_cd/Icd_cmd/CD_CMD[*] \
                               I_tc_cd/CD_CMD[*] ]
set_false_path -hold -from I_tc_tim/I_rx_disable_FORCE_KEEP \
                -through [list I_tc_cd/Icd_cmd/CD_CMD[*] \
                               I_tc_cd/CD_CMD[*] ]

#This is overly aggressive due to the signal optimizations that ICC does. Only apply to PT analysis               
if {$env(design_phase) == "STA" } {
    # Tott need to check with others.
    # Wait or write clock fires at least 2 clock cycles before the first TX_D_CLK
    set_false_path -from [get_clocks wait_or_write_clk] \
                   -to [get_clocks TX_D_CLK]
    

    #MIF_INIT_LENGTH is a dummy signal created to prevent X prop during init. 
    #It will toggle only during init, thus, any scenario that is affected after init
    #Is not a true path. Clustering here, will give different reasons for each.
    #MIF_MR_AIR_FAIL_reg will never be updated during init. Therefore, this is a fp
    set_false_path -through I_tc_mif/I_tc_mif_state_machine/MIF_INIT_LENGTH \
                   -to I_tc_mif/I_tc_mif_registers/MIF_MR_AIR_FAIL_reg    
   
    #During INIT, there is a 2 cycle path from bit_cnt_reg to MIF_CTRL_ROW_reg. During 
    #A fast ID ack, mif_bit_cnt to MIF_CTRL_ROW has a 1 cycle path, however, it does not flow through MIF_INIT_LENGTH.
    #After init, MIF_INIT_LENGTH is stable. Thus, MCP by 2 this path. FP for hold is to negate hold timing issue caused by mcp. 
    set_multicycle_path -setup 2  -from I_tc_mif/I_tc_mif_state_machine/mif_bit_cnt_reg_*_ \
                   -through I_tc_mif/I_tc_mif_state_machine/MIF_INIT_LENGTH \
                   -to I_tc_mif/I_tc_mif_registers/I_tc_mif_ctrl_row/MIF_CTRL_ROW_reg_*_

    set_false_path -hold  -from I_tc_mif/I_tc_mif_state_machine/mif_bit_cnt_reg_*_ \
                   -through I_tc_mif/I_tc_mif_state_machine/MIF_INIT_LENGTH  \
                   -to I_tc_mif/I_tc_mif_registers/I_tc_mif_ctrl_row/MIF_CTRL_ROW_reg_*_
    
    #During INIT, there is a 2 cycle path from bit_cnt_reg to MIF_STATE_reg. During 
    #A fast ID ack, mif_bit_cnt to MIF_CTRL_ROW has a 1 cycle path, however, it does not flow through MIF_INIT_LENGTH.
    #After init, MIF_INIT_LENGTH is stable. Thus, MCP by 2 this path. FP for hold is to negate hold timing issue caused by mcp. 
    set_multicycle_path -setup 2  -from I_tc_mif/I_tc_mif_state_machine/MIF_STATE_reg_*_ \
                   -through I_tc_mif/I_tc_mif_state_machine/MIF_INIT_LENGTH \
                   -to I_tc_mif/I_tc_mif_registers/I_tc_mif_ctrl_row/MIF_CTRL_ROW_reg_*_

    set_false_path -hold  -from I_tc_mif/I_tc_mif_state_machine/MIF_STATE_reg_*_ \
                   -through I_tc_mif/I_tc_mif_state_machine/MIF_INIT_LENGTH \
                   -to I_tc_mif/I_tc_mif_registers/I_tc_mif_ctrl_row/MIF_CTRL_ROW_reg_*_
    #During INIT, there is a 2 cycle path from nvm_read_done_reg_reg to MIF_CTRL_ROW_reg. During 
    #A fast ID ack, nvm_read_done_reg_reg to MIF_CTRL_ROW has a 1 cycle path, however, it does not flow through MIF_INIT_LENGTH.
    #After init, MIF_INIT_LENGTH is stable. Thus, MCP by 2 this path. FP for hold is to negate hold timing issue caused by mcp. 
    set_multicycle_path -setup 2  -from I_tc_mif/I_tc_mif_state_machine/nvm_read_done_reg_reg \
                   -through I_tc_mif/I_tc_mif_state_machine/MIF_INIT_LENGTH \
                   -to I_tc_mif/I_tc_mif_registers/I_tc_mif_ctrl_row/MIF_CTRL_ROW_reg_*_

    set_false_path -hold  -from I_tc_mif/I_tc_mif_state_machine/nvm_read_done_reg_reg \
                   -through I_tc_mif/I_tc_mif_state_machine/MIF_INIT_LENGTH \
                   -to I_tc_mif/I_tc_mif_registers/I_tc_mif_ctrl_row/MIF_CTRL_ROW_reg_*_


    #NVMC_DONE is generated, and stays stable, until the MIF acknowledges its receipt, then drops MIF_NVMC_EN which will cause 
    #state_q to change. IE, state_q will not change once NVMC_DONE is set, until the MIF acknowledges its receipt. FP on hold to 
    #clear out issues on hold analysis caused by MCP. 
    set_multicycle_path -setup 2 -from I_tc_nvm/I_nvm_control_fsm/state_q_reg_*_ \
                        -through I_tc_nvm/NVMC_DONE \
                        -to I_tc_mif/I_tc_mif_state_machine/MIF_STATE_reg_*_

    set_false_path -hold  -from I_tc_nvm/I_nvm_control_fsm/state_q_reg_*_ \
                        -through I_tc_nvm/NVMC_DONE \
                        -to I_tc_mif/I_tc_mif_state_machine/MIF_STATE_reg_*_
    
    set_false_path -setup -from I_tc_tim/I_packet_start_dff_FORCE_KEEP \
                          -to I_tc_tim/I_nvm_sreg_clk_0_dff_FORCE_KEEP




}

# The CD clock isn't running when timer calculations are going on. 
# The is significant delay after calc values settle to the SM clk
# RX sclk to tim timers is a multi-cycle path              
set_false_path -from [list [get_clocks TIM_CD_CLK] [get_clocks TIM_SM_CLK] [get_clocks RX_SCLK] ] \
    -through [list I_tc_tim/I_tc_tim_tcalc/T1_FINAL*  \
                   I_tc_tim/I_tc_tim_tcalc/T2_FINAL*  \
                   I_tc_tim/I_tc_tim_tcalc/OSC_N_OUT * ]

#Similar to the above RX -> timers paths
set_false_path -from  I_tc_rx/AT/STATE_v/RX_PI_SYNCWORD_reg \
               -through I_tc_tim/I_tc_tim_tcalc/T2_FINAL[*]

set_false_path -from   I_tc_rx/AT/STATE_v/RX_PI_SYNCWORD_reg   \
               -to [get_cells    I_tc_tim/I_nvm_sreg_clk_*_dff_FORCE_KEEP]

               


# RNG_CLK is disabled when the SM_CLK fires. Can multi-cycle rng_clk -> sm_clk
# and vice-versa. SM_CLK latches the TC1 control reg which feeds RNG_CLK.
set_false_path -from [get_clocks RNG_CLK] -to [get_clocks TIM_SM_CLK]
set_false_path -from [get_clocks TIM_SM_CLK] -to [get_clocks RNG_CLK]
#

# osc_dac changes on TIM_SM_CLK so has at least 1.5 clocks 
# before the closing edge of the latch 
# osc_dac is held for a very long time 
set_false_path -hold -through I_tc_tim/I_tc_tim_tcalc/OSC_DAC* \
               -to I_tc_tim/osc_dac_int_lat_reg*

#Osc boost isn't set until TX, so the CMD will be stable
# Multicycle path of 1.5 clocks to tim_clk 
#The TX clock will never be running when the CD_CMD* signal changes               
#CD_DONE will rise on clock_stop[0], but the state machine won't evaluate 
# the signal until clock_stop[3]. Signal has 1.5 clocks to propagate 
# CD_DONE will have a multiple clocks before a SM_CLK
# enc_clk has plenty of room before bits are shifted in
#NOTE: MIF_DONE is a real 1/2 cycle path when in the WRITE state. 
set_false_path -through [list I_tc_cd/Icd_cmd/CD_CMD[*] \
                              I_tc_cd/CD_CMD[*]  \
                              I_tc_cd/CD_DONE \
                               I_tc_cd/CD_LENGTH[*]  \
                               I_tc_cd/CD_READ_NVM] \
                -to [list I_tc_tim/osc_dac_int_lat_reg* \
                    [get_clocks TIM_CLK] \
                    [get_clocks TX_D_CLK] \
                    [get_clocks TIM_SM_CLK] \
                    [get_clocks tim_smst_clk ]\
                    [get_clocks RX_SCLK ]  \
                    [get_clocks RX_CLK] \
                    [get_clocks TIM_NVM_CLK]]

                    
set_false_path -through [list I_tc_cd/CD_CMD[*] I_tc_cd/Icd_cmd/CD_CMD[*] ] \
             -to [list I_tc_cd/Icd_params/field1_sr_reg* \
                       I_tc_cd/Icd_params/CD_ERR_UNSUPPORTED_reg* ]

set_false_path -through  I_tc_cd/Icd_params/field*_sr_reg* \
               -through I_tc_mif/I_tc_mif_rules/MIF_END_ADDR_TX*


# The PI sync word is set at the start of a command and won't have any direct interaction
# with the MIF               
# In the CD, the pi sync isn't needed until the preamble detect, so plenty of clocks later
set_false_path -from  [list I_tc_rx/AT/STATE_v/RX_PI_SYNCWORD_reg \
                            I_tc_cd/RX_PR_DETECT ]\
                -to [ list [get_clocks TIM_CD_CLK] [get_clocks  TIM_NVM_CLK] [get_clocks TIM_NVM_SREG_CLK] \
                           [get_clocks TIM_SM_CLK] [get_clocks wait_or_write_clk]]

#TIM_PACKET_START edges won't affect the opening or closing of the clock gates as they always occur in the middle of a command
#This signal is used to reset the cd bitctr, but at the start of the packet, the CD outputs are not evaluated.                 
set_false_path -from [list [get_clocks RX_SCLK] ] \
                -to [list I_tc_cd/Icd_params/I_pointer1_clock_gate/CG_LATCH_FORCE_KEEP/D \
                          I_tc_cd/Icd_params/I_length_clock_gate/CG_LATCH_FORCE_KEEP/D ]

set_false_path -through [list I_tc_tim/TIM_PACKET_START \
                              I_tc_cd/TIM_STATE_RX ]  \
                -to [list I_tc_cd/Icd_params/I_pointer1_clock_gate/CG_LATCH_FORCE_KEEP/D \
                          I_tc_cd/Icd_params/I_length_clock_gate/CG_LATCH_FORCE_KEEP/D ]


#set_false_path -from I_tc_tim/tim_state_ff1_FORCE_KEEP \
#               -through I_tc_tim/TIM_STATE_RX \
#               -to I_tc_cd/Icd_params/CD_EBV_OVERRUN_reg 
#The CD will be stable whenever the tx mux or bit counter is moving               
set_false_path -through [list I_tc_cd/CD_DONE  \
                              I_tc_cd/CD_POINTER[*]  \
                              I_tc_cd/Icd_cmd/CD_CMD[*] \
                              I_tc_cd/CD_CMD[*] ] \
               -through [list I_tc_tx/TX_MUX_BIT_ADDR_B[*] \
                            ] 

set_false_path -through [list I_tc_tx/TX_MUX_BIT_ADDR_B[*] \
                            ] \
                -to [get_clocks TIM_CD_CLK]                          

#CD CMD is stable before nvm bit reads.
set_false_path -through I_tc_cd/Icd_cmd/CD_CMD* \
               -through [list I_tc_mif/MIF_MEM_DATA ]


set_false_path -through [list I_tc_cd/Icd_cmd/CD_CMD[*] \
                              I_tc_cd/CD_CMD[*] ] \
                -to I_tc_cd/Icd_params/CD_EBV_OVERRUN_reg*


#This has to do with OSC_DAC being memory mapped. The latch will be stable before it's used
set_false_path -through I_tc_tim/osc_dac_int_lat_reg* \
                -to [get_clocks TIM_CD_CLK]

#CD clk to flags is a true multi-cycle path. Flag regs run on tim_cnt_3. Clks are async, so we leave plenty of time to latch
#-end such that its relative to the slower clock
set_multicycle_path -setup 2 -from [get_clocks TIM_CD_CLK] -to [get_clocks Fbit3_clk] -end
set_false_path -hold -from [get_clocks TIM_CD_CLK] -to [get_clocks Fbit3_clk]

#PT seels lots of paths fomr TIM_STATE_RX through CD_CMD to additional logic, that are not valid.
#It happens that all of these paths end in the MIF, although, this is not historically clear.
#There is a path from the rx to the cd, so this path is more stringent than what historically existed.
set_false_path -through  I_tc_cd/TIM_STATE_RX \
               -through  I_tc_cd/Icd_cmd/CD_CMD[*] \
               -through  I_tc_mif/*

#There's 1.5 cycles from CD_SELECT_PHOENIX going high to the first nvm_sclk
set_multicycle_path 2 -setup -through I_tc_cd/CD_SELECT_PHOENIX \
                -to [list [get_clocks TIM_NVM_SREG_CLK ] [get_clocks TIM_NVM_CLK ]]
set_false_path -hold -through I_tc_cd/CD_SELECT_PHOENIX \
                -to [list [get_clocks TIM_NVM_SREG_CLK ] [get_clocks TIM_NVM_CLK ]]

#The mif doesn't affect the select cmd for phoenix.                 
set_false_path -from [get_clocks TIM_MIF_CLK] -through I_tc_cd/CD_SELECT_PHOENIX
set_false_path -from [get_clocks TIM_MIF_CLK] -through I_tc_cd/CD_SELECT_PHOENIX_LOOK_AHEAD

#SM_PI_ENABLE is set or cleared during the SM state. there are no CD clocks after the SM state
set_false_path -through I_tc_sm/SM_PI_ENABLE -to [get_clocks TIM_CD_CLK]


#The TX bit counter isn't running when the CD clk runs. 
#TODO: PT isn't able to see this path. Might need a  dont_touch on next_bit_ctr
set_multicycle_path 2 -setup -through I_tc_tx/Itc_tx_state_machine/NEXT_BIT_CTR* -to [get_clocks TIM_CD_CLK ]
set_false_path -hold -through I_tc_tx/Itc_tx_state_machine/NEXT_BIT_CTR* -to [get_clocks TIM_CD_CLK ]

#latch to latch timing in the RX. handled by design. 
set_false_path -from I_tc_rx/AT/STATE_v/I_rx_state_*_reg_FORCE_KEEP/CK -to I_tc_rx/AT/PERIOD_v/polp1_b_latch_0_FORCE_KEEP/D

#Multi cycle from tim_state_rx going high or low and pointer_1 shifting. 
set_false_path -through  [list I_tc_tim/TIM_STATE_RX \
                               I_tc_tim/TIM_RX_ENABLE ] \
                -to I_tc_cd/Icd_params/I_pointer1_clock_gate/CG_LATCH_FORCE_KEEP/D

#After the falling edge of TIM_STATE_RX the cd_clk will not run again. 
set_multicycle_path -setup 2 -fall_through I_tc_tim/TIM_STATE_RX \
                -to [get_clocks TIM_CD_CLK]
set_false_path -hold -fall_through I_tc_tim/TIM_STATE_RX \
                -to [get_clocks TIM_CD_CLK]

#Paths from TIM to MIF shouldn't be counted against the TIM_CD_CLK                
set_false_path -from [get_clocks TIM_CLK] \
               -through I_tc_mif/MIF_MEM_DATA \
               -to [get_clocks TIM_CD_CLK]


# POLP is held for several clocks after RX_SCLK edge. No risk of hold violation.
set_false_path -hold -through [get_pins I_tc_rx/AT/EDGE_v/POLP] -to [get_clocks RX_SCLK]
# POLN is held for half clock after RX_CLKN_B rise edge
set_false_path -hold -through [get_pins I_tc_rx/AT/EDGE_v/POLN] -to [get_clocks RX_CLKN_B]

#SM_COVER_CODE is a mux between the CD and TX bit counter. 
# Regs in the CD will only rely on the cd bit_ctr.
set_false_path -through I_tc_tx/Itc_tx_state_machine/TX_STATE_D* \
   -to [get_clocks TIM_CD_CLK]

#The mux that bit selects the cover code is not affected by signals from the MIF.
set_false_path  -from TIM_MIF_CLK \
                -through [list  I_tc_tx/SM_COVER_CODE \
                                I_tc_sm/SM_CAL_OR_ID_CODE ]

#cd_done won't be changing during a write operation or tx
set_false_path -from [get_clocks TIM_CD_CLK] -through I_tc_cd/CD_DONE \
   -to [list [get_clocks TX_D_CLK] ]

if {$env(design_phase) == "SYNTH"} {
    set clock_state_next_state "I_tc_tim/clock_state*/next_state"
} else {
    set clock_state_next_state "I_tc_tim/clock_state*/D"
}
#The tim timers are not enabled during the RX state 
set_false_path -from [ list [get_clocks RX_SCLK] [get_clocks RX_CLK] [get_clocks RX_CLOCK_B ]  [get_clocks RX_CLOCK ] ] \
-through [list I_tc_tim/I_tc_tim_tcalc/T1_FINAL*  \
               I_tc_tim/i_tc_tim_timers/DONE_X \
               I_tc_tim/i_tc_tim_timers/DONE_Y \
               ] \
     -to [list $clock_state_next_state \
              I_tc_tim/tim_state_ff*_FORCE_KEEP/D \
              I_tc_tim/i_tc_tim_timers/i_EARLY_EXPIRED_Y_FORCE_KEEP/D \
              I_tc_tim/i_tc_tim_timers/i_expired_Y_FORCE_KEEP/D \
              ]

#CD_SELECT_PHOENIX is set during the RX stage. The timers for the phoenix timeout don't run until the T1 time.
set_multicycle_path -setup 2 -through I_tc_cd/CD_SELECT_PHOENIX -through I_tc_tim/i_tc_tim_timers/DONE_Y
set_false_path -hold -through I_tc_cd/CD_SELECT_PHOENIX -through I_tc_tim/i_tc_tim_timers/DONE_Y

#CD_SELECT_PHOENIX is set during the RX stage. The timers for the phoenix timeout don't run until the T1 time.
set_multicycle_path -setup 2 -through I_tc_cd/CD_SELECT_PHOENIX -through I_tc_tim/i_tc_tim_timers/DONE_Y
set_false_path -hold -through I_tc_cd/CD_SELECT_PHOENIX -through I_tc_tim/i_tc_tim_timers/DONE_Y

#The RX will be idle when the T2 timers start
set_false_path -through I_tc_cd/CD_DONE \
    -to I_tc_tim/i_tc_tim_timers/i_expired_Y_FORCE_KEEP/D


#There is 1.5clk from PR_DETECT changing to wither mif or cd clock
#I_tc_rx/RX_PR_DETECT ==  I_tc_rx/AT/STATE_v/rx_state_3_0_reg*3* (issues with flattening)
set_false_path -from I_tc_rx/AT/STATE_v/rx_state_3_0_reg*3* \
   -to [list [get_clocks TIM_CD_CLK] [get_clocks TIM_MIF_CLK] ]
set_false_path -from I_tc_rx/AT/STATE_v/rx_state_3_0_reg*3* \
   -through [list I_tc_cd/Icd_cmd/CD_CMD* I_tc_cd/CD_DONE]

set_false_path -through I_tc_cd/Icd_params/pointer1_sr_reg*/Q*  \
   -through I_tc_cd/CD_DONE       
set_false_path -through I_tc_cd/Icd_params/length_sr_reg*/Q* \
   -through I_tc_cd/CD_DONE 


#NOTE: sm_tx_format_d is only a passthrough during the wait or write state
#The CD clk will fire 2.5 clks before this and never after
if {$env(design_phase) == "SYNTH"} {
    set_false_path -from [list [get_clocks TIM_CD_CLK]] \
        -through I_tc_sm/SM_TX_FORMAT*  
} else {
    foreach_in_collection i [get_nets sm_tx_format*] {
        set_false_path -through [get_pins -of_objects $i] \
        -to [list I_tc_tx/a_symbol_q_reg/D I_tc_tx/b_symbol_q_reg/D]
    }
}

#Latch to IO is creating a tight timing path
set_false_path -through I_tc_sm/SM_TX_FORMAT*  \
    -to TIM_ARNG_EN


#The command will be stable before t1/t2
set_false_path -through I_tc_cd/Icd_cmd/CD_CMD*      \
    -to I_tc_tim/i_tc_tim_timers/i_EARLY_EXPIRED_Y_FORCE_KEEP/D    
set_false_path -through I_tc_cd/Icd_cmd/CD_CMD*      \
    -to I_tc_tim/i_tc_tim_timers/i_start_X_FORCE_KEEP/D    
set_false_path -through I_tc_cd/Icd_cmd/CD_CMD*      \
    -to I_tc_tim/i_tc_tim_timers/i_start_Y_FORCE_KEEP/D           


# The PER isn't needed until multiple cycles after the RX is enabled. 
if {$env(design_phase) == "SYNTH" || $env(design_phase) == "PNR" } {
    set path_en "I_tc_rx/AT/PATH_EN"
} else {
    set path_en "I_tc_rx/PATH_EN_AT"
}                
set_false_path -through $path_en  \
    -through [list  I_tc_rx/AT/PERIOD_v/PER*  \
                    I_tc_rx/AT/PERIOD_v/SPER*  \
                    I_tc_rx/AT/PERIOD_v/CNTS*  \
                    I_tc_rx/AT/NPF_v/npw_adder*/sum*]

#INIT will be high for a long time before and after the SM clock
set_false_path -through I_tc_tim/TIM_STATE_SRESET_OR_INIT \
               -to [get_clocks TIM_SM_CLK]

#The RX registers will be stable well before we need to calculate the div2/4 tx
set_false_path -from [get_clocks RX_SCLK ] \
                     -through [list I_tc_tim/I_tc_tim_tcalc/DIV2_TRANSMIT_OUT  \
                              I_tc_tim/I_tc_tim_tcalc/DIV4_TRANSMIT_OUT  \
                              I_tc_tim/osc_dac_int_lat_reg* ]

            
# CD Pointers are only active during RX
# Will be stable during TX clks
set_false_path -through [list I_tc_cd/CD_POINTER[*] \
                              I_tc_cd/Icd_params/cd_pointer_first_ebv_reg/Q* \
                              I_tc_cd/Icd_params/field*_sr* ] \
               -to [get_clocks TX_D_CLK ]


#There are 2 clock cycles after SRESET_B going high before other clocks start moving               
set_false_path -hold -through I_tc_tim/TIM_SRESET_B
set_false_path -hold -through I_tc_tim/TIM_STATE_SRESET_OR_INIT

#We're protected by tim_packet_start, so fistclkdone can be a MCP
set_multicycle_path -setup 2 -from [get_clocks FIRSTCLKDONE_CLK] -to [list [get_clocks TIM_CD_CLK ] [get_clocks TIM_MIF_CLK]]
set_false_path -hold -from [get_clocks FIRSTCLKDONE_CLK] -to  [list [get_clocks TIM_CD_CLK ] [get_clocks TIM_MIF_CLK]]


#Tool is seeing a hold path issue on the reset for this, but there's plenty of space between the CK and RN edges. 
set_false_path -hold -from [get_clocks TIM_CLK] -to [get_clocks FIRSTCLKDONE_CLK] -reset_path


#This reg tracks password mismatches which don't involve cd_mux_bit_addr
set_multicycle_path -setup 2 -through I_tc_sm/SM_COVER_CODE -to I_tc_cd/Icd_params/cd_rx_data_mif_mem_data_match_b_reg
set_false_path -hold -through I_tc_sm/SM_COVER_CODE -to I_tc_cd/Icd_params/cd_rx_data_mif_mem_data_match_b_reg

#INIT_LENGTH is only used during INIT which the CD is not part of
set_multicycle_path -setup 2 -through I_tc_mif/I_tc_mif_state_machine/MIF_INIT_LENGTH \
                             -through I_tc_cd/CD_READ_NVM

set_false_path       -hold   -through I_tc_mif/I_tc_mif_state_machine/MIF_INIT_LENGTH \
                             -through I_tc_cd/CD_READ_NVM

if {$env(design_phase) == "SYNTH"} {
    set_false_path -through I_tc_crc/CRC_PASS_reg/Q \
        -to I_tc_tim/clock_state*/next_state

    #The RX will be idle when the T2 timers start
    set_false_path -from I_tc_rx/AT/PERIOD_v/SPER_reg*/clocked_on      \
        -to I_tc_tim/i_tc_tim_timers/i_EARLY_EXPIRED_Y_FORCE_KEEP/D


    #The format will be stable in the WAIT state
    set_false_path -through [get_ports I_tc_sm/SM_TX_FORMAT*  ] \
       -to  [get_cells I_tc_tx/a_symbol_q_reg ]
    set_false_path -through [get_ports I_tc_sm/SM_TX_FORMAT*  ] \
       -to  [get_cells I_tc_tx/b_symbol_q_reg ]

    #RX will bypass a timeout error check when we're doing a cal command. 
    #We can treat this as a multicycle path
    set_false_path -through [get_ports I_tc_cd/Icd_cmd/CD_CMD*]      \
        -to [list RX_SCLK RX_CLK]

    #The cd_cmd will be stable multiple clocks before it is used
    #TIM_PACKET_START to cd_clk is a half clock path so don't mcp that if it's a synchronous reset
    set_multicycle_path 2 -setup -through [list  \
                              I_tc_cd/Icd_cmd/CD_CMD[*] \
                              I_tc_cd/CD_CMD[*] \
                              I_tc_tim/TIM_PACKET_START  ] \
                             -to [list I_tc_cd/Icd_params/CD_STICKY_SELECT_reg/data_in \
                                       I_tc_cd/Icd_params/cd_match_b_reg/data_in \
                                       I_tc_cd/Icd_params/cd_s_f_bit_match_b_reg/data_in ]
    set_false_path -hold -through [list  \
                              I_tc_cd/Icd_cmd/CD_CMD[*] \
                              I_tc_cd/CD_CMD[*] \
                              I_tc_tim/TIM_PACKET_START  ] \
                             -to [list I_tc_cd/Icd_params/CD_STICKY_SELECT_reg/data_in \
                                       I_tc_cd/Icd_params/cd_match_b_reg/data_in \
                                       I_tc_cd/Icd_params/cd_s_f_bit_match_b_reg/data_in]

    #This path is used for the T1 time, which isn't evaluated until the wait state
    set_false_path -from [get_pins I_tc_rx/AT/STATE_v/rx_state_3_0*/clocked_on] \
        -to [list I_tc_tim/i_tc_tim_timers/i_EARLY_EXPIRED_Y_FORCE_KEEP/D \
		  I_tc_tim/i_tc_tim_timers/i_expired_Y_FORCE_KEEP/D ]      
            

  
    # Due to the mux for the cover_code source (cd vs tx), the cd_bitctr muxes into the TX
    # The CD_CLK won't actually be running during TX.
    set_false_path -through  [list I_tc_cd/CD_MUX_BIT_ADDR_B[*] ] \
                   -to [list I_tc_tx/*_symbol_q_reg/data_in ]   

} elseif {$env(design_phase) == "STA" || $env(design_phase) == "PNR"} {
 
    set_false_path -through I_tc_crc/CRC_PASS_reg/Q \
        -to I_tc_tim/clock_state*/D

    #The RX will be idle when the T2 timers start
    set_false_path -from I_tc_rx/AT/PERIOD_v/SPER_reg*/CK      \
        -to I_tc_tim/i_tc_tim_timers/i_EARLY_EXPIRED_Y_FORCE_KEEP/D


    #The format will be stable in the WAIT state
    foreach_in_collection i [get_nets sm_tx_format*] {
       set_false_path -through [get_pins -of_objects $i] \
           -to [list I_tc_tx/a_symbol_q_reg/D I_tc_tx/b_symbol_q_reg/D]
    }
    #set_false_path -through [get_nets sm_tx_format*] \
    #	-to [list I_tc_tx/a_symbol_q_reg/D I_tc_tx/b_symbol_q_reg/D]

    #The cd_cmd will be stable multiple clocks before it is used
    #TIM_PACKET_START to cd_clk is a half clock path so don't mcp that
    set_multicycle_path 2 -setup -through [list  \
                              I_tc_cd/Icd_cmd/CD_CMD[*] \
                              I_tc_cd/CD_CMD[*] \
                              I_tc_tim/TIM_PACKET_START  ] \
                             -to [list I_tc_cd/Icd_params/CD_STICKY_SELECT_reg/D \
                                       I_tc_cd/Icd_params/cd_match_b_reg/D \
                                       I_tc_cd/Icd_params/cd_s_f_bit_match_b_reg/D ]
   set_false_path -hold -through [list  \
                             I_tc_cd/Icd_cmd/CD_CMD[*] \
                             I_tc_cd/CD_CMD[*] \
                              I_tc_tim/TIM_PACKET_START  ] \
                            -to [list I_tc_cd/Icd_params/CD_STICKY_SELECT_reg/D \
                                      I_tc_cd/Icd_params/cd_match_b_reg/D \
                                      I_tc_cd/Icd_params/cd_s_f_bit_match_b_reg/D ]

   set_false_path -through [list I_tc_tim/TIM_PACKET_START  I_tc_cd/TIM_STATE_RX  I_tc_tim/TIM_STATE_RX I_tc_tim/TIM_RX_ENABLE ] \
                -through [list I_tc_sm/CD_MUX_BIT_ADDR_B[*] I_tc_cd/CD_MUX_BIT_ADDR_B[*] ]  

#set_false_path -through I_tc_tim/TIM_STATE_RX -through I_tc_cd/CD_MUX_BIT_ADDR_B* -to I_tc_cd/Icd_params/CD_EBV_OVERRUN_reg*
   foreach_in_collection i [get_nets I_tc_cd/CD_MUX_BIT_ADDR_B[*]] {
       set_false_path -through [get_pins -of_objects $i] \
           -to [list I_tc_cd/Icd_params/CD_EBV_OVERRUN_reg* \
                     I_tc_cd/Icd_params/CD_ERR_UNSUPPORTED_reg* ]
    }

    #This path is used for the T1 time, which isn't evaluated until the wait state
    set_false_path -from I_tc_rx/AT/STATE_v/rx_state_3_0*_/CK \
        -to [list I_tc_tim/i_tc_tim_timers/i_EARLY_EXPIRED_Y_FORCE_KEEP/D \
		 I_tc_tim/i_tc_tim_timers/i_expired_Y_FORCE_KEEP/D ]

    #Shift registers in the MIF to not immediately affect the address/data generation for the NVM
    #These are all multi-cycle paths
#set_false_path -from [list [ get_pins I_tc_mif/I_tc_mif_cache/pc_word_cache_reg_*_/CK ] \
#                               [ get_pins I_tc_mif/I_tc_mif_cache/locks_cache_int_reg*_/CK ]] \
#            -to [list [get_clocks TIM_SM_CLK] \
#            [get_clocks RX_SCLK] [get_clocks RX_CLK] [get_clocks RX_CLOCK_B ]  [get_clocks RX_CLOCK ] [get_clocks TIM_CD_CLK]]


    # Due to the mux for the cover_code source (cd vs tx), the cd_bitctr muxes into the TX
    # The CD_CLK won't actually be running during TX.
    set_false_path -through  [list I_tc_cd/CD_MUX_BIT_ADDR_B[*] ] \
                   -to [list [get_pins I_tc_tx/*_symbol_q_reg/D ] ]

    set_multicycle_path 2 -hold -rise -from I_tc_tim/I_rx_disable_FORCE_KEEP/CK -to I_tc_rx/AT/EDGE_v/SLICER_DATA_nd_FORCE_KEEP_0/D
} else {
    echo "Error: $env(design_phase) not defined"
}

if { $env(design_phase) == "STA" } {


    ########################### BEGIN PT only exception #########################
    #False path on the falling edge of I_tc_tim/TIM_RX_ENABLE since the rx_enable going will always stay low for multiple cycles
    #-rise refers to a rising value at the path endpoint
    set_multicycle_path 2 -hold -rise -from I_tc_tim/I_rx_disable_FORCE_KEEP/CK -to I_tc_rx/AT/EDGE_v/SLICER_DATA_nd_FORCE_KEEP_0/D

    # Don't consider clock path through TIM_SRESET_B. 
    set_case_analysis 1 I_tc_tim/timsresetb_inv_FORCE_KEEP/Y

    # Reset is deasserted 1 clock ahead of negedge of TX_LF_CLK 
    set_false_path -hold -reset_path -to [get_clocks TX_LF_CLK]   


    ########################### END PT only exception #########################

}


# Exceptions for various ripple counters inside the tc_tim_timers block
# The clock doesn't toggle to the subsequent flop in the ripple chain 
# till the reset on the current flop has been released.

# if {$env(design_phase) == "SYNTH"} {
    # Free Counter bits 3 through 9
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit3_free_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit4_free_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit5_free_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit6_free_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit7_free_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit8_free_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit9_free_FORCE_KEEP/RN
    
    # Timer Y bits 2 through 11
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit2_Y_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit3_Y_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit4_Y_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit5_Y_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit6_Y_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit7_Y_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit8_Y_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit9_Y_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit10_Y_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit11_Y_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit12_Y_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit13_Y_FORCE_KEEP/RN
    
    # Timer X bits 1 through 9
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit1_X_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit2_X_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit3_X_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit4_X_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit5_X_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit6_X_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit7_X_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit8_X_FORCE_KEEP/RN
    set_false_path -through I_tc_tim/i_tc_tim_timers/i_bit9_X_FORCE_KEEP/RN

    # FIF 5-bit ripple counter bit0 - CLR_B is deasserted atleast 16 clocks 
    # away from clock edge.
    set_false_path -through I_tc_fif/I_tc_rctr_5b_up/i_bit0_FORCE_KEEP/RN
    # FIF 5-bit ripple counter bits 1 through 4
    set_false_path -through I_tc_fif/I_tc_rctr_5b_up/i_bit1_FORCE_KEEP/RN
    set_false_path -through I_tc_fif/I_tc_rctr_5b_up/i_bit2_FORCE_KEEP/RN
    set_false_path -through I_tc_fif/I_tc_rctr_5b_up/i_bit3_FORCE_KEEP/RN
    set_false_path -through I_tc_fif/I_tc_rctr_5b_up/i_bit4_FORCE_KEEP/RN

    # TIM 4-bit down counter CLR_B (SN pin of FF) is stable 1/2 cycle before
    # and after posedge of clock
   
if {$env(design_phase) == "SYNTH"} {
    set_false_path -through I_tc_tim/i_tc_rctr_4b_dn/genblk1[0].genblk1.i_bit_FORCE_KEEP/SN
    set_false_path -through I_tc_tim/i_tc_rctr_4b_dn/genblk1[1].genblk1.i_bit_FORCE_KEEP/SN
    set_false_path -through I_tc_tim/i_tc_rctr_4b_dn/genblk1[2].genblk1.i_bit_FORCE_KEEP/SN
    set_false_path -through I_tc_tim/i_tc_rctr_4b_dn/genblk1[3].genblk1.i_bit_FORCE_KEEP/SN
} elseif {$env(design_phase) == "STA" || $env(design_phase) == "PNR"} {
    set_false_path -through I_tc_tim/i_tc_rctr_4b_dn/genblk1_0__genblk1_i_bit_FORCE_KEEP/SN
    set_false_path -through I_tc_tim/i_tc_rctr_4b_dn/genblk1_1__genblk1_i_bit_FORCE_KEEP/SN
    set_false_path -through I_tc_tim/i_tc_rctr_4b_dn/genblk1_2__genblk1_i_bit_FORCE_KEEP/SN
    set_false_path -through I_tc_tim/i_tc_rctr_4b_dn/genblk1_3__genblk1_i_bit_FORCE_KEEP/SN
}
# }








######################################## Merged from the NVM Controller ##################################################



##############################################################
#              Timing Exceptions (false path, muxing)        #
##############################################################

# read_ctrl_clk paths generated during word_swapping and write_verify
# will not be sampled by the TC, these are false paths
#
#  paths from TC tim_mif -> read_clk_ctrl do exist and influence paths, but all of the startpoints
#  are guranteed to be stable before the first edge of read_clk_ctrl will ever come
#  example: 
# Startpoint: WRITE (input port clocked by MIF_CLK)
#  Endpoint: read_valid_dly_reg
#            (rising edge-triggered flip-flop clocked by read_ctrl_clk)
#  Path Group: read_ctrl_clk
#  Path Type: max
#
# write does influence read_valid_dly_reg (read_or_idle), but in order for read_ctrl_clk to ever
# even be on, the WRITE signal must be stable. Is this a multicycle or a false path
#      report_timing -from [get_clocks TIM_MIF*] -to [get_clocks read_ctrl*] -max_paths 100000 

set_false_path -from [list [get_clocks TIM_MIF_CLK] \
                           [get_clocks TIM_CD_CLK] [get_clocks TIM_CLK] [get_clocks TIM_SM_CLK] [get_clocks FIRSTCLKDONE_CLK ]\
                           [get_clocks RX_SCLK] [get_clocks RX_CLK] [get_clocks RX_CLOCK_B ]  [get_clocks RX_CLOCK ]] \
    -to [ list  [get_clocks ctrl_clk_buf ] [get_clocks hvs_clk_80a] \
               [get_clocks hvs_clk_80b] [get_clocks hvs_clk_320a]  [get_clocks hvs_clk_320b]]

set_false_path -from [ list [get_clocks ctrl_clk_buf ] [get_clocks hvs_clk_80a] \
                            [get_clocks hvs_clk_80b] [get_clocks hvs_clk_320a]  [get_clocks hvs_clk_320b]]  \
    -to [list [get_clocks TIM_MIF_CLK]  \
              [get_clocks TIM_CD_CLK]  [get_clocks TIM_CLK]  [get_clocks TIM_SM_CLK] [get_clocks FIRSTCLKDONE_CLK ]\
              [get_clocks RX_SCLK] [get_clocks RX_CLK] [get_clocks RX_CLOCK_B ]  [get_clocks RX_CLOCK ]]

set_false_path -from [list [get_clocks RX_SCLK] [get_clocks RX_CLK] [get_clocks RX_CLOCK_B ]  [get_clocks RX_CLOCK ]] \
               -to [get_clocks HVS_CLK]



#from the nvm controller tcl files
#set_case_analysis 1 [ get_ports RESET_B ]
#For the combined blocks nvm/tc
#set_case_analysis 1 [ get_pins I_tc_nvm/RESET_B ]


# output port is unloaded but its net connects to a different endpoint within the nvm_controller.
##set_false_path -to [get_ports READ_AND_MR_VALID]

# Direct input to output paths
#
# MIF_CAL_DONE (input) to VDD_NVM_OK and RECT_* (outputs) combinational paths are
# not careabouts (all asynchronous with synchronization, as needed).
##set ports {VDD_NVM_OK RECT_BFD_2}
##set_false_path -from [get_ports MIF_CAL_DONE] -to [get_ports $ports]
#
# MARGIN_READ_DTI_EN (TC2_CTRL) loaded far away from NVM writing.
##set_false_path -from [get_ports MARGIN_READ_DTI_EN] -to [get_ports WRITE_DIRECTION]
#
# MARGIN_READ_DTI_EN (TC2_CTRL) loaded far away from margin reading.
##set_false_path -from [get_ports MARGIN_READ_DTI_EN] -to [get_ports MARGIN_READ_DTI_EN_CORE]


# MARGIN_READ_AIR_EN goes high after the CD command phase. We receive the pointer and length fields before the data field
# so we have ample setup time before these endpoints are used. 
set_disable_timing -from A -to Y [get_cells I_tc_nvm/I_cg_hvs_clk_*/CG_AND_FORCE_KEEP] 


# By design hvs_clk_80b and hvs_clk_320b are disabled during mr_state=1
# if {$env(design_phase) == "STA" || $env(design_phase) == "PNR"} {
#    set_false_path -from I_tc_nvm/I_mu1nvm_control_fsm/state_q_reg_8_/CK -to [get_clocks hvs_clk_80b]
#    set_false_path -from I_tc_nvm/I_mu1nvm_control_fsm/state_q_reg_8_/CK -to [get_clocks hvs_clk_320b]
#}


# Data is stable around the positive edge of enable pin of the latch by design.
# hold is met by design
set_false_path -hold -to [get_pins I_tc_nvm/I_cg_hvs_clk_80b/CG_LATCH_FORCE_KEEP/D]

# Recovery and removal checks area handled in design by deasserting RN
# well in advance of posedge of CLK
set_false_path -to [get_pins I_tc_nvm/i_step_cntr/i_bit*_FORCE_KEEP/RN]

# The following nets are architecturally OK false paths, but we do not want to tell synthesis this as we want
# DC/ICC to optimize the path as much as possible. 

#hvs_mr_ok_filt_reg goes high at the start of a margin read and stays there until the end. It's only inputs are clk/reset. 



#Scenario specific exceptions
if { $CASE_ANALYSIS == "INIT" } {
    set_case_analysis 0 I_tc_tim/TIM_RX_ENABLE
    set_case_analysis 0 I_tc_nvm/I_nvm_control_fsm/vltg_chk_fail_q_reg/Q 
}


