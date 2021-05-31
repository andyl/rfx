# Rfx : ReFactor Elixir

```markdown
NOTE at the moment this code does not work!  We're working out the programming
interfaces and project organization.  Once this is done, we'll build out the
refactoring operations step by step.
```

Rfx provides a catalog of automated refactoring operations for Elixir source
code.  

## Operations

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

- [ ] add route
- [ ] add controller

PhxGenAuth Operations:

- [ ] add controller

Credo Operations:

- [ ] multi-alias

Rfx Operations depend on the excellent
[Sourceror](http://github.com/doorgan/sourceror) written by
[@doorgan](http://github.com/doorgan).

## Alterspecs

Each operation returns an `alterspec`, a data structure that represents the
refactoring changes to be made for an operation.

Rfx provies helper functions to manipulate alterspecs:

```elixir
Rfx.Alterspec.to_json(alterspec)   #> Returns a JSON data structure
Rfx.Alterspec.to_patch(alterspec)  #> Returns a unix-standard patchfile
Rfx.Alterspec.to_string(alterspec) #> Returns the modified source code
Rfx.Alterspec.apply!(alterspec)    #> Applies the alterations to the filesystem
```

## Clients 

Rfx Operations are meant to be embedded into editors, tools and end-user
applications:

- Examples and Tests
- Elixir Scripts and LiveNotebooks
- Mix tasks
- CLI (eg the experimental [rfx_cli](https://github.com/andyl/rfx_cli))
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

We desire to have an extensible catalog of refactoring operations.  The code
for each operation is organized into a separate module.

We expect that a given refactoring operation may be applied to different
scopes:

- Scope1: a chunk of code
- Scope2: a single file
- Scope3: an entire project
- Scope4: an umbrella sub-application

Each scope will require different actions.  Consider for example the operation
`Rfx.Ops.Module.RenameModule`.

Within Scope1, the `RenameModule` operation would change the name of the
module, and also change any `alias` references to the module name, and emit the
updated source code as a return value.

Within Scope2, the `RenameModule` operation would first apply, Scope1, then
write the Scope1 results to the target file, then rename the target file.

Within Scope3 and 4, the `RenameModule` operation would first apply Scope2,
then update update all module references across the entire project, then rename
the relevant test files to match the new module name. 

We speculate that each operation can implement a standard behavior with four
callbacks:

```elixir
@doc """
Returns an alterspec for a block of source code, according to the Operation rules.
"""
@callback rfx_code(input_source_code) :: {:ok, alterspec} | {:error, String.t}

@doc """
Returns an alterspec for a single file,  with directives for transformed source
code, and with directives to rename the file according to the Operation rules.
"""
@callback rfx_file(input_file_name, args) :: {:ok, alterspec} | {:error, String.t}

@doc """
Returns an alterspec with directives to update all relevant files within an
entire project, according to the Operation rules.
"""
@callback rfx_project(input_project_dir, args) :: {:ok, alterspec} | {:error, String.t}

@doc """
Only works within Umbrella applications.  Returns an alterspec with directives
to update all relevant files within a subapp, according to the Operation rules.
"""
@callback rfx_subapp(input_subapp_dir, args) :: {:ok, alterspec} | {:error, String.t}
```

Here's a pseudo-code example using this behavior:

```elixir
alias Rfx.Ops.Module.RenameModule
alias Rfx.Alterspec

# return altered source code
RenameModule.rfx_code(input_code) 
|> Alterspec.to_string()
#> {:ok, altered_source_code_string}

# write changes to file system
RenameModule.rfx_file(input_file_name, new_name: "MyNewName") 
|> Alterspec.apply!()
#> :ok  

# return a unix patchfile string
RenameModule.rfx_project(project_dir, old_module: "OldModule", new_module: "NewModule") 
|> Alterspec.to_patch()
#> {:ok, patchfile_string}

# return a json string
RenameModule.rfx_subapp(subapp_dir, old_module: "OldModule", new_module: "NewModule") 
|> Alterspec.to_json()
#> {:ok, json_string}
```

