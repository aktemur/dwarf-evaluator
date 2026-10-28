(* Copyright (C) 2025-2026 Advanced Micro Devices, Inc.
   SPDX-License-Identifier: MIT *)

open Sexplib.Std

(* Auto-derived sexp conversions, kept in their own module so we can
   override a couple of them below while still delegating to these for
   everything else (and for all parsing, which stays untouched). *)
module Auto = struct
  (* Re-open relevant types in Dwarf_evaluator to derive sexp functions *)
  type data = [%import: Dwarf_evaluator.data]
  and context_item = [%import: Dwarf_evaluator.context_item]
  and storage = [%import: Dwarf_evaluator.storage]
  and location = [%import: Dwarf_evaluator.location]
  and stack_element = [%import: Dwarf_evaluator.stack_element]
  and dwarf_op = [%import: Dwarf_evaluator.dwarf_op]
  [@@deriving sexp]
end
include Auto

let hex_sexp_of_int n =
  Sexplib.Sexp.Atom (Printf.sprintf "0x%x" n)

(* Only DW_OP_addr's argument is printed in hex; every other int keeps the
   default decimal rendering. *)
let sexp_of_dwarf_op = function
  | DW_OP_addr n ->
     Sexplib.Sexp.List [Sexplib.Sexp.Atom "DW_OP_addr"; hex_sexp_of_int n]
  | op -> Auto.sexp_of_dwarf_op op

(* context_item can embed dwarf_op lists (DW_AT_location, DW_AT_frame_base),
   so it needs to be re-derived against the overridden sexp_of_dwarf_op
   above, rather than Auto's, for DW_OP_addr to render as hex there too. *)
let sexp_of_context_item = function
  | DW_AT_location (name, ops) ->
     Sexplib.Sexp.List [Sexplib.Sexp.Atom "DW_AT_location";
                        sexp_of_string name;
                        sexp_of_list sexp_of_dwarf_op ops]
  | DW_AT_frame_base ops ->
     Sexplib.Sexp.List [Sexplib.Sexp.Atom "DW_AT_frame_base";
                        sexp_of_list sexp_of_dwarf_op ops]
  | item -> Auto.sexp_of_context_item item

(* Add some types not present in Dwarf_evaluator but useful with sexp *)
type context_t = (context_item list) [@@deriving sexp]
type locexpr_t = (dwarf_op list) [@@deriving sexp]
type stack_t = (stack_element list) [@@deriving sexp]
