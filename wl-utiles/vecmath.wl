(* ::Package:: *)

Package["ultima`"]; PackageScope["vecmath"]


PackageExport["vec"]
vec[v_List] := Module[{dim = Dimensions[v]},
	If[Length@dim > 1,
		Return @ v[[All, 1]];
	,
		Return @ v;
	]
]
vec[v_, w__] := vec[seq2list[v, w]]


PackageExport["V"]
V[v__] := vec[v]


PackageExport["norm"]
norm[v_List] := Sqrt @ Sum[p^2, {p, v}]


PackageExport["normalize"]
normalize[v_] := Return[v / norm[v]]


PackageExport["vecjoin"]
vecJoin[l_List, r_List, command_:Equal] := Replace[
	{l, r}\[Transpose], List -> command, {2}, Heads->True
];
