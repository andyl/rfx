# Rfx : ReFactor Elixir

```markdown
NOTE at the moment this code does not work!  We're
working out the programming interfaces and project
organization.  Once this is done, we'll build out
the refactoring operations step by step.
```

Rfx provides a catalog of automated refactoring operations for Elixir source
code.  

## Operations

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

## Changelists

Each operation returns a *changelist* (`Rfx.Changelist`) with a set of of
*change requests* (`Rfx.Changereq`).  The *changelist* is a data structure that
describes all the refactoring changes to be made for an operation.

A *change request* struct has elements for *content edits* and *filesystem
actions* (create, rename, delete).

Rfx provides helper functions to manipulate changelists:

```elixir
Rfx.Changelist.to_string(changelist) #> Returns the modified source code
Rfx.Changelist.to_json(changelist)   #> Returns a JSON data structure
Rfx.Changelist.to_patch(changelist)  #> Returns a unix-standard patchfile
Rfx.Changelist.to_lsp(changelist)    #> Returns a data structure for LSP
Rfx.Changelist.apply!(changelist)    #> Applies the changereqs to the filesystem
```

## Clients 

Rfx Operations are meant to be embedded into editors, tools and end-user
applications:

- Tests, Elixir Scripts and LiveNotebooks
- Mix tasks (see the experimental [cl_tasks](https://github.andyl/cl_tasks))
- CLI (see the experimental [cl_cli](https://github.com/andyl/cl_cli))
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

## Code Organization

We desire to have an extensible catalog of refactoring operations.  Each
operation is coded in a separate module that implements the `Rfx.Ops`
behavior.

A given refactoring operation may be applied to different scopes:

- Scope1: a chunk of code
- Scope2: a single file
- Scope3: an entire project
- Scope4: an umbrella sub-application

Each scope will generate a different set of change requests.  Consider for
example the operation `Rfx.Ops.Module.RenameModule`.

| Rename_Module    | # of Changereqs                    | Content Edits     | Filesys Actions          |
|------------------|------------------------------------|-------------------|--------------------------|
| Scope1 `code`    | 1                                  | Edit src and docs | NA                       |
| Scope2 `file`    | 1                                  | Edit src and docs | Rename Src file          |
| Scope3 `project` | 1 for each related file in project | Edit src and docs | Rename Src and Test file |
| Scope4 `subapp`  | 1 for each related file in subapp  | Edit src and docs | Rename Src and Test file |

Each Rfx operation implements the `Rfx.Ops` behavior:

```elixir
@doc """
Returns a changelist for a block of source code, according to the Operation rules.
"""
@callback cl_code(input_source_code) :: {:ok, changelist} | {:error, String.t}

@doc """
Returns a changelist for a single file,  with directives for edited source
code, and with directives to rename the file according to the Operation rules.
"""
@callback cl_file(input_file_name, args) :: {:ok, changelist} | {:error, String.t}

@doc """
Returns a changelist with directives to update all relevant files within an
entire project, according to the Operation rules.
"""
@callback cl_project(input_project_dir, args) :: {:ok, changelist} | {:error, String.t}

@doc """
Only works within Umbrella applications.  Returns a changelist with directives
to update all relevant files within a subapp, according to the Operation rules.
"""
@callback cl_subapp(input_subapp_dir, args) :: {:ok, changelist} | {:error, String.t}
```

Here's a pseudo-code example:

```elixir
alias Rfx.Ops.Module.RenameModule
alias Rfx.Changelist

# return edited source code
RenameModule.cl_code(input_code) 
| > Changelist.to_string()
#> {:ok, edited_source_code_string}

# write changes to file system
RenameModule.cl_file(input_file_name, new_name: "MyNewName") 
|> Changelist.apply!()
#> :ok  

# return a unix patchfile string
RenameModule.cl_project(project_dir, old_module: "OldModule", new_module: "NewModule") 
|> Changelist.to_patch()
#> {:ok, list of patchfile_strings}

# return a json string
RenameModule.cl_subapp(subapp_dir, old_module: "OldModule", new_module: "NewModule") 
|> Changelist.to_json()
#> {:ok, list of json_strings}
```

