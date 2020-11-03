(* ::Package:: *)

loadConfig[path_String] := Module[{conf},
	Get[path]; conf = packmap;
	If [!KeyExistsQ[conf, #]
	, pError["unknown key: ``", #];
	, # /. conf
	]&
]
