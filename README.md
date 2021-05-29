# Rfx = ReFactor Elixir

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

Rfx Operations are intended to be embedded into editors, tools and end-user
applications:

- Examples and Tests
- Elixir Scripts and LiveNotebooks
- Mix tasks
- CLI (rfx)
- Generators (eg phx.gen, phx.gen.auth)
- Editor Plugins, ElixirLs
- Credo
- Etc.

Rfx depends on the excellent [Sourceror](http://github.com/doorgan/sourceror)
written by [@doorgan](http://github.com/doorgan).

## Installation

```elixir
def deps do
  [
    {:rfx, github: "andyl/rfx"}
  ]
end
```
