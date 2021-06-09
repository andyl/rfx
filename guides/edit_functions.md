# Writing Edit Functions

## Background

The core of an Rfx Operation is an edit function:
- transform a block of source code into an AST-with-comments
- modify the AST-with-comments according to the RFX Operation rules
- transform the modified AST-with-comments back to source code

Enabling Tooling:

- [Sourceror](https://hexdocs.pm/sourceror/Sourceror.html#content)
- [Code.string_to_quoted_with_comments/2](https://hexdocs.pm/elixir/master/Code.html#string_to_quoted_with_comments/2)
- [Code.quoted_to_algebra/](https://hexdocs.pm/elixir/master/Code.html#quoted_to_algebra/2)
- [Inspect.Algebra](https://hexdocs.pm/elixir/1.12/Inspect.Algebra.html)


