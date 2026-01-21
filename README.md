# ArcheRage-Unleashed-CryEngine-Fix
ArcheAge’s CryEngine was never properly optimized by XL Games. Outdated limits and disabled features caused stuttering, slow loading and poor hardware utilization. 
This installer does not replace or modify any game files — it only adds the required system.cfg entries for your system, improving the use of existing CryEngine features.

Installer:

<img width="600" height="464" alt="INSTALLER" src="https://github.com/user-attachments/assets/ba151d51-2fc9-4e23-b84f-a737e4d2eb87" />

My HWINFO:

<img width="900" height="503" alt="HWINFO" src="https://github.com/user-attachments/assets/d808920e-06c5-4cfe-aef1-b63492f807b8" />

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# ArcheRage CryEngine System.cfg Installer

This installer improves ArcheAge’s CryEngine performance and stability by adding missing or unused configuration entries to the system.cfg.

## What this does
- Improves overall performance and engine stability
- Enables better CPU, GPU and RAM utilization
- Improves streaming behavior and loading times
- Reduces stuttering and micro-freezes

----------------------------------------------------------------------------------

## What this does NOT do
- No game files are replaced or modified
- No binaries, assets or executables are changed
- No mods, cheats or injections are used

----------------------------------------------------------------------------------

## Safety
- Fully reversible
- Uses only standard CryEngine configuration parameters
- Works entirely within the existing game engine

----------------------------------------------------------------------------------

## References
This installer relies exclusively on standard CryEngine configuration features.  
For official engine documentation, see the:
[CryEngine 3.x Documentation](https://www.cryengine.com/docs/static/engines/cryengine-3/categories/1114113)

----------------------------------------------------------------------------------

# ArcheRage CryEngine System.cfg Installer

👉 **Download the installer (v1.0.0):**  
https://github.com/KelyonOmega/ArcheRage-Unleashed-CryEngine-Fix/releases/tag/v1.0.0

----------------------------------------------------------------------------------

## Usage
1. Run the installer
2. Select your ArcheAge Documents folder (e.g. Documents\ArcheRage)
   The installer will handle the system.cfg automatically.
3. Start the game
4. Enjoy improved performance and stability

---------------------------------------------------------------------------------

## Applied system.cfg Entries (Reference)

Below is a reference of the configuration entries added by the installer.  
Only missing entries are added — existing values are never overwritten.

Values marked with **"``X``"** are calculated dynamically based on the detected system.  
They are **NOT fixed presets**.

; ==== CryEngine system.cfg reference (applied by installer) ====

- ``sys_job_system_enable = 1``
; Enables CryEngine's internal job system for parallel task execution.

- ``sys_budget_videomem = X``
; Sets the video memory budget based on detected GPU VRAM.
; Improves texture streaming stability and reduces pop-in.

- ``sys_budget_sysmem = X``
; Allocates system memory budget based on installed RAM.
; Prevents aggressive streaming stalls and late asset loading.

- ``sys_streaming_memory_size = X``
; Controls total memory available for streaming operations.
; Scales dynamically with system memory.

- ``sys_job_system_max_worker = X``
; Sets the number of worker threads based on detected logical CPU cores.

- ``sys_streaming_use_lods = 0``
; Forces full-quality streaming where possible, avoiding overly aggressive LOD downgrades.

- ``sys_budget_frametime = 16``
; Sets a 16 ms streaming time budget (60 FPS target) to prevent frame spikes.

- ``r_UsePBuffers = 0``
; Disables legacy pixel buffers to reduce unnecessary overhead.

- ``r_TexturesStreamPoolSize = 1536``
; Sets a conservative texture streaming pool size.
; ; Sets a conservative texture streaming pool size to improve stability.

- ``r_UseParticlesHalfRes = 1``
; Renders particles at half resolution to reduce GPU load.

- ``r_PostProcessEffects = 1``
; Ensures post-processing remains enabled for visual consistency.

- ``e_ParticlesMaxScreenFill = 32``
; Limits particle screen coverage to prevent excessive overdraw.

- ``r_TexturesStreaming = 1``
; Enables texture streaming.

- ``sys_streaming_max_concurrent_requests = 40``
; Allows more simultaneous streaming requests to reduce loading stalls.

- ``ui_RenderThreadUpdate = 1``
; Moves UI updates to the render thread for smoother frame pacing.

- ``e_ObjFastRegister = 1``
; Speeds up static object registration during level loading.

- ``e_StatObjMerge = 1``
; Enables static object merging to reduce draw calls.

- ``e_MergedMeshes = 1``
; Enables merged mesh rendering for improved performance.

- ``e_MergedMeshesInstanceDist = 512``
; Sets instance merge distance for static geometry.

- ``r_GeomInstancing = 1``
; Enables GPU geometry instancing where supported.

- ``r_UseHardwareOcclusionQueries = 1``
; Enables hardware occlusion queries to reduce overdraw.

- ``e_PreloadMaterials = 1``
; Preloads materials to reduce in-game hitching.

- ``r_UseShaderThread = 1``
; Enables a dedicated shader thread.

- ``r_UseThreadedShaders = 1``
; Allows shader compilation and handling across multiple threads.

- ``r_ShaderCompilationAsync = 1``
; Enables asynchronous shader compilation to prevent stalls.

- ``r_ShadersPrecache = 1``
; Precaches shaders to reduce runtime compilation hitches.

- ``gpu_ParticlePhysics = 0``
; Disables GPU particle physics to avoid instability and driver overhead.

- ``r_TexturesStreamingPrioritizeVisibleMips = 1``
; Prioritizes visible texture mip levels to improve visual stability.

