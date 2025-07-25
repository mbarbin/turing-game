(lang dune 3.17)

(name turing-game)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/turing-game))

(documentation "https://mbarbin.github.io/turing-game/")

(implicit_transitive_deps false)

(package
 (name turing-game)
 (synopsis "A bot that can play a board game called Turing Machine")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (>= v0.17))
  (cmdlang
   (>= 0.0.9))
  (nonempty-list
   (>= v0.17))
  (patdiff
   (>= v0.17))
  (pp
   (>= 2.0.0))
  (pplumbing
   (>= 0.0.14))
  (ppx_compare
   (>= v0.17))
  (ppx_enumerate
   (>= v0.17))
  (ppx_fields_conv
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (reversed-list
   (>= v0.17))
  (stdio
   (>= v0.17))))

(package
 (name turing-game-tests)
 (synopsis "Tests for turing-game")
 (depends
  (ocaml
   (>= 5.2))
  (ocamlformat
   (and
    :with-dev-setup
    (= 0.27.0)))
  (base
   (>= v0.17))
  (cmdlang
   (>= 0.0.9))
  (expect_test_helpers_core
   (>= v0.17))
  (nonempty-list
   (>= v0.17))
  (patdiff
   (>= v0.17))
  (pp
   (>= 2.0.0))
  (pplumbing
   (>= 0.0.14))
  (ppx_compare
   (>= v0.17))
  (ppx_enumerate
   (>= v0.17))
  (ppx_expect
   (>= v0.17))
  (ppx_fields_conv
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (reversed-list
   (>= v0.17))
  (stdio
   (>= v0.17))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))
