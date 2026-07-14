# Changelog

All notable changes to this buildpack are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [v0.2] - 2026-07-14

### Changed
- Upgraded bundled **poppler 25.03.0 → 26.04.0**.
  - 26.04.0 is the newest poppler that builds against the heroku-22 (Ubuntu
    22.04) system libraries. 26.07.0+ requires Freetype >= 2.13, but heroku-22
    ships 2.11.1.
- Build now installs an official **CMake 3.31.6** binary instead of the apt
  `cmake` package (Ubuntu 22.04 ships 3.22.1; poppler 26 requires >= 3.28).

### Security
Upgrading from poppler 25.03.0 to 26.04.0 picks up the upstream fixes for:

| CVE | Severity | Issue | Fixed upstream in |
|-----|----------|-------|-------------------|
| CVE-2025-52885 | Medium | Use-after-free (write) in `StructTreeRoot` | 25.10.0 |
| CVE-2025-52886 | Medium | Crafted-input flaw | 25.06.0 |
| CVE-2025-43903 | Medium | NSS signature not verifying signer | 25.04.0 |
| CVE-2025-43718 | Low | Stack exhaustion via deep recursion | 25.04.0 |
| CVE-2025-32365 | Medium | OOB read in `JBIG2Bitmap::combine` | 25.04.0 |
| CVE-2025-32364 | Medium | Floating-point exception in `PSStack::roll` | 25.04.0 |

Additionally, we carry a patch for a vulnerability that is **not yet fixed in
any upstream poppler release** (including 26.07.0):

| CVE | Severity | Issue | Mitigation |
|-----|----------|-------|------------|
| CVE-2026-10118 | **High (7.8)** | Integer overflow in `SplashOutputDev::tilingPatternFill` → heap out-of-bounds write, possible RCE via a crafted PDF | `patches/CVE-2026-10118-tilingPatternFill-overflow.patch` (adds `checkedMultiply` overflow guards), applied at build time |

### Known / unaddressed
- CVE-2019-9543 and CVE-2019-9545 (uncontrolled-recursion DoS) remain open
  upstream. Low severity; Debian classifies them as "unimportant" and no
  poppler release fixes them.

## [v0.1]

### Added
- Initial buildpack bundling poppler 25.03.0 for the heroku-22 stack.
