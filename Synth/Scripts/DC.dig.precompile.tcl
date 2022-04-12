
## Remove standard VT cells. (They end in an S)
set_dont_use [get_lib_cells */*S]

## Removing AOI22 for now as they're a large contributor to X propagation issues.
set_dont_use [get_lib_cells */AOI22*]

## Removing Cells with > 5 pins due to low level routing issues
set_dont_use [get_lib_cells */OAI222*]
set_dont_use [get_lib_cells */OAI221*]
set_dont_use [get_lib_cells */NAND4*]
set_dont_use [get_lib_cells */NOR4*]
set_dont_use [get_lib_cells */*DAFFHRXLD*]

set_target_library_subset -object_list [get_cells "I_tc_tx" ]  -dont_use [get_lib_cells */SSFF*]
set_target_library_subset -object_list [get_cells "I_tc_tif" ]  -dont_use [get_lib_cells */SSFF*]
set_target_library_subset -object_list [get_cells "I_tc_nvm" ]  -dont_use [get_lib_cells */SSFF*]
set_target_library_subset -object_list [get_cells "I_tc_mif/I_tc_mif_state_machine" ]  -dont_use [get_lib_cells */SSFF*]
set_target_library_subset -object_list [get_cells "I_tc_mif/I_tc_mif_registers/I_tc_mif_ctrl_row" ]  -dont_use [get_lib_cells */SSFF*]

#In the RX, if TIM_CLK stops, the RX_CLK will stop while HIGH
set_register_type -exact -flip_flop  DFFXL [get_cells "I_tc_rx/AT/EDGE_v/POLP_clear_stretch_reg" ]
set_register_type -exact -flip_flop  DFFXL [get_cells "I_tc_rx/AT/EDGE_v/POLP_hold_reg" ]
set_register_type -exact -flip_flop  DFFXL [get_cells "I_tc_rx/AT/EDGE_v/SLICER_DATA_pd_reg" ]
set_register_type -exact -flip_flop  DFFXL [get_cells "I_tc_rx/AT/EDGE_v/extended_mask_p_reg" ]
set_register_type -exact -flip_flop  DFFXL [get_cells "I_tc_rx/AT/TIMER_v/TIMEOUT_B_reg" ]
set_register_type -exact -flip_flop  DFFRXL [get_cells "I_tc_mif/I_tc_mif_registers/MIF_MEM_DATA_DLYD_reg"]
set_register_type -exact -flip_flop  DFFRXL [get_cells "I_tc_mif/I_tc_mif_registers/MIF_MR_AIR_FAIL_reg"]
set_register_type -exact -flip_flop  DFFXL [get_cells "I_tc_rx/AT/TIMER_v/TIMEOUT_B_reg" ]

#Set don't touch on all of the DFF* modules
## FIXME this should be a proc
foreach_in_collection cell [get_cells -hier  *] {
    set ref [get_attribute $cell ref_name]
    set name [get_attribute $cell name]
    if { [string first DFF $ref] != -1  } {
        set_dont_touch $cell
        puts "set_dont_touch $cell ($name:$ref)"
    }
}
set_dont_touch [get_cells -hier *FORCE_KEEP*] true

## This should be a proc
# Force keep signals for SDF simulation
foreach_in_collection a [get_nets {cd_cmd* cd_session sm_state I_tc_tim/tim_state* I_tc_tim/I_tc_tim_tcalc/TRCAL* mif_done fif_sx sm_sx_write  cd_done} ] {
  set_dont_touch $a
}

## Move this to the dig portion
set mif_hierarchy [get_designs "tc_mif tc_mif_state_machine tc_mif_registers tc_mif_rules"]
set_ungroup $mif_hierarchy false
#Dont flatten other things
set other_hierarchy [get_designs "tc_rng tc_rx tc_sm tc_tif tc_tim tc_crc"]
set_ungroup $other_hierarchy false

