# 1. Setup and Hold uncertainty

    set osc_jitter 10.0 ; # MAUI-572
    set preroute_skew_margin 0.0 ; # FIXME - need number from ICC runs

    # corner         BUFX0 minimum delay 
    # ss_-40_0.800   1.718
    # ss_-40_0.780   2.300
    # ff_85_1.100    0.162
    # ff_-40_0.640   1.673
    # ff_85_0.540    1.695
    # fs_-40_0.780   1.308
    # fs_-40_0.760   1.740
    # fs_85_0.680    1.622
    # fs_85_0.660    2.037
    # sf_-40_0.740   1.142
    # sf_-40_0.720   1.480
    # sf_85_0.660    1.150
    # sf_85_0.640    1.410
    # ss_85_0.720    1.798
    # tt_25_0.660    2.048
    # tt_85_0.620    1.974
    # tt_-40_0.720   1.703

    #In ICC, these will be set in the MCMM control file. 
    if {${SPAR_TOOL} == "DC" } {
       #using similar timing derates to the Primetime scripts.
       #For slow corners.
       set_timing_derate -late    -net_delay   -data   1.000  
       set_timing_derate -late    -cell_delay  -data   1.000  
       set_timing_derate -late    -net_delay   -clock  1.000  
       set_timing_derate -late    -cell_delay  -clock  1.000  
       set_timing_derate -early   -net_delay   -data   0.85  
       set_timing_derate -early   -cell_delay  -data   0.85   
       set_timing_derate -early   -net_delay   -clock  0.85
       set_timing_derate -early   -cell_delay  -clock  0.85  
    }


    if {${SPAR_TOOL} == "DC"} {
        # Hold uncertainty is don't care in Synthesis
        # Extra over constraint
        set BUFX0_dly 0.162 ; # From ff_85_1.100 .lib, top-left corner of look-up table
        set setup_uncertainty   [ expr $osc_jitter + $preroute_skew_margin + 10.100 ]
        # Till we get the multi scenario flow working in ICC we need to give slightly more
        # margin in DC+ICC so that timing meets across all corners in STA.
        set hold_uncertainty    [ expr $BUFX0_dly  + $preroute_skew_margin + 0.000 ]
    } elseif {${SPAR_TOOL} == "PNR"} {
        set BUFX0_dly 0.162 ; # From ff_85_1.100 .lib, top-left corner of look-up table
        set setup_uncertainty   0
        # Till we get the multi scenario flow working in ICC we need to give slightly more
        # margin in DC+ICC so that timing meets across all corners in STA.
        set hold_uncertainty     [ expr $BUFX0_dly + 0.000 ]

    } elseif {${SPAR_TOOL} == "STA"} {
        # Choose value in PT based on analysis corner
        if { $corner == "ss_-40_0.800" } { 
            set BUFX0_dly 1.718 ; 
        } elseif { $corner == "ss_-40_0.780" } {
            set BUFX0_dly 2.300 ; 
        } elseif { $corner == "ff_85_1.100" } {
            set BUFX0_dly 0.162 ; 
        } elseif { $corner == "ff_-40_0.640" } {
            set BUFX0_dly 1.673 ; 
        } elseif { $corner == "ff_85_0.540" } {
            set BUFX0_dly 1.695 ; 
        } elseif { $corner == "fs_-40_0.780" } {
            set BUFX0_dly 1.308 ; 
        } elseif { $corner == "fs_-40_0.760" } {
            set BUFX0_dly 1.740 ; 
        } elseif { $corner == "fs_85_0.680" } {
            set BUFX0_dly 1.622 ; 
        } elseif { $corner == "fs_85_0.660" } {
            set BUFX0_dly 2.037 ; 
        } elseif { $corner == "sf_-40_0.740" } {
            set BUFX0_dly 1.142 ; 
        } elseif { $corner == "sf_-40_0.720" } {
            set BUFX0_dly 1.480 ; 
        } elseif { $corner == "sf_85_0.660" } {
            set BUFX0_dly 1.150 ;
        } elseif { $corner == "sf_85_0.640" } {
            set BUFX0_dly 1.410 ;
        } elseif { $corner == "ss_85_0.720" } {
            set BUFX0_dly 1.798 ; 
        } elseif { $corner == "tt_25_0.660" } {
            set BUFX0_dly 2.048 ; 
        } elseif { $corner == "tt_85_0.620" } {
            set BUFX0_dly 1.974 ; 
        } elseif { $corner == "tt_-40_0.720" } {
            set BUFX0_dly 1.703 ; 
        } else {
            puts "Review hold margin for this corner, temporarily set to match fastest corner."
            set BUFX0_dly 0.162 ;  
        }
        set setup_uncertainty   [ expr $osc_jitter +  0.010 ]
        set hold_uncertainty    [ expr $BUFX0_dly  +  0.010 ]
    } else {
        echo {SPAR_TOOL}ot defined"
        set setup_uncertainty   [ expr $osc_jitter +  0.100 ]
        set hold_uncertainty    [ expr $BUFX0_dly  +  0.200 ]
    }
    
