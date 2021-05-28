# Re Factor Elixir (Rfx)

Rfx provides a catalog of automated refactoring operations for Elixir source
code.

Project Operations:

- [ ] add dependency
- [ ] increment version

Module Operations:

- [ ] rename module
- [ ] rename module attribute
- [ ] extract function
- [ ] inline function

Function Operations:

- [ ] rename function
- [ ] rename function parameter
- [ ] rename variable
- [ ] extract variable
- [ ] inline variable

PhxGen Operations:

- [ ] Add route
- [ ] Add controller

PhxGenAuth Operations:

- [ ] Add controller

Credo Operations:

- [ ] multi_alias

Rfx Operations are designed to be embedded into editors, tools and end-user
applications:

- Examples and Tests
- Scripts and Livebook Notebooks
- Mix tasks
- Cli (rx)
- Generators (eg phx.gen, phx.gen.auth)
- Editor Plugins, ElixirLs
- Credo

## Installation

```elixir
def deps do
  [
    {:rfx, "~> 0.1.0"}
  ]
end
```
