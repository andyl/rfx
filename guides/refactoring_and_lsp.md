# Refactoring and LSP

ElixirLS doesn't currently have internal data structures for refactoring.
ElixirLS is not yet integrated with Rfx - integration design work has barely
started.  Here are some notes to get us going...

The Language Server Protocol specification does include data structures for
refactoring - here are some of the most relevant.

Two top-level structures that group related changes together: 

- [WorkspaceEdit](https://microsoft.github.io/language-server-protocol/specifications/specification-current/#workspaceEdit)
- [TexDocumentEdit](https://microsoft.github.io/language-server-protocol/specifications//specification-3-17/#textDocumentEdit)

Once we get down to TextEdit we're finally specifying the actual text to insert
(and it replaces whatever text was contained in the `Range`, which is
effectively a start line + char, and an end line + char): 

- [TextEdit](https://microsoft.github.io/language-server-protocol/specifications//specification-3-17/#textEdit)
- [Create/Rename/Delete Files](https://microsoft.github.io/language-server-protocol/specifications//specification-3-17/#resourceChanges)

So for ElixirLS's use-case, rather than a "diff", something that resembled a
TextEdit, so a Range (start + end location), along with the text to insert.

