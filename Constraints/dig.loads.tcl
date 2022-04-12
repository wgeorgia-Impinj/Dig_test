#//                Capacitance Report
#//*****************************************************
#//Library	: ln1t
#//Cell	: ln1t_tag_8stg_v0
#//Date	: Dec  8 12:55:18 2021
#//*****************************************************

#//Note: Capacitance Calculation based on typical corner model values
#//      All dimensions include scale factor
impSetOutPinLoad RX_DEMOD_EN_UT       0.0850
impSetOutPinLoad PTA_PAD_ENABLE       0.0492
impSetOutPinLoad TIM_DEMOD_HOLD       0.0485
impSetOutPinLoad FIF_FLAGS_WEN[2]     0.0289
impSetOutPinLoad FIF_FLAGS_WEN[1]     0.0177
impSetOutPinLoad TIM_DOUT1_IO_DIR     0.0401
impSetOutPinLoad MIF_LTEST_SEL        0.0402
impSetOutPinLoad MIF_AT_DIS           0.0318
impSetOutPinLoad TIF_DOUT2            0.0337
impSetOutPinLoad TIF_DOUT1            0.0735
impSetOutPinLoad MIF_DTI_SEL          0.0247
impSetOutPinLoad TIM_ARNG_EN          0.0346
impSetOutPinLoad CD_WRITE_DATA        0.0511
impSetOutPinLoad TIM_ARNG_CLK         0.0488
impSetOutPinLoad RX_DEMOD_FT_EN       0.0533
impSetOutPinLoad TX_MOD_DATA          0.1850
impSetOutPinLoad TIM_DEMOD_ENV_EN     0.0258
impSetOutPinLoad TIM_CLK_DIV2_EN      0.0159
impSetOutPinLoad TIM_STATE_RX         0.0572
impSetOutPinLoad FIF_FLAGS_RST_B      0.0200
impSetOutPinLoad FIF_FLAGS_REN[4]     0.0101
impSetOutPinLoad FIF_FLAGS_REN[3]     0.0101
impSetOutPinLoad FIF_FLAGS_REN[2]     0.0102
impSetOutPinLoad FIF_FLAGS_REN[1]     0.0105
impSetOutPinLoad TIM_CLK_DIV4_EN      0.0182
impSetOutPinLoad MIF_CAL_DONE         0.1644
impSetOutPinLoad FIF_FLAGS_D[4]       0.0216
impSetOutPinLoad FIF_FLAGS_D[3]       0.0262
impSetOutPinLoad FIF_FLAGS_D[2]       0.0276
impSetOutPinLoad FIF_FLAGS_D[1]       0.0262
impSetOutPinLoad FIF_FLAGS_D[0]       0.0182
impSetOutPinLoad PARITY_TEST_CONTROL[1] 0.0622
impSetOutPinLoad PARITY_TEST_CONTROL[0] 0.0643
impSetOutPinLoad TIM_OSC_DAC[4]       0.0660
impSetOutPinLoad TIM_OSC_DAC[3]       0.0487
impSetOutPinLoad TIM_OSC_DAC[2]       0.0525
impSetOutPinLoad TIM_OSC_DAC[1]       0.0479
impSetOutPinLoad TIM_OSC_DAC[0]       0.0503
impSetOutPinLoad MIF_NVM_SREG_LOAD_EN 0.0714
impSetOutPinLoad MIF_WRITE_TO_RECT    0.0098
impSetOutPinLoad NVMC_HVS_PHI1_CLK    0.0508
impSetOutPinLoad NVMC_HVSW_RESET      0.0526
impSetOutPinLoad NVMC_HVS_HV2_HOLD_LOW 0.0500
impSetOutPinLoad NVMC_HVS_TUN_EN      0.0922
impSetOutPinLoad MIF_NVM_READ_BIAS_EN 0.0556
impSetOutPinLoad MIF_NVM_READ_EN      0.0709
impSetOutPinLoad NVMC_WRITE_DIRECTION 0.0685
impSetOutPinLoad TIM_NVM_SREG_CLK     0.0522
impSetOutPinLoad MIF_CTRL_ROW[3]      0.0512
impSetOutPinLoad MIF_CTRL_ROW[2]      0.0464
impSetOutPinLoad MIF_CTRL_ROW[1]      0.0639
impSetOutPinLoad MIF_CTRL_ROW[0]      0.0453
impSetOutPinLoad MIF_NVM_SREG_IN      0.0604
impSetOutPinLoad NVMC_HVS_STEP        0.0863
impSetOutPinLoad NVMC_HVS_BIAS_EN     0.0722
impSetOutPinLoad MIF_DIG_CACHE_WRITE  0.0612
impSetOutPinLoad MIF_NVM_WRITE_EN     0.0573
impSetOutPinLoad NVMC_HVS_LOW_V_EN    0.0490
impSetOutPinLoad TIM_NVM_CLK          0.0453
impSetOutPinLoad MIF_BIT16_OVERRIDE   0.0540
impSetOutPinLoad MIF_DTI_CLK          0.0256
impSetOutPinLoad MIF_NVM_ERASE_VERIFY 0.0502
impSetOutPinLoad MIF_NVM_MARGIN_EN    0.0609
impSetOutPinLoad MIF_DTI_CONFIG_CAL_OVERRIDE 0.0121
impSetOutPinLoad MIF_AT_CAP_DEFAULT[2] 0.0417
impSetOutPinLoad MIF_AT_CAP_DEFAULT[1] 0.0472
impSetOutPinLoad MIF_AT_CAP_DEFAULT[0] 0.0454
impSetOutPinLoad NVMC_WRITE_DIRECTION_OR_WVC_EN 0.0867
impSetOutPinLoad MIF_NVM_ALL_ROW_DISABLE 0.0495
impSetOutPinLoad NVM_MARGIN_TRIM_1    0.0483
#
#Calculation Constants:
#  scale:			1 
#  Eox:			8.854e-06 [pF/um]
#  Kox:			3.9
#  Toxn (thin nmos gate):	0.0026 [um]
#  Toxn_tg (thick nmos gate):	0.0056 [um]
#  Toxn_tg_5V (thick nmos gate):	1e+06 [um]
#  Toxp (thin pmos gate):	0.0028 [um]
#  Toxp_tg (thick pmos gate):	0.0059 [um]
#  Toxp_tg_5V (thick pmos gate):	1e+06 [um]
#  Coxn (Eox*Kox/Toxn):		0.013281 [pF/um^2]
#  Coxn_tg (Eox*Kox/Toxn_tg):	0.00616618 [pF/um^2]
#  Coxn_tg_5V (Eox*Kox/Toxn_tg):	3.45306e-11 [pF/um^2]
#  Coxp (Eox*Kox/Toxp):		0.0123324 [pF/um^2]
#  Coxp_tg (Eox*Kox/Toxp_tg):	0.00585264 [pF/um^2]
#  Coxp_tg_5V (Eox*Kox/Toxp_tg):	3.45306e-11 [pF/um^2]
#  Carea_NW (CJ of NWDIO):	0.000137 [pF/um^2]
#  Cperiph_NW (CJSW of NWDIO):	0.000725 [pF/um]
#  Carea_Np (CJ of NDIO):	0.001251 [pF/um^2]
#  Cperiph_Np (CJSW of NDIO):	7.9e-05 [pF/um]
#  Carea_Pp (CJ of PDIO):	0.001077 [pF/um^2]
#  Cperiph_Pp (CJSW of PDIO):	6.4e-05 [pF/um]

