## About This DevContainer

This repository provides a DevContainer setup for Go.
The Docker image is based on `golang:1.24.2-bullseye` and has a size of approximately 2.3GB after being built.

This setup has been tested only on macOS-x86_64 and Linux-x86_64 as host platforms, with Linux-x86_64 as the container runtime. Compatibility with other environments has not been verified.

You can check the list of supported targets after opening the project in the DevContainer (step 4 below) by running `go tool dist list` in the terminal within VSCode.  
This can also be seen during the process described in step 7.2 below.

### Supported Targets

The list of supported targets based on the `golang:1.24.2-bullseye` image is as follows:

| OS/Platform      | Architectures                                      |
|-------------------|---------------------------------------------------|
| aix              | ppc64                                             |
| android          | 386, amd64, arm, arm64                            |
| darwin (macOS)   | amd64, arm64                                      |
| dragonfly        | amd64                                             |
| freebsd          | 386, amd64, arm, arm64, riscv64                   |
| illumos          | amd64                                             |
| ios              | amd64, arm64                                      |
| js               | wasm                                              |
| linux            | 386, amd64, arm, arm64, loong64, mips, mips64, mips64le, mipsle, ppc64, ppc64le, riscv64, s390x |
| netbsd           | 386, amd64, arm, arm64                            |
| openbsd          | 386, amd64, arm, arm64, ppc64, riscv64            |
| plan9            | 386, amd64, arm                                   |
| solaris          | amd64                                             |
| wasip1           | wasm                                              |
| windows          | 386, amd64, arm64                                 |


## Support This Project

If you found this project helpful, consider supporting its maintenance and future development with a small donation.  
You can buy me a coffee via the Ko-fi link below — thank you! ☕✨  

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/B0B21CR05U)

---

## Getting Started (With Dev Containers)

### 1. Launch VSCode  
Open Visual Studio Code.

### 2. Open the Project Folder in VSCode  
Go to **File → Open Folder** and select the folder where the project is cloned.

### 3. Install VSCode Extension  
If you see a message at the bottom of VSCode saying **"Do you want to install the recommended extensions from GitHub, Microsoft, and others for this repository?"**, click **Install** to install the **Dev Containers** extension along with other recommended extensions.

### 4. Reopen the Project in a Container  
Click the **bottom left corner** of the VSCode window where it says **"Open a Remote Window"** → **Reopen in Container**.  

### 5. Wait for the Container to Build and Set Up  
Wait while the **Dev Container environment prepares**. This process may include **downloading the base image**, **installing required tools and libraries**, and **building the Docker image if necessary**.  
Depending on your internet speed and system performance, this may take **a few minutes**.  
If you see a message prompting you to install recommended extensions like in the previous steps, click **Install** to install the extensions in the container environment.

### 6. Debug the Project  
Open `[WORKSPACE_FOLDER]/app/src/main.go` and press **F5** to start debugging.  
This will generate a debug binary in the `[WORKSPACE_FOLDER]/app/build/debug` directory.  
The project will be **compiled and executed inside the container**, and the output will be visible in the **Terminal**.  
If you see a message in the **Debug Console** after starting the project, switch to the **Terminal** tab to find the running program.  
You can also set breakpoints in the code and use the **Debug Console** to inspect variables and control execution.

After entering your name in the VSCode terminal and pressing Enter, the HTTP server will start.  
You can access it from the host OS browser by navigating to `http://127.0.0.1:8000`.  
The page will display a greeting message: `Hello, [your name]!`.

### 7. Cross-Build the Project  
You can cross-build the project for multiple platforms using predefined or custom target configurations.  
Open the command palette: Press **Ctrl + Shift + P** (macOS: **Cmd + Shift + P**) → **Tasks: Run Task** → select the desired task.

The resulting binaries will be generated in the `[WORKSPACE_FOLDER]/app/build/release` directory.

#### 7.1 Build for Predefined Targets  
Select the task **build release Dynamic (amd64/arm64 for Linux/macOS/Windows)** to generate release binaries for predefined targets.

#### 7.2 Build for Custom Targets  
Select the task **build release dynamic (Manual Multi-Target Selection)**.  
You can use the **arrow keys** to navigate the list of supported targets, press **Space** to select/deselect targets, and press **Enter** to confirm your selection.  
The list of supported targets can also be viewed by running `go tool dist list` in the terminal within VSCode during this process.

### Notes

- The file `[WORKSPACE_FOLDER]/app/build-scripts/build-select.sh` is used for building the project in both debug and release modes.
- The HTTP server running on port 8000 is bound to the external interface, allowing access from outside the container.  
