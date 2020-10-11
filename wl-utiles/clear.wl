(* ::Package:: *)

Package["ultima`"]; PackageScope["clear"]


PackageExport["clear"]
clear[] := Module[{names},
	names = Names[Context[] <> "*"];
	Remove[#]& /@ names // Quiet;
	ClearSystemCache[];
]
