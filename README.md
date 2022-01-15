# From Nuxt v2 to Nuxt Bridge

That repository holds a Dockerfile that creates a stock [Nuxt v2](https://nuxtjs.org/fr/docs/get-started/installation/) and then installs [Nuxt Bridge](https://v3.nuxtjs.org/getting-started/bridge/) on top of it.

The goal being to have a pure Nuxt Bridge based project to compare with, when I'll migrate existing projects using Nuxt Bridge.

## Usage

You can either go straight to the Docker CLI, or use the available [Taskfile](https://taskfile.dev) tasks to keep it simple (must be [installed](https://taskfile.dev/#/installation), though).

### Build

Builds the full image, from the Nuxt v2 installation, to the Nuxt Bridge conversion.

```sh
task build
```

### Run

Runs the Nuxt dev server, from the built image.

```sh
task run
```

### Shell

Creates a Docker container from the built image, and attach an interactive shell to it.

```sh
task shell
```
