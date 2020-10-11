(* ::Package:: *)

Package["ultima`"]; PackageScope["basics"]


PackageExport["seq2list"]
SetAttributes[seq2list, HoldAll];
seq2list[v___] := Flatten[{v}, 1]


PackageExport["args2seq"]
SetAttributes[args2seq, HoldAll];
args2seq[v_] := Replace[ v, v[[0]] -> Sequence, {1}, Heads->True ]


PackageExport["addModule"]
addModule[path_] := NotebookEvaluate[
	  NotebookDirectory[] <> path
	, InsertResults->True
];
