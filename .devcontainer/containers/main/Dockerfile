# Base image selection: stable and includes glibc
FROM golang:1.24.2-bullseye

# Install necessary system packages (for CGO, debugging, and building)
RUN apt-get update && apt-get install -y --no-install-recommends \
    fzf \
    nano \
    git \
    curl \
    gcc \
    g++ \
    gdb \
    pkg-config \
    libc6-dev \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# fzf is needed to prompt the user for selection during build

# Install delve (Go debugger)
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Convenience tools (VSCode installs these during debugging, but pre-installing in the Dockerfile is faster/more reliable)
RUN go install golang.org/x/tools/gopls@latest \
    && go install honnef.co/go/tools/cmd/staticcheck@latest

# Set the working directory
WORKDIR /workspace

# Default command to keep the container running (using tail)
CMD [ "tail", "-f", "/dev/null" ]
