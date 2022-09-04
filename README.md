# ![Logo](https://github.com/chromium/chromium/blob/master/chrome/app/theme/chromium/product_logo_64.png) Chromium-49-Windows-XP
Chromium build 49.0.2623.23 archived repo ready to use / build for older Windows XP systems, Window XP SP3+.

# Table of Contents
* [Chromium Embedded Framework Build Process](#Chromium-Embedded-Framework-Build-Process  )
  * [To build a release branch:](#To-build-a-release-branch)
  * [Get CEF](#Get-CEF)
  * [Windows Setup](#Windows-Setup)
* [Troubleshooting](#Troubleshooting)
* [Automate script parameters](#Automate-script-parameters)
  * [Setup options.](#Setup-options.)
  * [Miscellaneous options.](#Miscellaneous-options.)
  * [Update-related options.](#Update-related-options.)
  * [#Build-related options.](#Build-related-options.)
  * [Test-related options.](#Test-related-options.)
  * [Distribution-related options.](#Distribution-related-options.)
* [EOF](#eof)


## Chromium Embedded Framework Build Process  

This is a build guide as of Feb 24 2021, to build CEF/Chromium version 49.0.2623.23 and also 49.3.2623.1401/ 49.0.2623.110 

Requirements  Branch 2623 have the following build requirements, until Aug 2020 that it was tested: 

| Windows  | macOS | Linux  |
| ------------- | ------------- | ------------- |
| WinXP+  | macOS 10.6-10.11  | Ubuntu 14.04+   |
| VS2013u4 or  VS2015u1 (experimental)  | 10.7+ build system w/ 10.10+  base SDK (Xcode 7.1.1+) | Debian Wheezy+   |
| Win10 SDK  |  10.6+ deployment target  |    |
| Ninja  |   Ninja, 64-bit only  |  Ninja  |

### To build a release branch 
```
python /path/to/automate/automate-git.py --download-dir=/path/to/download --branch=2623 
```
### Get CEF
```
cd c:/code/chromium_git/src
git clone https://bitbucket.org/chromiumembedded/cef.git
git checkout -t origin/2623
```
### Windows Setup
Step-by-step Guide
All the below commands should be run using the system ```cmd.exe``` and not a Cygwin shell.

1. Create the following directories.
```
   c:\code\automate
   c:\code\chromium_git
```
   WARNING: If you change the above directory names/locations make sure to (a) use only ASCII characters and (b) choose a short file path (less than 35 characters total). Otherwise, some tooling may fail later in the build process due to invalid or overly long file paths.

2. Get depot_tools from the repo and extract to ```c:\code\depot_tools```. Do not use drag-n-drop or copy-n-paste extract from Explorer, this will not extract the hidden ".git" folder which is necessary for depot_tools to auto-update itself. You can use "Extract all..." from the context menu though. 7-zip is also a good tool for this.


3. Run "update_depot_tools.bat" to install Python and Git. * We don’t need that for our pcs because we already have them.
    ``` 
   cd c:\code\depot_tools
   update_depot_tools.bat
    ```
   
4. Add the ```c:\code\depot_tools``` folder to your system PATH. For example, on Windows 10:
   •	Run the ```SystemPropertiesAdvanced``` command.
   •	Click the ```Environment Variables...``` button.
   •	Double-click on ```Path``` under ```System variables``` to edit the value.


5. Automate-git.py should be inside the folder structure in the repo. You can download the automate-git.py from the repo or download the one from the official CEF site. Script location should be: ```c:\code\automate\automate-git.py```.


6. Create the ```c:\code\chromium_git\update.bat``` script with the following contents.
```
   set GN_DEFINES=is_component_build=true
# Use vs2013 or vs2015 as appropriate.
set GN_ARGUMENTS=--ide=vs2013 --sln=cef --filters=//cef/*
python ..\automate\automate-git.py --download-dir=c:\code\chromium_git --depot-tools-dir=c:\code\depot_tools --no-distrib --no-build
```
Run the ```update.bat``` script and wait for CEF and Chromium source code to download. CEF source code will be downloaded to ```c:\code\chromium_git\cef``` and Chromium source code will be downloaded to ```c:\code\chromium_git\chromium\src```. After download completion the CEF source code will be copied to ```c:\code\chromium_git\chromium\src\cef```.
cd c:\code\chromium_git
update.bat

7. Create the ```c:\code\chromium_git\chromium\src\cef\create.bat``` script with the following contents.
```
set GN_DEFINES=is_component_build=true
# Use vs2013 or vs2015 as appropriate.
set GN_ARGUMENTS=--ide=vs2013 --sln=cef --filters=//cef/*
call cef_create_projects.bat
```
Run the ```create.bat``` script to generate Ninja and Visual Studio project files.
```
cd c:\code\chromium_git\chromium\src\cef
create.bat
```
This will generate a "c:\code\chromium_git\chromium\src\out\Debug_GN_x86\cef.sln" file that can be loaded in Visual Studio for debugging and compiling individual files. Replace “x86” with “x64” in this path to work with the 64-bit build instead of the 32-bit build. Always use Ninja to build the complete project. Repeat this step if you change the project configuration or add/remove files in the GN configuration (BUILD.gn file).
8. Create a Debug build of CEF/Chromium using Ninja. Edit the CEF source code at "c:\code\chromium_git\chromium\src\cef" and repeat this step multiple times to perform incremental builds while developing.
```
cd c:\code\chromium_git\chromium\src
ninja -C out\Debug_GN_x86 cef
```
   Replace "Debug" with "Release" to generate a Release build instead of a Debug build. Replace “x86” with “x64” to generate a 64-bit build instead of a 32-bit build.
9. Run the resulting cefclient sample application.
```
cd c:\code\chromium_git\chromium\src
out\Debug_GN_x86\cefclient.exe
```
   See the Windows debugging guide for detailed debugging instructions.


## Troubleshooting

### Loading...

## Automate script parameters
### Setup options.
--download-dir : 'Download directory with no spaces [required].'

--depot-tools-dir : 'Download directory for depot_tools.'

--depot-tools-archive : 'Zip archive file that contains a single top-level '

--branch : 'Branch of CEF to build (trunk, 1916, ...). This will be used to name the CEF download directory and
to identify the correct URL if --url is not specified. The default value is trunk.'

--url : 'CEF download URL. If not specified the default URL will be used.'

--chromium-url : 'Chromium download URL. If not specified the default URL will be used.'

--checkout : 'Version of CEF to checkout. If not specified the most recent remote version of the branch will be used.'

--chromium-checkout : 'Version of Chromium to checkout (Git branch/hash/tag). This overrides the value specified by CEF in CHROMIUM_BUILD_COMPATIBILITY.txt.'

--chromium-channel : 'Chromium channel to check out (canary, dev, beta or stable). This overrides the value specified by CEF in CHROMIUM_BUILD_COMPATIBILITY.txt.'

--chromium-channel-distance : 'The target number of commits to step in the channel, or 0 to use the newest channel version. Used in combination with --chromium-channel.'

### Miscellaneous options.
--force-config : 'Force creation of a new gclient config file.'

--force-clean : 'Force a clean checkout of Chromium and CEF. This will trigger a new update, build and distribution.'

--force-clean-deps : 'Force a clean checkout of Chromium dependencies. Used in combination with --force-clean.'

--dry-run : 'Output commands without executing them.'

--dry-run-platform : 'Simulate a dry run on the specified platform (windows, macosx, linux). Must be used in combination with the --dry-run flag.'

### Update-related options.
--force-update : 'Force a Chromium and CEF update. This will trigger a new build and distribution.'

--no-update : 'Do not update Chromium or CEF. Pass --force-build or --force-distrib if you desire a new build or distribution.'

--no-cef-update : 'Do not update CEF. Pass --force-build or --force-distrib if you desire a new build or distribution.'

--force-cef-update : 'Force a CEF update. This will cause local changes in the CEF checkout to be discarded and patch files to be reapplied.'

--no-chromium-update : 'Do not update Chromium.'

--no-depot-tools-update : 'Do not update depot_tools.'

--fast-update : 'Update existing Chromium/CEF checkouts for fast incremental builds by attempting to minimize the number of modified files. The update will fail if there are unstaged CEF changes or if Chromium changes are not included in a patch file.'

--force-patch-update : 'Force update of patch files.'

--resave : 'Resave patch files.'

--log-chromium-changes : 'Create a log of the Chromium changes.'

### Build-related options.
--force-build : 'Force CEF debug and release builds. This builds [build-target] on all platforms and chrome_sandbox on Linux.'

--no-build: 'Do not build CEF.'

--build-target : 'Target name(s) to build (defaults to "cefclient").'

--build-tests : 'Also build the test target specified via --test-target.'

--no-debug-build : 'Don't perform the CEF debug build.'

--no-release-build: 'Don't perform the CEF release build.'

--verbose-build : 'Show all command lines while building.'

--build-failure-limit : 'Keep going until N jobs fail.'

--build-log-file : 'Write build logs to file. The file will be named "build-[branch]-[debug|release].log" in the download directory.'

--x64-build : 'Create a 64-bit build.'

--arm-build : 'Create an ARM build.'

### Test-related options.
--run-tests : 'Run the ceftests target.'

--no-debug-tests : 'Don't run debug build tests.'

--no-release-tests : 'Don't run release build tests.'

--test-target : 'Test target name to build (defaults to "ceftests").'

--test-prefix : 'Prefix for running the test executable (e.g. `xvfb-run` on Linux).'

--test-args : 'Arguments that will be passed to the test executable.')

### Distribution-related options.
--force-distrib : 'Force creation of a CEF binary distribution.'

--no-distrib : 'Don't create a CEF binary distribution.'

--minimal-distrib : 'Create a minimal CEF binary distribution.'

--minimal-distrib-only : 'Create a minimal CEF binary distribution only.'

--client-distrib : 'Create a client CEF binary distribution.'

--client-distrib-only : 'Create a client CEF binary distribution only.'

--sandbox-distrib : 'Create a cef_sandbox static library distribution.'

--sandbox-distrib-only : 'Create a cef_sandbox static library distribution only.'

--no-distrib-docs : "Don't create CEF documentation."

--no-distrib-archive : "Don't create archives for output directories."

--clean-artifacts : 'Clean the artifacts output directory.'

--distrib-subdir : 'CEF distrib dir name, child of chromium/src/cef/binary_distrib

# EOF