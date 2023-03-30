# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test source-to-image https://github.com/bartoszmajsak/asdf-source-to-image.git "source-to-image --help"
```

Tests are automatically run in GitHub Actions on push and PR.
