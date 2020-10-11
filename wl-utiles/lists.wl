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
	Return[data];
]
