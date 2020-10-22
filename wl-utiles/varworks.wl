(* ::Package:: *)

Package["ultima`"]; PackageScope["varworks"]


PackageExport["newVars"]
newVars[vars___] := Return @ varworkWrap[Function[{vals}, 
	apply[{} // plypend[ruleCast[vals, Rule]], vars]
]]


PackageExport["joinNewVars"]
joinNewVars[var_, vars___] := Return @ varworkWrap[Function[{vals}, 
	apply[var // plypend[newVars[] @ vals], vars]
]]


PackageExport["pushNewVars"]
SetAttributes[pushNewVars, HoldAll];
pushNewVars[var_, vars___] := Return @ varworkWrap[Function[{vals}, 
	var = joinNewVars[var, vars] @ vals
]]


PackageExport["varworkWrap"]
PackageExport["varworkWraper"]
varworkWrap[clb_] := Return @ Function[{vals}, 
	Module[{args = \!\(\*
TagBox[GridBox[{
{"\[Piecewise]", GridBox[{
{
RowBox[{"Hold", "[", "vals", "]"}], 
RowBox[{
RowBox[{"vals", "[", 
RowBox[{"[", "0", "]"}], "]"}], " ", "=!=", " ", "Hold"}]},
{"vals", "True"}
},
AllowedDimensions->{2, Automatic},
Editable->True,
GridBoxAlignment->{"Columns" -> {{Left}}, "ColumnsIndexed" -> {}, "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
GridBoxItemSize->{"Columns" -> {{Automatic}}, "ColumnsIndexed" -> {}, "Rows" -> {{1.}}, "RowsIndexed" -> {}},
GridBoxSpacings->{"Columns" -> {Offset[0.27999999999999997`], {Offset[0.84]}, Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {Offset[0.2], {Offset[0.4]}, Offset[0.2]}, "RowsIndexed" -> {}},
Selectable->True]}
},
GridBoxAlignment->{"Columns" -> {{Left}}, "ColumnsIndexed" -> {}, "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
GridBoxItemSize->{"Columns" -> {{Automatic}}, "ColumnsIndexed" -> {}, "Rows" -> {{1.}}, "RowsIndexed" -> {}},
GridBoxSpacings->{"Columns" -> {Offset[0.27999999999999997`], {Offset[0.35]}, Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {Offset[0.2], {Offset[0.4]}, Offset[0.2]}, "RowsIndexed" -> {}}],
"Piecewise",
DeleteWithContents->True,
Editable->False,
SelectWithContents->True,
Selectable->False,
StripWrapperBoxes->True]\)},
		If [args[[1,0]] === Symbol
		, varworkWraper[args, clb]
		, clb[args]
		]
	]
	, HoldAll
]

Protect[varworkWraper];

PackageExport["varworkWraperQ"]
varworkWraperQ[a_] := a[[0]] === varworkWraper

Unprotect[Rule];
Rule[a_?varworkWraperQ, b_] := a[[2]][ a[[1]] -> b ]
Protect[Rule];



