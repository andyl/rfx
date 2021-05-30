# Rfx : ReFactor Elixir

```markdown
NOTE at the moment this code does not work!  Right now we're working out the
programming interfaces and project organization.  Once this is done, we'll
build out the refactoring operations step by step.
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

## Clients 

Rfx Operations are meant to be embedded into editors, tools and end-user
applications:

- Examples and Tests
- Elixir Scripts and LiveNotebooks
- Mix tasks
- CLI (rfx)
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

We desire to have an extensible catalog of refactoring operations.  It seems
like having a separate module for refactoring operation would work well.

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
Transforms a block of source code, according to the Operation rules.
"""
@callback rfx_code(input_source_code) :: {:ok, output_source_code} | {:error, String.t}

@doc """
Updates a single file with transformed source code, and renames the file
according to the Operation rules.
"""
@callback rfx_file!(input_file_name, args) :: {:ok, output_file_name} | {:error, String.t}

@doc """
Updates all relevant files within an entire project, according to the Operation
rules.
"""
@callback rfx_project!(input_project_dir, args) :: {:ok, output_project_dir, [updated_file_list]} | {:error, String.t}

@doc """
Only works within Umbrella applications.  Updates all relevant files within a
subapp, according to the Operation rules.
"""
@callback rfx_subapp!(input_subapp_dir, args) :: {:ok, output_subapp_dir, [updated_file_list]} | {:error, String.t}
```

Here's a pseudo-code example using this behavior:

```elixir
alias Rfx.Ops.Module.RenameModule

RenameModule.rfx_code(input_code) 
#> {:ok, output_code}

RenameModule.rfx_file!(input_file_name, new_name: "MyNewName") 
#> {:ok, output_file_name}

RenameModule.rfx_project!(project_dir_name, old_module_name: "OldModule", new_module_name: "NewModule") 
#> {:ok, project_dir_name, [list_of_updated_files]}

RenameModule.rfx_subapp!(subapp_dir_name, old_module_name: "OldModule", new_module_name: "NewModule") 
#> {:ok, subapp_dir_name, [list_of_updated_files]}
```

