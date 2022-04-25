## FIXME verify the last one is needed and change the name
## Read in all the files
#set RTL_COMMON_FILES [glob -dir $git_root/digital/RTL/Common -tails *.v]
set RTL_SOURCE_FILES [glob -dir $git_root/digital/RTL/dig -tails *.v]
set RTL_SOURCE_STRUC_FILES $git_root/digital/RTL/STRUC/lx1tc_oscdig.v

set_app_var search_path "$search_path $git_root/digital/RTL/dig $git_root/digital/RTL/Common"
#set_app_var search_path "$search_path /home/wgeorgia/work/LN1/Post/ln1/digital/rtl_src"

