# Rfx : ReFactor Elixir

NOTE at the moment this code does not work!  We're working out the programming
interfaces and project organization.  Once this is done, we'll build out the
refactoring operations step by step.

To get started with this pre-release code, clone the repo, then run `> mix test
--exclude pending`.

---

Rfx provides a catalog of automated refactoring operations for Elixir source
code.  

## Ops Modules

Project Operations:

- [ ] add dependency (`Rfx.Ops.Project.DepsAdd`)
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

PhxGen Operations:

- [ ] add route
- [ ] add controller

PhxGenAuth Operations:

- [ ] add controller

Credo Operations:

- [ ] multi-alias (`Rfx.Ops.Credo.MultiAlias`)

Rfx Operations depend on the excellent
[Sourceror](http://github.com/doorgan/sourceror) written by
[@doorgan](http://github.com/doorgan).

Each operation implements the `Rfx.Ops` behavior - see moduledocs for more info.

## Change Lists

Each operation returns a *change list* (`Rfx.Change.List`) with a set of of
*change requests* (`Rfx.Change.Req`).  The *change list* is a data structure that
describes all the refactoring changes to be made for an operation.

A *change request* struct has elements for *content edits* and *filesystem
actions* (create, rename, delete).

Rfx provides helper functions to manipulate changelists:

```elixir
Rfx.Change.List.to_string(changelist) #> Returns the modified source code
Rfx.Change.List.to_json(changelist)   #> Returns a JSON data structure
Rfx.Change.List.to_patch(changelist)  #> Returns a unix-standard patchfile
Rfx.Change.List.to_lsp(changelist)    #> Returns a data structure for LSP
Rfx.Change.List.to_pr(changelist)     #> Returns a pull-request data structure
Rfx.Change.List.apply!(changelist)    #> Applies the changereqs to the filesystem
```

## Code Organization

Rfx provides an extensible catalog of refactoring operations.  Each operation
is coded in a separate module.  A given refactoring operation may be applied to
different scopes:

- Scope1: a chunk of code
- Scope2: a single file
- Scope3: an entire project
- Scope4: an umbrella sub-application

Each scope will generate a different set of change requests.  Consider for
example the operation `Rfx.Ops.Module.RenameModule`.

| Rename_Module    | # of Change-Reqs                   | Content Edits     | Filesys Actions          |
|------------------|------------------------------------|-------------------|--------------------------|
| Scope1 `code`    | 1                                  | Edit src and docs | NA                       |
| Scope2 `file`    | 1                                  | Edit src and docs | Rename Src file          |
| Scope3 `project` | 1 for each related file in project | Edit src and docs | Rename Src and Test file |
| Scope4 `subapp`  | 1 for each related file in subapp  | Edit src and docs | Rename Src and Test file |

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

# return a json string
RenameModule.cl_subapp(subapp_dir, old_module: "OldModule", new_module: "NewModule") 
|> Change.List.to_json()
#> {:ok, list of json_strings}
```

## Clients 

Rfx Operations are meant to be embedded into editors, tools and end-user
applications:

- Tests, Elixir Scripts and LiveNotebooks
- Mix tasks (see the experimental [rfx_tasks](https://github.andyl/rfx_tasks))
- CLI (see the experimental [rfx_cli](https://github.com/andyl/rfx_cli))
- Generators (eg phx.gen, phx.gen.auth)
- Editor Plugins
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

