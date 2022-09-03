# set DEPOT_TOOLS_WIN_TOOLCHAIN=0
# set GYP_GENERATORS=ninja,msvs-ninja
# set GYP_MSVS_VERSION=2013
# set CEF_USE_GN = 1 
set GN_DEFINES=is_official_build=true proprietary_codecs=true ffmpeg_branding=Chrome
set GN_DEFINES =is_win_fastlink = true 
set GN_DEFINES=is_component_build=true
# Use vs2013 or vs2015 as appropriate.
set GN_ARGUMENTS =--ide=vs2013 --sln=cef --filters=//cef/* 
python ..\automate\automate-git.py --download-dir=D:\code\chromium_git --depot-tools-dir=D:\code\depot_tools --no-distrib --no-build