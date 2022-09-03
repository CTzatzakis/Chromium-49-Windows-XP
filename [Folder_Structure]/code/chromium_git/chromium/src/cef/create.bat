set GN_DEFINES=is_component_build=true
# Use vs2013 or vs2015 as appropriate.
set GN_ARGUMENTS=--ide=vs2013 --sln=cef --filters=//cef/*
call cef_create_projects.bat