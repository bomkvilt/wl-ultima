(* ::Package:: *)

Package["ultima`"]
PackageScope["common"]


PackageExport["vector"]
PackageExport["norm"]

vector[common`v_] := common`v[[All, 1]];
norm  [common`v_] := Sqrt[Sum[p^2, {p, common`v}]];


PackageExport["block"]
PackageExport["printm"]
PackageExport["printt"]
PackageExport["printp"]

block[c_] := (
	Print[Row @ {">> ", c, ":"}];
)

printm[v_] := (
	Print [v // MatrixForm];
	Return[v];
)

printt[v_] := (
	Print [TableForm[v, TableSpacing->{0, 3}]];
	Return[v];
)

printp[pp_ ] := (
	Print[#]& /@ pp
)


PackageExport["stopIntegration"]

HoldAll[stopIntegration];
stopIntegration[event_, action_] := Method -> {
	"EventLocator"
	, "Event" :> event
	, "EventAction" :> Throw[action[], "StopIntegration"]
}


PackageExport["addModule"]

addModule[path_] := NotebookEvaluate[
	  NotebookDirectory[] <> path
	, InsertResults->True
];
