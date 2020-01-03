(* ::Package:: *)

Package["ultima`"]
PackageScope["common"]


PackageExport["vector"]
PackageExport["norm"]

vector[common`v_] := common`v[[All, 1]];
norm  [common`v_] := Sqrt[Sum[p^2, {p, common`v}]];


PackageExport["printm"]
PackageExport["printp"]
PackageExport["scalep"]

printm[common`v_] := (
	Print [common`v // MatrixForm];
	Return[common`v];
)

printp[common`pp_ ] := (
	Print[#]& /@ common`pp
)

scalep[common`p_, common`ratio_:1] := (
	common`range = First /@ Differences /@ (PlotRange /. Options[common`p]);
	Show[common`p
		, AspectRatio->(Last[common`range]/First[common`range]/common`ratio)
	]
)


PackageExport["addModule"]

addModule[common`path_] := NotebookEvaluate[
	  NotebookDirectory[] <> common`path
	, InsertResults->True
];
