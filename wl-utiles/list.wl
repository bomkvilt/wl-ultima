(* ::Package:: *)

Package["ultima`"]
PackageScope["list"]


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

replaceFunction[list`expr_, list`list_] := Module[{arg}, 
	list`result = list`expr;
	ForEach[{list`f, list`g}, list`list, 
		list`result = replaceFunctionEntery[list`result, list`f, list`g]
	];
	list`result
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

collectCoeffs[list`equations_, list`symbols_] := Module[{},
	list`expr[list`v_String] := list`v // ToExpression;
	list`expr[list`v_      ] := list`v;
	Table[Coefficient[row, var // list`expr]
		, {row, list`equations}
		, {var, list`symbols}
	]
]


PackageExport["parallelSimplify"]

parallelSimplify[list`l_    , list`hints_:{}] := FullSimplify[l, hints]
parallelSimplify[list`l_List, list`hints_:{}] := ParallelMap[FullSimplify[#, hints]&, l]


PackageExport["modify"]
PackageExport["join"]
PackageExport["substitute"]
PackageExport["collectCoeffs"]
PackageExport["replaceFunction"]

Options[modify] = {
	  bPrint -> True
	, bSimpl -> False
};

modify[list`clb_, OptionsPattern[modify]] := Return[Block[{list`v = #}, 
	list`res = list`clb[list`v];
	If [OptionValue[bSimpl], list`res = list`res // FullSimplify];
	If [OptionValue[bPrint], list`res // MatrixForm // Print];
	list`res
]&];

substitute     [list`args_, opts:OptionsPattern[modify]] := modify[# /. list`args&, opts]
join           [list`args_, opts:OptionsPattern[modify]] := modify[Join           [#, list`args]&, opts]
collectCoeffs  [list`args_, opts:OptionsPattern[modify]] := modify[collectCoeffs  [#, list`args]&, opts]
replaceFunction[list`args_, opts:OptionsPattern[modify]] := modify[replaceFunction[#, list`args]&, opts]