# 2. Maximum slew rate for clock paths
# John's recommendation - clock slew limit should be equal to slew of a BUFX4
# with 20fF load and input slew at 4x the output slew

    # CORNER            CELL    LOAD    Slew Limit by Corner
    # ff_-40_0.640	BUFX4	0.02	2.508512
    # ff_85_0.540	BUFX4	0.02	2.040838
    # ff_85_1.100	BUFX4	0.02	0.100541
    # fs_-40_0.780	BUFX4	0.02	1.646046
    # fs_-40_0.760	BUFX4	0.02	2.278135
    # fs_85_0.680	BUFX4	0.02	1.843495
    # fs_85_0.660	BUFX4	0.02	2.394293
    # sf_-40_0.740	BUFX4	0.02	2.367283
    # sf_-40_0.720	BUFX4	0.02	3.228027
    # sf_85_0.660	BUFX4	0.02	2.780524
    # sf_85_0.640	BUFX4	0.02	3.587019
    # ss_-40_0.800	BUFX4	0.02	1.852104
    # ss_-40_0.780	BUFX4	0.02    2.563353
    # ss_85_0.720	BUFX4	0.02	2.094636
    # tt_25_0.660	BUFX4	0.02	2.353712
    # tt_85_0.620	BUFX4	0.02	2.111531
    # tt_-40_0.720	BUFX4	0.02	2.189535
    
    if {${SPAR_TOOL} == "DC" || ${SPAR_TOOL} == "PNR"} {
        set clk_slew_limit 1.85 ;
    } elseif {${SPAR_TOOL} == "STA"} {
        if { $corner == "ss_-40_0.800" } { 
            set clk_slew_limit 1.85 ;
        } elseif { $corner == "ss_-40_0.780" } {
            set clk_slew_limit 2.56 ;
        } elseif { $corner == "ff_85_1.100" } {
            set clk_slew_limit 0.1 ;
        } elseif { $corner == "ff_-40_0.640" } {
            set clk_slew_limit 2.51 ;
        } elseif { $corner == "ff_85_0.540" } {
            set clk_slew_limit 2.04 ;
        } elseif { $corner == "fs_-40_0.780" } {
            set clk_slew_limit 1.65 ;
        } elseif { $corner == "fs_-40_0.760" } {
            set clk_slew_limit 2.28 ;
        } elseif { $corner == "fs_85_0.680" } {
            set clk_slew_limit 1.84 ;
        } elseif { $corner == "fs_85_0.660" } {
            set clk_slew_limit 2.39 ;
        } elseif { $corner == "sf_-40_0.740" } {
            set clk_slew_limit 2.37 ;
        } elseif { $corner == "sf_-40_0.720" } {
            set clk_slew_limit 3.23 ;
        } elseif { $corner == "sf_85_0.660" } {
            set clk_slew_limit 2.79 ;
        } elseif { $corner == "sf_85_0.640" } {
            set clk_slew_limit 3.59 ;
        } elseif { $corner == "ss_85_0.720" } {
            set clk_slew_limit 2.09 ;
        } elseif { $corner == "tt_25_0.660" } {
            set clk_slew_limit 2.35 ;
        } elseif { $corner == "tt_85_0.620" } {
            set clk_slew_limit 2.11 ;
        } elseif { $corner == "tt_-40_0.720" } {
            set clk_slew_limit 2.19 ;
        } else {
            puts "Review clk and data slew limits for this corner, temporarily set to match ss_-40_0.800 corner."
            set clk_slew_limit 1.85 ;
        }
    } else {
            puts "${SPAR_TOOL} not defined"
    }   

    set data_slew_limit [expr $clk_slew_limit * 10] ;
