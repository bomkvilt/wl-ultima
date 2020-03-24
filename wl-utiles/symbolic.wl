(* ::Package:: *)

Package["ultima`"]


PackageExport["sym"]
PackageExport["unsym"]

SetAttributes[sym, HoldAll];
sym[args__] := Defer[args]

SetAttributes[unsym, HoldAll];
unsym[args__] := (args) /. Defer->Identity
