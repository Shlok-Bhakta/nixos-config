# NixOS Configuration Agent Guidelines

## Build/Test Commands
- Build configuration: `nrs` do not worry about hostname all that is handled. This command should never be run. Ask the user to run it.


## Code Style Guidelines
- Use 2-space indentation for Nix files
- Format with `nixfmt`
- Import statements at top of files
- Use `let...in` blocks for local variables
- Follow NixOS module conventions
- Package definitions in `pkgs/` directory
- Use descriptive variable names with kebab-case for files
- Enable `allowUnfree` in system configurations
- Use `inherit` for passing inputs between modules

## Creation Guidelines
- Make sure any new files are tracked by git so the nix commands can find them.
- Make sure your configuration is called in all the right places. You must make sure that desktop and laptop configurations maintain parity whislt also offering the ability to seperate some features.
- Follow the NixOS module conventions
- Use descriptive names and make sure to use kebab-case for files
- Use home-manager as much as possible
- For configurations, use a seperate file in the native config language. For example rofi uses .rasi files so use those instead of nix specific config.