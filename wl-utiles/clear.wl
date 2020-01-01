(* ::Package:: *)

Package["ultima`"]
PackageScope["clear"]


PackageExport["clear"]

clear[] := Module[{},
	Remove[Evaluate[Context[] <> "*"]];
	ClearSystemCache[];
]
