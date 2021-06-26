# Rfx : ReFactor Elixir

Rfx provides a catalog of automated refactoring operations for Elixir source
code.  

**NOTE** This code is under heavy development!  It will change rapidly!  There
will be bugs!

Rfx operations are meant to be embedded into editors, tools and end-user
applications.  See the experimental app [rfxi](https://github.com/andyl/rfxi)
for an example.

To get started with this pre-release code, clone the repo, then run `> mix test
--exclude pending`.

## Ops Modules

See `Rfx.Catalog.OpsCat` for a current catalog of Operations.

Module Operations:

- [ ] rename module (`Rfx.Ops.Module.RenameModule`)
- [ ] rename module attribute
- [ ] extract function
- [ ] inline function

Function Operations:

- [ ] rename function
- [ ] rename function parameter
- [ ] rename variable
- [ ] extract variable
- [ ] inline variable

Filesystem Operations:

- [ ] move directory (`Rfx.Ops.Filesys.MvDir`)
- [ ] move file (`Rfx.Ops.Filesys.MvFile`)

Credo Operations:

- [x] multi-alias (`Rfx.Ops.Credo.MultiAlias`)

Surface Operations:

- [ ] rename component
- [ ] rename property
- [ ] rename named-slot

PhxGen Operations:

- [ ] add route
- [ ] add controller

PhxGenAuth Operations:

- [ ] add controller

Project Operations:

- [ ] add dependency 
- [ ] increment version

Prototype Operations:

- [x] comment add (`Rfx.Ops.Proto.CommentAdd`)
- [x] comment del (`Rfx.Ops.Proto.CommentDel`)
- [x] no-op (`Rfx.Ops.Proto.NoOp`)

Rfx Operations depend on the excellent
[Sourceror](http://github.com/doorgan/sourceror) written by
[@doorgan](http://github.com/doorgan).

## Change Sets

Each operation returns a *change set* (`Rfx.Change.Set`) with a list of of
*change requests* (`Rfx.Change.Request`).  The *change set* is a data structure
that describes all the refactoring changes to be made for an operation.

A *change request* struct has elements for *text edits* and *file actions*
(create, rename, delete).

## Converter Functions

Rfx provides an extensible catalog of converter functions:

```elixir
Rfx.Change.Set.convert(changeset, :to_string)    #> Returns the modified source code
Rfx.Change.Set.convert(changeset, :to_patchfile) #> Returns a unix-standard patchfile
Rfx.Change.Set.convert(changeset, :to_lsp)       #> Returns a data structure for LSP
Rfx.Change.Set.convert(changeset, :to_pr)        #> Returns a pull-request data structure
```

Rfx also provides a function that applies the change requests to the filesystem.

```elixir
Rfx.Change.Set.apply!(changeset)                 #> Applies the changereqs to the filesystem
```

## Code Organization

Each operation is coded in a standalone module that implements the `Rfx.Ops`
behavior.  A refactoring operation may be applied to different scopes:

- Scope1: a code string
- Scope2: a single file
- Scope3: an entire project
- Scope4: an umbrella sub-application
- Scope5: a temp file

Each scope will generate a different set of change requests.  Consider for
example the operation `Rfx.Ops.Module.RenameModule`.

| Rename_Module    | # of Change Requests            | Text Edits      | File Actions           |
|------------------|---------------------------------|-----------------|------------------------|
| Scope1 `code`    | 1                               | Edit src & docs | NA                     |
| Scope2 `file`    | 1                               | Edit src & docs | Rename Src file        |
| Scope3 `project` | 1 for each related project file | Edit src & docs | Rename Src & Test file |
| Scope4 `subapp`  | 1 for each related subapp file  | Edit src & docs | Rename Src & Test file |
| Scope5 `tmpfile` | 1                               | Edit src & docs | NA                     |

Here's a code example:

```elixir
#!/usr/bin/env elixir

Mix.install([ {:rfx, github: "andyl/rfx"} ])

"x = 1"
|> Rfx.Ops.Proto.CommentAdd.cl_code()
|> Rfx.Change.Set.convert(:to_string)
|> IO.inspect()

# [
#   %Rfx.Change.Request{
#     file_req: nil,
#     text_req: %{diff: "0a1\n> # TestComment\n", input_text: "x = 1"},
#     log: %{convert: %{to_string: "# TestComment\nx = 1"}}
#   }
# ]
```

## Clients 

Rfx Operations are meant to be embedded into editors, tools and end-user
applications:

- Tests, Elixir Scripts and LiveNotebooks
- Generators (eg phx.gen, phx.gen.auth)
- CLI (see the experimental [rfxi](https://github.com/andyl/rfxi))
- Editor Plugins (see the experimental [rfx_nvim](https://github.com/andyl/rfx_nvim))
- Mix tasks 
- ElixirLs
- Credo

## Installation

```elixir
def deps do
  [
    {:rfx, github: "andyl/rfx"}
  ]
end
```

