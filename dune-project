(lang dune 3.20)
(name dwarf_evaluator)

(source (github intel/dwarf-evaluator))
(license MIT)
(authors "Tankut Baris Aktemur <tankut.baris.aktemur@intel.com>")
(maintainers "Tankut Baris Aktemur <tankut.baris.aktemur@intel.com>")
(generate_opam_files true)

(package
  (name dwarf_evaluator)
  (synopsis "A DWARF expression evaluator")
  (depends
    (ocaml (>= 4.13))
    (sexplib (>= 0.17))
    (ppx_sexp_conv (>= 0.17.1))
    (ppx_import (>= 1.11.0))
    (js_of_ocaml (>= 6.2.0))
    (js_of_ocaml-ppx (>= 6.2.0))))
