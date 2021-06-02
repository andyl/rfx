# Introduction to Refactoring

Code Refactoring is a well-established topic within computer science.
Refactoring tools have shown their value in IDEs like Eclipse and Intellij
Idea.

We hope that Rfx will help to bring refactoring capabilitity to popular text
editors in the Elixir community (eg VsCode, Vim, Emacs).

Beyond that, it will be interesting to see if a general purpose refactoring
library can help to spark the developement of novel applications: analytic
tools, bots, machine-learning aids, generators, etc.

## About Refactoring

[From Wikipedia](https://en.wikipedia.org/wiki/Code_refactoring): In computer
programming and software design, code refactoring is the process of
restructuring existing computer code, changing the factoring, without changing
its external behavior. Refactoring is intended to improve the design,
structure, and/or implementation of the software (its non-functional
attributes), while preserving its functionality. Potential advantages of
refactoring may include improved code readability and reduced complexity; these
can improve the source code's maintainability and create a simpler, cleaner, or
more expressive internal architecture or object model to improve extensibility.
Another potential goal for refactoring is improved performance; software
engineers face an ongoing challenge to write programs that perform faster or
use less memory.

> By continuously improving the design of code, we make it easier and easier to
> work with. This is in sharp contrast to what typically happens: little
> refactoring and a great deal of attention paid to expediently adding new
> features. If you get into the hygienic habit of refactoring continuously,
> you'll find that it is easier to extend and maintain code.
> 
> — Joshua Kerievsky, Refactoring to Patterns

## Learning Resources

There are thousands of learning resources on code refactoring.  Here's a
few to get you started:

Talks: 

- [Refactoring by Georgia Tech](https://www.youtube.com/watch?v=LsLniadcRTw)
- [What is Refactoring?](https://www.youtube.com/watch?v=DQJGRV9np40)
- [Refactoring Legacy Code](https://www.youtube.com/watch?v=p-oWHEfXEVs)

Articles:

- [Wikipedia Code Refactoring](https://en.wikipedia.org/wiki/Code_refactoring)
- [Code Refactoring Best Practices](https://www.altexsoft.com/blog/engineering/code-refactoring-best-practices-when-and-when-not-to-do-it/)
- [Refactoring Guru](https://refactoring.guru/refactoring)

Books:

- [Metaprogramming Elixir by McCord](https://pragprog.com/titles/cmelixir/metaprogramming-elixir/)
- [Refactoring by Fowler and Beck](https://martinfowler.com/books/refactoring.html)
- [Clean Code by Martin](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)

## Elixir Tooling

Rfx builds on a foundation of prior work by the Elixir community:

- [Elixir Macros and Metaprogramming][macros] - Any elixir code you write can
  be represented as a tree of expressions, called an Abstract Syntax Tree
  (AST).  Elixir is able to convert code to AST and vice-versa.  Elixir Macros
  and Metaprogramming give superpowers to extend the language.
- [AST Ninja][astn] - AST Ninja is a handy online tool to easily convert Elixir
  code to AST.
- [Refactoring Problems][as_talk] - In his [2019 talk][as_talk]
  ([slides][as_slides]), [Arjan Scherpenisse][asgh] gives an excellent AST
  tutorial, and identifies roadblocks to implement Refactoring.  Key problem:
  the standard Elixir AST does not capture comments.
- [Sourceror][sourceror] - As of Elixir 1.13 (and backported to Elixir 1.10),
  [Dorgan][dorgangh] made critical contributions to enable Refactoring.  The
  first is new functions for the Elixir standard library:
  `Code.string_to_quoted_with_comments/2` [</>][stqwc] and
  `Code.quoted_to_algebra/2` [</>][qta].  These allow generation of an AST which
  preserves comments.  The second is a new library [Sourceror][sourceror] which
  provides tooling to readily manipulate the AST-with-comments.  

[macros]: https://www.google.com/search?q=elixir+macros+metaprogramming&oq=elixir+macros+metaprogramming&aqs=chrome.0.69i59j69i64j69i60.6516j0j1&sourceid=chrome&ie=UTF-8
[astn]: http://ast.ninja
[asgh]: https://github.com/arjan 
[as_talk]: https://www.youtube.com/watch?v=aM0BLWgr0g4&t=117s
[as_slides]: https://docs.google.com/presentation/d/15_xKuL_H4Eu-EkGarxVixCk192858avE1ef1gmcVKoc/edit#slide=id.g552f9bdc39_0_0
[sourceror]: https://github.com/doorgan/sourceror
[dorgangh]: https://github.com/doorgan
[stqwc]: https://hexdocs.pm/elixir/master/Code.html#quoted_to_algebra/2
[qta]: https://hexdocs.pm/elixir/master/Code.html#string_to_quoted_with_comments/2

## Other Languages

Here are some comparable refactoring libraries written for other languages:

- Python: [python-rope](https://github.com/python-rope/rope)
- Javascript: [grasp](https://graspjs.com)
- Rust: [Structural Search and Replace](https://rust-analyzer.github.io/manual.html#structural-search-and-replace)
- Rust: [ReRast](https://github.com/google/rerast)

