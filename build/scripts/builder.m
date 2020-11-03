(* ::Package:: *)

dropDirectory[root_] := (
	DeleteDirectory[root, DeleteContents->True];
	CreateDirectory[root, CreateIntermediateDirectories->True];
)
