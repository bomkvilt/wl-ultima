(* ::Package:: *)

Package["ultima`"]
PackageScope["common"]


PackageExport["vector"]
PackageExport["norm"]

vector[common`v_] := FullSimplify[v][[All, 1]];
norm  [common`v_] := Sqrt[Sum[p^2, {p, v}]];


PackageExport["printm"]
PackageExport["printp"]
PackageExport["print" ]
PackageExport["pscale"]

printm[common`t_, common`m_] := CellPrint[{
  Row[{TextCell["\t"  ], TextCell[common`t], TextCell[":"]}],
  Row[{TextCell["\t\t"], MatrixForm[common`m]}]
}];

printp[common`pp_ ] := CellPrint[
	Print[#]& /@ common`pp
];

print[common`v_] := (
	Print [common`v // MatrixForm];
	Return[common`v];
)

pscale[common`p_, common`ratio_:1] := (
	range = First /@ Differences /@ (PlotRange /. Options[common`p]);
	Show[common`p, AspectRatio->(Last[range]/First[range]/common`ratio)]
)


PackageExport["addModule"]

addModule[common`path_] := NotebookEvaluate[
	  NotebookDirectory[] <> common`path
	, InsertResults->True
];
