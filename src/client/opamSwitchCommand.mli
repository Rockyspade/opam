(**************************************************************************)
(*                                                                        *)
(*    Copyright 2012-2015 OCamlPro                                        *)
(*    Copyright 2012 INRIA                                                *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

(** Functions handling the "opam switch" subcommand *)

open OpamTypes
open OpamStateTypes

(** Install a new switch, with the given packages set as compiler. The given
    [global_state] is unlocked as soon as possible, i.e. after registering the
    existence of the new switch *)
val install:
  rw global_state -> update_config:bool ->
  packages:atom conjunction -> switch ->
  unlocked global_state * rw switch_state

(** Install a compiler's base packages *)
val install_compiler_packages:
  rw switch_state -> atom conjunction -> rw switch_state

(** Import a file which contains the packages to install.  *)
val import:
  rw switch_state ->
  OpamFile.SwitchExport.t OpamFile.t option ->
  rw switch_state

(** Export a file which contains the installed packages. If full is specified
    and true, export metadata of all installed packages (excluding overlay
    files) as part of the export. [None] means export to stdout. *)
val export: ?full:bool -> OpamFile.SwitchExport.t OpamFile.t option -> unit

(** Remove the given compiler switch, and returns the updated state (unchanged
    in case [confirm] is [true] and the user didn't confirm) *)
val remove: rw global_state -> ?confirm:bool -> switch -> rw global_state

(** Changes the currently active switch *)
val switch: 'a lock -> rw global_state -> switch -> 'a switch_state

(** Switch to the given compiler switch, installing it if it doesn't exist
    already (with the given compiler, or empty if unspecified). *)
val switch_with_autoinstall:
  rw global_state -> packages:atom conjunction -> switch ->
  unlocked global_state * rw switch_state

(** Reinstall the given compiler switch. *)
val reinstall: rw switch_state -> rw switch_state

(** Display the current compiler switch. *)
val show: unit -> unit

(** List all the available compiler switches. *)
val list:
  'a global_state -> print_short:bool -> installed:bool -> all:bool -> unit

(* Guess the compiler from the switch name: within compiler packages,
   match [name] against "pkg.version", "pkg", and, as a last resort,
   "version" (for compat with older opams, eg. 'opam switch 4.02.3') *)
val guess_compiler_package:
  'a repos_state -> string -> atom list
