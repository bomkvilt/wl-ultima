(* ::Package:: *)

If [$InputFileName =!= "",
	packageRoot = DirectoryName[$InputFileName];
,
	packageRoot = NotebookDirectory[];
]
SetDirectory[packageRoot];


$usedFiles  = {"init.m"};

getFiles[pathExpr__String] := Block[{
	subPath = ExpandFileName[#]&,
	exclude = subPath /@ $usedFiles,
	found   = FileNames[#, packageRoot, \[Infinity]]& /@ {pathExpr} // Flatten
},
	Complement[found, exclude]
]
useFile[names__String] := $usedFiles = Join[$usedFiles, {names}]


Get& /@ getFiles["*.m", "*.wl", "*.nb"]


Module[{preloadFiles},
	
]
