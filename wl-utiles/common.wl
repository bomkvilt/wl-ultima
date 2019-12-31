(* ::Package:: *)

(** Foreach cycle *)
SetAttributes[ForEach,HoldAll];
ForEach[patt_/; FreeQ[patt, Pattern],list_,expr_,level_:1] :=
  Module[{pattWithBlanks,pattern},
    pattWithBlanks = patt/.(x_Symbol/;!MemberQ[{"System`"},Context[x]] :> pattern[x,Blank[]]);
    pattWithBlanks = pattWithBlanks/.pattern->Pattern;
    Cases[Unevaluated@list, pattWithBlanks :> expr, {level}];
    Null
];


(** Replace function *)
replaceFunctionEntery[expr_, f_, g_] := Module[{arg}, 
	arg = Cases[expr
		, (f[args___] | Derivative[___][f][args___]) :> {args}
		, {0, Infinity}
		, Heads -> True
	][[1, 1]];
	expr /. f -> (Function[g] /. arg -> #)
];

replaceFunction[expr_, list_] := Module[{arg}, 
  result = expr;
  ForEach[{f, g}, list, result = replaceFunctionEntery[result, f, g]];
  result
];


(** Vector functions *)
vector[v_] := FullSimplify[v][[All, 1]];
norm[v_] := Sqrt[Sum[p^2, {p, v}]];

printm[t_, m_] := CellPrint[{
  Row[{TextCell["\t"  ], TextCell[t], TextCell[":"]}],
  Row[{TextCell["\t\t"], MatrixForm[m]}]
}];

printp[pp_ ] := CellPrint[
	(Print[#]) &/@ pp
];

print[v_] := (
	Print [v // MatrixForm];
	Return[v];
)

pscale[p_, ratio_:1] := (
	range = First /@ Differences /@ (PlotRange /. Options[p]);
	Show[p, AspectRatio -> (Last[range]/First[range]/ratio)]
)


parallelSimplify[l_, hints_:{}] := FullSimplify[l, hints];
parallelSimplify[l_List, hints_:{}] := Block[{},
	ParallelMap[FullSimplify[#, hints]&, l]
];


addModule[path_] := NotebookEvaluate[NotebookDirectory[] <> path, InsertResults->True];


substitute[common`list_List, OptionsPattern[{
	bPrint -> True,
	bSimpl -> False
}]] := Block[{}, 
	Return[Block[{common`v = #}, 
		common`res = common`v /. common`list;
		If [OptionValue[bSimpl], common`res = common`res // FullSimplify];
		If [OptionValue[bPrint], common`res // MatrixForm // Print];
		common`res
	]&];
]

join[common`list_List, OptionsPattern[{
	bPrint -> True,
	bSimpl -> False
}]] := Block[{}, 
	Return[Block[{common`v = #}, 
		common`res = Join[common`v, common`list];
		If [OptionValue[bSimpl], common`res = common`res // FullSimplify];
		If [OptionValue[bPrint], common`res // MatrixForm // Print];
		common`res
	]&];
]

replaceFunction[common`list_List, OptionsPattern[{
	bPrint -> True,
	bSimpl -> False
}]] := Block[{}, 
	Return[Block[{common`v = #}, 
		res = replaceFunction[common`v, common`list];
		If [OptionValue[bSimpl], common`res = common`res // FullSimplify];
		If [OptionValue[bPrint], common`res // MatrixForm // Print];
		common`res
	]&];
]

collectCoeffs[common`list_List, OptionsPattern[{
	bPrint -> True,
	bSimpl -> False
}]] := Block[{}, 
	Return[Block[{common`args = #}, 
		common`expr[common`v_String] := common`v // ToExpression;
		common`expr[common`v_      ] := common`v;
		common`res = Table[Coefficient[row, var // common`expr]
			, {row, common`args}
			, {var, common`list}
		];
		If [OptionValue[bSimpl], common`res = common`res // FullSimplify];
		If [OptionValue[bPrint], common`res // MatrixForm // Print];
		common`res
	]&];
]

modify[common`clb_, OptionsPattern[{
	bPrint -> True,
	bSimpl -> False
}]] := Block[{}, 
	Return[Block[{common`v = #}, 
		common`res = common`clb[common`v];
		If [OptionValue[bSimpl], common`res = common`res // FullSimplify];
		If [OptionValue[bPrint], common`res // MatrixForm // Print];
		common`res
	]&];
]
