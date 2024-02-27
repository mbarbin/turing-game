(lang dune 3.14)

(name turing-game)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin")

(source
 (github mbarbin/turing-game))

(documentation "https://mbarbin.github.io/turing-game/")

(package
 (name turing-game)
 (synopsis "A bot that can play a board game called Turing Machine")
 (sites
  (share stdlib)
  (share bopboard)
  (libexec stdbin))
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (command-unix-for-opam
   (>= 0.0.2))
  (core
   (and
    (>= v0.16)
    (< v0.17)))
  (expect_test_helpers_core
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (nonempty-list
   (and
    (>= v0.16)
    (< v0.17)))
  (patdiff
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_compare
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_enumerate
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_expect
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_fields_conv
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_hash
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_here
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_let
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_conv
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_value
   (and
    (>= v0.16)
    (< v0.17)))
  (reversed-list
   (and
    (>= v0.16)
    (< v0.17)))
  (stdio
   (and
    (>= v0.16)
    (< v0.17)))))
