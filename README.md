<div align="center">

# asdf-source-to-image [![Build](https://github.com/bartoszmajsak/asdf-source-to-image/actions/workflows/build.yml/badge.svg)](https://github.com/bartoszmajsak/asdf-source-to-image/actions/workflows/build.yml) [![Lint](https://github.com/bartoszmajsak/asdf-source-to-image/actions/workflows/lint.yml/badge.svg)](https://github.com/bartoszmajsak/asdf-source-to-image/actions/workflows/lint.yml)


[source-to-image](https://github.com/openshift/source-to-image) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `jq` 

# Install

Plugin:

```shell
asdf plugin add source-to-image https://github.com/bartoszmajsak/asdf-source-to-image.git
```

source-to-image:

```shell
# Show all installable versions
asdf list-all source-to-image

# Install specific version
asdf install source-to-image latest

# Set a version globally (on your ~/.tool-versions file)
asdf global source-to-image latest

# Now source-to-image commands are available
source-to-image --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/bartoszmajsak/asdf-source-to-image/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [bartoszmajsak](https://github.com/bartoszmajsak/)
