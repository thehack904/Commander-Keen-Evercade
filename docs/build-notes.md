# v0.1.0 Build and Device Notes

## Target hardware

- Original Evercade handheld: validated
- EverSD: validated
- Evercade VS: not claimed as validated for v0.1.0

## Runtime

- Commander Genius upstream revision:
  `fb66a50d7b1fb3d2305f4fc727eaff27edb9f87b`
- target: ARM Linux / arm-linux-gnueabihf
- GCC: 11.4.0
- glibc: 2.26
- runtime display profile: 480x272 fullscreen

## EverSD launch

The native launcher invokes Commander Genius through:

    /lib/ld-linux-armhf.so.3 --library-path "$APP/lib" "$APP/bin/CGeniusExe"

This avoids relying on VFAT executable permission bits.

## Validated controller bindings

Commander Genius configuration:

    Left = Joy0-B10
    Up = Joy0-B9
    Right = Joy0-B11
    Down = Joy0-B13
    Jump = Joy0-B4
    Pogo = Joy0-B7
    Fire = Joy0-B6
    Run = Joy0-B2
    Status = Joy0-B3
    Camlead = Joy0-B5
    Help = Joy0-B8
    Back = Joy0-B12
    TwoButtonFiring = false

EverSD metadata labels:

    D-pad = Move
    A = Jump
    B = Pogo
    X = Fire
    Y = Run
    Select = Help
    Start = Status
    L1 = Camlead

## Hardware test result

Keen Episodes 1-5 were validated with user-supplied game data. The sanitized
candidate runtime was tested on the original handheld before being promoted
into the v0.1.0 release payload.

## Privacy/release sanitation

The v0.1.0 runtime was checked for:

- build-user identifiers
- local home-directory paths
- generic `/home/<user>/` paths
- ELF RPATH/RUNPATH
- Commander Keen `.CK1` through `.CK6` data
- `KEEN*.EXE` game executables

The release runtime was also stripped and checked for valid ARM ELF files.
