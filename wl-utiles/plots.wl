(* ::Package:: *)

Package["ultima`"]; PackageScope["plots"]


PackageExport["gridLineStepEq"]
gridLineStepEq[step_] := Function[{min, max}, 
	Range[
		  Ceiling[min, step]
		, Floor  [max, step]
		, step
	]
]

gridLineStepEq[x_, y_] := {gridLineStepEq[x], gridLineStepEq[y]}


PackageExport["rasterize"]
rasterize[args___] := Function[{p},
	Rasterize[p, args]
]


PackageExport["getPlotRange"]
getPlotRange[plot:(_Graphics|_Graphics3D|_Graph)] := Last@Last@Reap[
	Rasterize[Show[plot
		, Axes -> True
		, Frame -> False
		, Ticks -> ((Sow[{##}]; Automatic) &)
		, DisplayFunction -> Identity
		, ImageSize -> 0
	]
		, ImageResolution -> 1
	]
]


PackageExport["scalep"]
scalep[p:(_Graphics|_Graphics3D|_Graph), ratio_:1] := (
	range = getPlotRange[p];
	Show[p, AspectRatio->(Last[range]/First[range]/ratio)]
)
