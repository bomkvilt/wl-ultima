(* ::Package:: *)

Package["ultima`"]
PackageScope["list"]


PackageExport["seq2list"]

SetAttributes[seq2list, HoldAll];
seq2list[v___] := Flatten[{v}, 1]


PackageExport["ForEach"]

SetAttributes[ForEach, HoldAll];
ForEach[list`patt_/; FreeQ[list`patt, Pattern], list`list_, list`expr_, list`level_:1] :=  Module[{
	  pattWithBlanks
	, pattern
},
	pattWithBlanks = list`patt /. (x_Symbol/;!MemberQ[{"System`"},Context[x]] :> pattern[x,Blank[]]);
	pattWithBlanks = pattWithBlanks /. pattern->Pattern;
	Cases[Unevaluated@list`list, pattWithBlanks :> list`expr, {list`level}];
];


PackageExport["replaceFunction"]

replaceFunction[expr_, list_] := Module[{arg}, 
	result = expr;
	Block[{f = #[[1]], g = #[[2]]},
		result = replaceFunctionEntery[result, f, g];
	]& /@ list;
	Return[result];
];

replaceFunctionEntery[expr_, f_, g_] := Module[{arg}, 
	arg = Cases[expr
		, (f[args___] | Derivative[___][f][args___]) :> {args}
		, {0, Infinity}
		, Heads -> True
	][[1, 1]];
	expr /. f -> (Function[g] /. arg -> #)
];


PackageExport["collectCoeffs"]

collectCoeffs[equations_, symbols_] := Module[{},
	expr[v_String] := v // ToExpression;
	expr[v_      ] := v;
	Table[Coefficient[row, var // expr]
		, {row, equations}
		, {var, symbols}
	]
]


PackageExport["parallelSimplify"]

parallelSimplify[l_    , hints_:{}] := FullSimplify[l, hints]
parallelSimplify[l_List, hints_:{}] := ParallelMap[FullSimplify[#, hints]&, l]


PackageExport["modify"]
PackageExport["join"]
PackageExport["slice"]
PackageExport["collect"]
PackageExport["substitute"]
PackageExport["collectCoeffs"]
PackageExport["replaceFunction"]
PackageExport["separate"]
PackageExport["simplify"]
PackageExport["chop"]

modify[list`clb_] := Return[Block[{list`v = #}, 
	list`res = list`clb[list`v];
	list`res // printm;
	list`res
]&];

substitute     [args__ ] := modify[                #/.seq2list[args] &]
join           [args__ ] := modify[Join           [#, seq2list[args]]&]
slice          [args__ ] := modify[               (#[[args]])        &]
collect        [args__ ] := modify[Collect        [#, seq2list[args]]&]
collectCoeffs  [args__ ] := modify[collectCoeffs  [#, seq2list[args]]&]
replaceFunction[args__ ] := modify[replaceFunction[#, seq2list[args]]&]
separate       [args__ ] := modify[separate       [#, seq2list[args]]&]
simplify       [args___] := modify[Simplify       [#, seq2list[args]]&]
chop           [args___] := modify[Chop[#, args]&]

separate[v_, rules_] := Block[{exp = v},
	(
		exp = exp /. #;
		exp = Append[Flatten[{exp}, 1], #[[2]] == #[[1]]];
	)& /@ rules;
	Return[exp];
]

PackageExport["setTo"]
PackageExport["normalize"]

SetAttributes[setTo, HoldAll];
setTo[var_] := Return[Block[{val = #}, var = val]&]

normalize[v_] := Return[v / norm[v]]


PackageExport["flatJoin"]
flatJoin[args__] := Flatten[{#}& /@ seq2list[args]]
