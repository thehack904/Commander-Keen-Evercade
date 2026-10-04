# Upstream and Build Provenance

## Commander Genius

The runtime is based on Commander Genius.

Upstream repository:

    https://github.com/gerstrong/Commander-Genius

Revision used for v0.1.0:

    fb66a50d7b1fb3d2305f4fc727eaff27edb9f87b

The v0.1.0 release retains the stock Commander Genius launcher. A custom
controller-first launcher is planned for a later release rather than v0.1.0.

## EverSDK

EverSDK was used to produce the ARM toolchain/runtime components for the
original Evercade handheld.

Important package versions used by the neutral rebuild included:

- GCC 11.4.0
- glibc 2.26
- binutils 2.38
- OpenSSL 3.2.0
- curl 8.5.0
- zlib 1.3
- SDL2 2.28.1 EverSDK eversdk-r2
- SDL2_image 2.6.2
- SDL2_mixer 2.8.0
- SDL2_ttf 2.20.2

The distributed runtime was rebuilt/sanitized so local build-user paths and
ELF RPATH/RUNPATH values are not present in the release payload.
