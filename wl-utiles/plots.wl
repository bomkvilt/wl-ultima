(* ::Package:: *)

Package["ultima`"]
PackageScope["plots"]


PackageExport["gridLineStepEq"]

gridLineStepEq[step_] := Function[{min, max}, 
	Range[
		  Ceiling[min, step]
		, Floor  [max, step]
		, step
	]
]


PackageExport["rasterize"]
rasterize[args___] := Function[{p},
	Rasterize[Show[p], args]
]
