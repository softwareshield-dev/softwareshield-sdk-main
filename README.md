# SoftwareShield SDK

[SoftwareShield](http://www.softwareshield.com/) is a cross-platform DRM solution for software developers. 

This is the main project for SoftwareShield SDK, including multiple sub-projects of glue code for different programming languages and the released SDK binaries and utilities.

## Sub-Projects

- [SoftwareShield SDK for C/C++](https://github.com/softwareshield-dev/softwareshield-sdk-c)
- [SoftwareShield SDK for C#](https://github.com/softwareshield-dev/softwareshield-sdk-csharp)
- [SoftwareShield SDK for Python](https://github.com/softwareshield-dev/softwareshield-sdk-python)
- [SoftwareShield SDK for Delphi](https://github.com/softwareshield-dev/softwareshield-sdk-delphi)
- [SoftwareShield SDK for Javascript (running in a web browser)](https://github.com/softwareshield-dev/softwareshield-sdk-js)

## Contents

```
${SDK-MAIN}
    ├───bin/: SDK binaries and utilities
    ├───license-projects/: sample license projects used by all SDK-xxx modules;
    ├───SDK-xxx/: sub-modules of sdk-main, SDK glue codes for different programming lanugages;
```

To get the latest version from github including all sub-modules:

```
git clone  --recurse-submodules https://github.com/softwareshield-dev/softwareshield-sdk-main.git
```
