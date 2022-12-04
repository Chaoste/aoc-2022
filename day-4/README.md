# Ada

## Setup

Download from https://www.adacore.com/download/more . I took the x86 64 bit version for my M1 Mac (the ARM version didn't work). Execute the installer and remember the installation path. For me, it was `$HOME/opt/GNAT/2020`.

Then add this to your `~/.zshrc` or `~/.bash_profile`:
```
export PATH=$PATH:$HOME/opt/GNAT/2020/bin
export LIBRARY_PATH="$LIBRARY_PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"
```
The second command fixed the error "ld: library not found for -lSystem" when running `gnatmake`.

## Run

```
  gnatmake ./exercise_a.adb
  ./exercise_a
```
