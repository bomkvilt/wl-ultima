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
	ForEach[{f, g}, list, 
		result = replaceFunctionEntery[result, f, g]
	];
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
PackageExport["substitute"]
PackageExport["collectCoeffs"]
PackageExport["replaceFunction"]
PackageExport["setTo"]

modify[list`clb_] := Return[Block[{list`v = #}, 
	list`res = list`clb[list`v];
	list`res // printm;
	list`res
]&];

substitute     [args__] := modify[                #/.seq2list[args] &]
join           [args__] := modify[Join           [#, seq2list[args]]&]
collectCoeffs  [args__] := modify[collectCoeffs  [#, seq2list[args]]&]
replaceFunction[args__] := modify[replaceFunction[#, seq2list[args]]&]

SetAttributes[setTo, HoldAll];
setTo[var_] := Return[Block[{val = #},
	var = val
]&]


PackageExport["flatJoin"]
flatJoin[args__] := Flatten[{#}& /@ seq2list[args]]



