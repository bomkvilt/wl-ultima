(* ::Package:: *)

Package["ultima`"]; PackageScope["postfix"]


PackageExport["modify"]
modify[clb_] := Return @ Function[{v},
	Return[clb[v] // ReleaseHold]
]


PackageExport["map"]
map[clb_] := modify[clb /@ #&]


PackageExport["show"]
show[clb_] := modify[(clb[#] // printm)&]


PackageExport["rem"]
rem[msg_] := Return @ Function[{v},
	Print[Row @ {"\t", msg, ":"}];
	Return @ v;
]


PackageExport["relink"]
relink[rule_] := map[rule[#[[1]], #[[2]]]&]


PackageExport["revealIdentity"]
revealToZero[bRight_:True] := modify[
	If[bRight, #1 - #2, #2 - #1]&
]


PackageExport["pairdiv"]
PackageExport["scaldiv"]
pairdiv[var__] := map[#[[0]][\!\(
\*SubscriptBox[\(\[PartialD]\), \(var\)]\(#[\([1]\)]\)\), \!\(
\*SubscriptBox[\(\[PartialD]\), \(var\)]\(#[\([2]\)]\)\)]&]
scaldiv[var__] := map[\!\(
\*SubscriptBox[\(\[PartialD]\), \(var\)]#\)&]


PackageExport["slice"]
slice[args__] := modify[#[[args]]&]


PackageExport["join"]
join[args__] := modify[Join[seq2list[#], seq2list[args]]&]


PackageExport["collect"]
collect[args__] := modify[Collect[#, seq2list[args]]&]


PackageExport["vectorize"]
vectorize[args__] := modify[vectorize[#, seq2list[args]]&]

vectorize[peqs_, psyms_] := Module[{isFlat, depth, result, ione, vone, delta
	, eqs   = seq2list[peqs ]
	, rsyms = seq2list[psyms]
	, syms
},		
	isFlat[v_List] := Clip[Length[v] - 1];
	syms   = Select[rsyms, # =!= 1&];
	depth  = isFlat[eqs] + isFlat[rsyms];
	result = Table[Coefficient[row, var]
		, {row, eqs }
		, {var, syms}
	];
	If [ione = Position[rsyms, 1]; ione != {},
		vone = eqs /. (# -> 0& /@ syms);
		result = (Insert[result\[Transpose], vone, ione])\[Transpose];
	];
	If [delta = eqs - result.rsyms // Simplify; norm[delta] =!= 0, 
		Message[vectorize::invalid, delta // MatrixForm]; Abort[];
	];
	If [depth < 2, result = Flatten[result, 1]];
	If [depth < 1, result = First @ result];
	Return @ result;
]

vectorize::invalid = "Passed equations cannot be correctly decomposed on given axes. 
Delta of passed and vectorised forms is: `1`";


PackageExport["separate"]
separate[args__] := modify[separate[#, seq2list[args]]&]

separate[v_, rules_, joint_:Equal] := Module[{exp = v},
	( exp = Append[ seq2list[exp /. #], joint[#[[2]], #[[1]]] ];
	)& /@ rules;
	Return[exp];
]


PackageExport["simplify"]
simplify[args___] := modify[Simplify[#, seq2list[args]]&]


PackageExport["chop"]
chop[args___] := modify[Chop[#, args]&]


PackageExport["setTo"]
SetAttributes[setTo, HoldAll];
setTo[var_] := Return @ Function[{val}, var = val]


PackageExport["plypend"]
plypend[r___] := modify[plypend[#, seq2list[r]]&]

plypend[l_, r_List] := Join[ seq2list[l] //. r, r // relink[#1 -> (#2 //. r)&] ]


PackageExport["sub"]
sub[args__] := modify[# /.seq2list[args]&]


PackageExport["subf"]
subf[args__] := modify[subf[#, seq2list[args]]&]

subf[expr_, list_List] := Module[{result = expr, args, funcRepl}, 
	funcRepl = Function[{f, g}, 
		Function[g] /. args[[1, 1]] -> #
	];
	
	Function[{f, g}, 
		args = Cases[result
			, (f[args___] | Derivative[___][f][args___]) :> {args}
			, {0, Infinity}
			, Heads -> True
		];
		If [args =!= {}
		, result = result /. f -> funcRepl[f, g];
		, result = result /. f -> g;
		];
	][args2seq @ #]& /@ list;
	
	Return @ result;
];
