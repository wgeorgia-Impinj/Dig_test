### Margins

    if {$env(design_phase) == "SYNTH"} {
        set  scaling_factor                0.90     ;  # Over-constrain clocks during synthesis
    } elseif { $env(design_phase) == "PNR"} {
        set  scaling_factor                0.90     ;  # Under constrain to help with DRCs or over-constrain to help with timing. Your call. 
    } elseif {$env(design_phase) == "STA" } {
        set  scaling_factor                1.0     ;  # Full clock period during STA
    } else {
        echo "$env(design_phase) not defined"
        set  scaling_factor                1.0     ;  # Full clock period if undefined
    }

source -verbose  -echo $git_root/digital/syn_spar/constraints/common.constraints.tcl
source -verbose  -echo $git_root/digital/syn_spar/scripts/impinj_utils.tcl

###TIM CLOCKS####
# Discussion with Theron and Charles 01/29/2018
# (1) The uncalibrated OSC freq max is 1920kHz, period 520.83 ns. --> rounded down to 520ns
# (2) The calibrated OSC freq max is 1280kHz + 8% uncertainty (1382khz) 
# Just to make this more difficult, we also have a feature called osc_boost,
# which changes the osc frequency during backscatter to hit certain 
# data rates. The max osc boost value is 1416khz.
# So, 1.08*1416=1529khz would technically be be our max calibrated frequency
# Period = 654ns --> rounded off to 650ns
# (3) Discussion with Jas and Jesse (06/01/18)
# Jas to reran Oscillator simulations to find our what the real max frequency is.
# Untrimmed max frequencies that we will see in the oscillator:
# TT = 1.55MHz
# FF = 1.9MHz
# SF = 1.55MHz
# FS = 1.65MHz
# SS = 1.3MHz

# To further complicate this discussion, the Production Test team runs vectors fast to
# decrease test time. Therefore, when communicating through the DTI (esp. when
# DTI_CLK_SEL=1), PTE supplies a 1280kHz+20% = 1536kHz clock (see MAUI-533). This clock
# is not boosted; boosting only applies to the internal oscillator. Therefore, the max
# "calibrated" clock is actually 1536kHz plus margin, though not as bad as the 1800kHz
# being used below.

##set CASE_ANALYSIS "RX"
if { [info exists CASE_ANALYSIS] == 0 } { set CASE_ANALYSIS "RX" }
if { $CASE_ANALYSIS == "INIT" } {
    # We seem to have enough margin on the FF corner. So we will use the untrimmed max freq
    # for FS corner (next worst case) for timing so that we aren't over-constraining.
    # 1/1.65MHz ~= 606ns
    # Leaving the above as its what LX1 was closed at. Might not have been pessimistic enough. Should have closed at 1900khz which is max uncallibrated osc freq.
    # 1900 khz period is 526ns period. Can be revisited if closure is too difficult      
    set OSC_CLK_PERIOD_UNSCALED 526
    set OSC_CLK_PERIOD          [expr $OSC_CLK_PERIOD_UNSCALED * $scaling_factor] ; 
    set VCLK_PERIOD             [expr $OSC_CLK_PERIOD_UNSCALED * $scaling_factor] ; 
} elseif { $CASE_ANALYSIS == "RX" || $CASE_ANALYSIS == "TX" } {

    # Targetting a backscatter for PI mode of 711 khz
    # Thus, need to close at 1422 khz + oscillator margin of 8%
    # John believes a safe value to be 1280+8%+23%. These results in a frequency of 1700, period of 588ns. This is very conservative and can be revisted if closure is too difficult.   
    set OSC_CLK_PERIOD_UNSCALED 588
    set OSC_CLK_PERIOD          [expr $OSC_CLK_PERIOD_UNSCALED * $scaling_factor] ; 
    set VCLK_PERIOD             [expr $OSC_CLK_PERIOD_UNSCALED * $scaling_factor] ;     #MCMM flow is using 1280+8%=1382 

} else {
    puts "Error: CASE_ANALYSIS not found. 'CASE_ANALYSIS'='${CASE_ANALYSIS}"
    exit 1
}

set inports  [remove_from_collection [all_inputs] [get_ports OSC_CLK]]
set outports [all_outputs]



######################################## Merged from the NVM Controller ##################################################

##############################################################
#              Clock Period Variable Declaration             #
##############################################################

# Specs:
# Oscillator:
# OSC Uncalibrated:         1920 kHz
# OSC Calibrated            1280 kHz + 8%
# OSC Fast (Sort and PT)    1280 kHz + 20%  (see MAUI-533)
# OSC as constrained by TC  1800 kHz        (see mu1t_tc.constraints.tcl)
#
# The NVM Controller will need to be able to WRITE at the maximum calibrated osc frequency
# and READ at the maximum un-calibrated osc frequency.
#
# NVM Read Clock:
# SREG_AND_SAMP_CLK     640  kHz + 8%
#

# Baseline 1280 kHz clock period
#set nvm_osc_1280_period 781.3

# Match TC assumptions of 1800 kHz for the case where we need to READ (see above).
# 1536kHz+8% margin which is what PTE uses for Sort and MS6/7 on COBs
#set nvm_osc_cal_period 602
#
#set nvm_osc_samp_input_delay_margin 0.65
#
#
#if {$env(design_phase) == "SYNTH"} {
#    set  nvm_scaling_factor                0.85     ;  # Over-constrain clocks during synthesis
#} elseif {$env(design_phase) == "PNR"} {
#    set  nvm_scaling_factor                0.9     ;  # Full clock period during STA
#} elseif {$env(design_phase) == "STA"} {
#    set  nvm_scaling_factor                1.0     ;  # Full clock period during STA
#} else {
#    echo "$env(design_phase) not defined"
#    set  nvm_scaling_factor                1.0     ;  # Full clock period if undefined
#}
#
#set nvm_osc_period          [ expr $nvm_osc_cal_period * $nvm_scaling_factor ]

################# end NVM ##############################





### 
source -echo $git_root/digital/syn_spar/constraints/dig.clocks.tcl
source -echo $git_root/digital/syn_spar/constraints/dig.exceptions.tcl
source -echo $git_root/digital/syn_spar/constraints/dig.io.tcl
###

#Clock gating check are disabled
#FIXME: One day someone needs to look at clock gating checks. 
remove_clock_gating_check


#Paths that need some extra margin at Slow so they can meet in other corners (sf/fs)
if {$env(design_phase) == "PNR" } {
  #real hold timing path
  #set_path_margin -hold 1 -from I_tc_nvm/hvs_bg_ok_count_reg_*_ -to I_tc_nvm/hvs_bg_ok_filt_mr_reg
  #set_path_margin -setup 20 -from READ_SAMP_CORE_OUT[*] -to I_tc_mif/I_tc_mif_rules/MIF_ERR_INSUF_PWR_MR_AIR_reg
  set_path_margin -setup 50 -from I_tc_mif/I_tc_mif_state_machine/MIF_STATE_reg_* -to I_tc_mif/I_tc_mif_registers/I_tc_mif_ctrl_row/MIF_CTRL_ROW_reg*
  set_path_margin -setup 40 -from I_tc_cd/Icd_params/pointer1_sr_reg* -to I_tc_tim/tim_state_ff*_FORCE_KEEP
}
