(* ::Package:: *)

BeginPackage["ultima`"]


Module[{inFiles
	, bandled    = "Package[\"ultima`\"]\n"
	, kernelRoot = DirectoryName[$InputFileName]
},
	(* list of kernel files *)
	inFiles = Block[{subPath, files},
		subPath = FileNameJoin[{kernelRoot, ##}]&;
		files   = Complement[Flatten @ {
			FileNames["*.m" , kernelRoot, \[Infinity]],
			FileNames["*.wl", kernelRoot, \[Infinity]]
		}, Flatten @ {
			FileNameJoin[{kernelRoot, "init.m"}]
		}];
		files
	];
	(* read the files one by one *)
	Scan[Function[{fileName}, Block[{data = Import[fileName]},
		bandled += data;
	]], inFiles];
	(* save the super bandle *)
	Export[FileNameJoin[{kernelRoot, "bandle.m"}], bandled]
]


EndPackage[]
