<div align="center">

# asdf-opensloctl [![Build](https://github.com/thisisibrahimd/asdf-opensloctl/actions/workflows/build.yml/badge.svg)](https://github.com/thisisibrahimd/asdf-opensloctl/actions/workflows/build.yml) [![Lint](https://github.com/thisisibrahimd/asdf-opensloctl/actions/workflows/lint.yml/badge.svg)](https://github.com/thisisibrahimd/asdf-opensloctl/actions/workflows/lint.yml)

[opensloctl](https://github.com/thisisibrahimd/opensloctl) plugin for the [asdf version manager](https://asdf-vm.com) or [mise version manager](https://mise.jdx.dev/).

</div>


## Install

Plugin:

```shell
mise plugin install opensloctl https://github.com/thisisibrahimd/asdf-opensloctl
# or
asdf plugin add opensloctl https://github.com/thisisibrahimd/asdf-opensloctl.git
```

opensloctl:

```shell
# Show all installable versions
asdf list-all opensloctl
mise list-all opensloctl

# Install specific version
asdf install opensloctl@1.0.0
mise install opensloctl@1.0.0

# Set a version globally (on your ~/.tool-versions or ~/.config/mise/config.toml file)
asdf global opensloctl@latest
mise install opensloctl@latest

# Now budgetadjustment commands are available
opensloctl --help
```

Check [asdf](https://github.com/asdf-vm/asdf) or [mise](https://github.com/jdx/mise) readme for more instructions on how to install & manage versions.

