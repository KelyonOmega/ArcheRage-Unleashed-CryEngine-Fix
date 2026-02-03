## Installer Source

This folder contains the source code for the ArcheRage CryEngine Fix installer.

The installer:
- reads an existing system.cfg
- adds missing CryEngine configuration entries
- never overwrites existing values
- does not modify game files, binaries, or executables

## References

This installer relies exclusively on documented CryEngine 3.x configuration variables
(sys_*, r_*, e_*, gpu_*).

Official documentation:
https://www.cryengine.com/docs/static/engines/cryengine-3/categories/1114113

All applied parameters are based on CryEngine 3.x engine configuration documentation
and do not introduce custom, undocumented, or injected behavior.

## Build Information

The installer executable is built using:
- C# (.NET) for the configuration logic
- Inno Setup for the installer packaging

The build process does not inject, hook, or modify any game binaries.

This source is provided for transparency.
