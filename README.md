# Rfx : ReFactor Elixir

Rfx provides a catalog of automated refactoring operations for Elixir source
code.  

**NOTE** at the moment this code does not work!  We're sorting out the
programming interfaces and project organization.  Once this is done, we'll
build the refactoring operations step by step.

To get started with this pre-release code, clone the repo, then run `> mix test
--exclude pending`.

## Ops Modules

Project Operations:

- [ ] add dependency 
- [ ] increment version

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

PhxGen Operations:

- [ ] add route
- [ ] add controller

PhxGenAuth Operations:

- [ ] add controller

Credo Operations:

- [x] multi-alias (`Rfx.Ops.Credo.MultiAlias`)

Prototype Operations:

- [x] comment add (`Rfx.Ops.Proto.CommentAdd`)
- [x] comment del (`Rfx.Ops.Proto.CommentDel`)
- [x] no-op (`Rfx.Ops.Proto.NoOp`)

Rfx Operations depend on the excellent
[Sourceror](http://github.com/doorgan/sourceror) written by
[@doorgan](http://github.com/doorgan).

## Change Lists

Each operation returns a *change list* (`Rfx.Change.List`) with a set of of
*change requests* (`Rfx.Change.Req`).  The *change list* is a data structure that
describes all the refactoring changes to be made for an operation.

A *change request* struct has elements for *text edits* and *file actions*
(create, rename, delete).

Rfx provides helper functions to manipulate changelists:

```elixir
Rfx.Change.List.to_string(changelist) #> Returns the modified source code
Rfx.Change.List.to_patch(changelist)  #> Returns a unix-standard patchfile
Rfx.Change.List.to_lsp(changelist)    #> Returns a data structure for LSP
Rfx.Change.List.to_pr(changelist)     #> Returns a pull-request data structure
Rfx.Change.List.apply!(changelist)    #> Applies the changereqs to the filesystem
```

## Code Organization

Each operation is coded in a standalone module that implements the `Rfx.Ops`
behavior.  A refactoring operation may be applied to different scopes:

- Scope1: a chunk of code
- Scope2: a single file
- Scope3: an entire project
- Scope4: an umbrella sub-application

Each scope will generate a different set of change requests.  Consider for
example the operation `Rfx.Ops.Module.RenameModule`.

| Rename_Module    | # of Change-Reqs                | Text Edits      | File Actions           |
|------------------|---------------------------------|-----------------|------------------------|
| Scope1 `code`    | 1                               | Edit src & docs | NA                     |
| Scope2 `file`    | 1                               | Edit src & docs | Rename Src file        |
| Scope3 `project` | 1 for each related project file | Edit src & docs | Rename Src & Test file |
| Scope4 `subapp`  | 1 for each related subapp file  | Edit src & docs | Rename Src & Test file |

Here's a pseudo-code example:

```elixir
alias Rfx.Ops.Module.RenameModule
alias Rfx.Change

# return edited source code
RenameModule.cl_code(input_code) 
| > Change.List.to_string()
#> {:ok, edited_source_code_string}

# write changes to file system
RenameModule.cl_file(input_file_name, new_name: "MyNewName") 
|> Change.List.apply!()
#> :ok  

# return a unix patchfile string
RenameModule.cl_project(project_dir, old_module: "OldModule", new_module: "NewModule") 
|> Change.List.to_patch()
#> {:ok, list of patchfile_strings}
```

## Clients 

Rfx Operations are meant to be embedded into editors, tools and end-user
applications:

- Tests, Elixir Scripts and LiveNotebooks
- Generators (eg phx.gen, phx.gen.auth)
- Mix tasks (see the experimental [rfx_tasks](https://github.andyl/rfx_tasks))
- CLI (see the experimental [rfx_cli](https://github.com/andyl/rfx_cli))
- Editor Plugins (see the experimental [rfx_nvim](https://github.com/andyl/rfx_nvim))
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

