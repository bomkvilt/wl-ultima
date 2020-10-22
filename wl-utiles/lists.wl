(* ::Package:: *)

Package["ultima`"]; PackageScope["lists"]


PackageExport["flatJoin"]
flatJoin[args__] := Flatten[{#}& /@ seq2list[args]]


PackageExport["toRules"]
toRules[list_:MatrixQ] := Module[{data = seq2list[list], n, m},
	{n, m} = Dimensions[data]; 
	Assert[m >= 2];
	
	data = MapIndexed[data[[First@#2, 1]] -> #1&, data[[All, 2;;]], {2}];
	data = Transpose [data];
	If [m == 2, data = First @ data; ];
	Return[data];
]


PackageExport["apply"]
apply[l_, r_:{}] := l // map[If [#[[0]] === Rule
	, #[[0]][ #[[1]], #[[2]] //. r ]
	, # //. r
]&]

apply[l_, r_, e__] := apply[l, seq2list[r, e]]


PackageExport["ruleCast"]
SetAttributes[ruleCast, HoldAll];
ruleCast[l_, rule_:Rule] := Module[{val = \!\(\*
TagBox[GridBox[{
{"\[Piecewise]", GridBox[{
{
RowBox[{"Hold", "[", "l", "]"}], 
RowBox[{
RowBox[{"l", "[", 
RowBox[{"[", "0", "]"}], "]"}], " ", "=!=", " ", "Hold"}]},
{"l", "True"}
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
StripWrapperBoxes->True]\), conv}, 
	conv[lvl_] := Replace[val, a_[b_, c_] -> rule[b, c], {lvl}, Heads->True];
	Switch[ val[[1,0]]
	, List      , conv[2] [[1]]
	, Piecewise , conv[3] [[1,1]]
	, _, If [MatchQ[val, Hold[a_[b_, c_]]]
		, conv[0] [[1]]
		, Message[ruleCast::badcast, l[[0]]]; Abort[];
	]]
]
ruleCast::badcast = "cannot cast `1` to rules";


PackageExport["pw2Rules"]
pw2Rules[pw_, rule_:Rule] := Replace[pw[[1]], List -> rule, {2}, Heads->True]
