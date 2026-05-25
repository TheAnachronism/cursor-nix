# Cursor for NixOS

Unofficial Nix package for [Cursor](https://cursor.com) - the AI-first code editor and [Cursor CLI](https://cursor.com/docs/cli/overview) agent.

## Installation

### Flake Input (NixOS/Home Manager)

```nix
{
  inputs.cursor.url = "github:tomsch/cursor-nix";

  outputs = { self, nixpkgs, cursor, ... }: {
    # NixOS
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [{
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = [
          cursor.packages.x86_64-linux.default
          cursor.packages.x86_64-linux.cursor-cli
        ];
      }];
    };
  };
}
```

### Direct Run (no install)

```bash
# GUI editor
nix run github:tomsch/cursor-nix --impure

# CLI agent
nix run github:tomsch/cursor-nix#cursor-cli --impure
```

### Imperative Install

```bash
# GUI editor
nix profile install github:tomsch/cursor-nix --impure

# CLI agent
nix profile install github:tomsch/cursor-nix#cursor-cli --impure
```

## Cursor CLI

The `cursor-cli` package provides the terminal-based Cursor agent. After installation, use either `agent` or `cursor-agent`:

```bash
agent --version
agent login
agent
```

See the [Cursor CLI docs](https://cursor.com/docs/cli/overview) for authentication, modes, and headless usage.

## Features

- **AI-powered coding** with Claude, GPT-4, and Cursor's own model
- **Composer** - frontier model built for low-latency agentic coding
- **AI Code Review** - find and fix bugs directly in the editor
- **Instant Grep** - lightning fast codebase search
- Native Wayland support with automatic detection
- VS Code extension compatibility

## Wayland Support

The package automatically enables Wayland support when `NIXOS_OZONE_WL=1` is set:

```bash
export NIXOS_OZONE_WL=1
```

This is typically set by NixOS desktop modules automatically.

## Update Package

Maintainers can update to the latest version:

```bash
./update.sh
```

## License

The Nix packaging is MIT. Cursor itself is proprietary software.

## Links

- [Cursor](https://cursor.com)
- [Cursor Changelog](https://cursor.com/changelog)
- [Cursor Features](https://cursor.com/features)
