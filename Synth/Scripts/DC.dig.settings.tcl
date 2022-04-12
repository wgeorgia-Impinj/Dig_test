## FIXME verify the last one is needed
## Read in all the files
set RTL_COMMON_FILES [glob -dir $git_root/digital/RTL/common -tails *.v]
set RTL_SOURCE_FILES [glob -dir $git_root/digital/RTL/dig -tails *.v]
set RTL_SOURCE_STRUC_FILES $git_root/digital/struc_src/lx1tc_oscdig.v

set RTL_SOURCE_FILES [glob -dir /home/wgeorgia/work/New_Flow/PiDice/digital/dig/RTL -tails *.v]
set RTL_SOURCE_STRUC_FILES /home/wgeorgia/work/New_Flow/PiDice/digital/struc_src/lx1tc_oscdig.v
set_app_var search_path ".  /home/wgeorgia/work/New_Flow/PiDice/digital/dig/RTL $search_path"

## FIXME Append for dig
#set ADDITIONAL_SEARCH_PATH        "../../../rtl_src"
## FIXME Append for nvm
#set ADDITIONAL_SEARCH_PATH        "../../../models/nvm_ip"

## FIXME Could be in project dc file
#set MW_REFERENCE_LIB_DIRS           "$currentDir/../ref_lib/imp065_sc_v2_lvf_LIB"

