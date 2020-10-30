#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


Module[{
	(* ---| definitions |--- *)
	
	  buildPath    = ""
	, outPath      = ""
	, packPath     = ""
	, version      = ""
	, codeDirs     = {}
	, packmapFN    = "packmap.m"
	, pacletInfoFN = "PacletInfo.m"
	, cwd          = Directory[]
	
	(* ---| functions |--- *)
	, pError, getVal, fixPath, renewDir, copyFiles
},
	pError = (Print["\n  Error::" <> ToString@StringForm[##] <> "\n"]; Exit[1];)&;
	getVal = If [!KeyExistsQ[packmap, #], 
		pError["configuration value '``' is missing", #];
	,
		# /.packmap
	]&;
	fixPath  = FileNameJoin[StringSplit[#, {"\\", "/"}]]&;
	renewDir = If[FileExistsQ[#], 
		If [Length[Flatten[{##}, 1]] == 1,
			DeleteDirectory[#, DeleteContents->True];
			CreateDirectory[#, CreateIntermediateDirectories->True];
		];
	,
		CreateDirectory[#, CreateIntermediateDirectories->True];
	]&;
	copyFiles = Block[{out, excode},
		If [#2 === "",
			pError["cannot build to a root directory"];
		];
		renewDir[#2, False];
		out = RunProcess[{"xcopy", #1, #2, "/e"}];
		If [excode = "ExitCode" /. out; excode =!= 0,
			pError["cannot copy files '``' -> '``': ``", #1, #2, out];
		]
	]&;
	(* ----------| get package map file |---------- *)
	If [!FileExistsQ[packmapFN],
		pError["current directory is not a project root directory: ``", cwd];
	];
	Get @ packmapFN;
	If [packmap[[0]] === Symbol,
		pError["package map symbol is undefined"];
	];
	
	(* ----------| build map |---------- *)
	buildPath = getVal["build_path"] // fixPath;
	version   = getVal["version"];
	Block[{
		type = "type" /. # // fixPath,
		path = "path" /. # // fixPath,
		dest = "dest" /. # // fixPath
	},
		If [ExpandFileName[path] === FileNameJoin@FileNameSplit[path],
			pError["absolute path are forbidden: ``", path];
		];
		If [!KeyExistsQ[#, "dest"],
			dest = ""
		];
		Switch[type
		, "code", 
			codeDirs = {codeDirs, path -> dest}
		, "pack", 
			If [packPath =!= "",
				pError["package path is already defined. New definition is ``", path];
			];
			packPath = path -> dest;
		, __, 
			pError["undefined entity type '``'", type];
		];
	]& /@ getVal["map"];
	
	codeDirs = Flatten[codeDirs];
	
	If [packPath === "" || packPath[[1]] === "",
		pError["package path is not defined"];
	];
	If [buildPath === "",
		pError["cannot build to a root directory"];
	];
	
	(* ----------| copy files |---------- *)
	renewDir [buildPath];
	copyFiles[#1, FileNameJoin[{buildPath, #2}]]& @@# & /@ Flatten[{packPath, codeDirs}];
	
	(* ----------| set version |---------- *)
	With [{path = FileNameJoin[{buildPath, pacletInfoFN}]},
		Export[path,
			StringReplace[Import[path, "Text"], "__version__" -> version]
			, "Text"
		]
	];
	
	(* ----------| copy files |---------- *)
	buildPath = getVal["build_path"] // ExpandFileName;
	outPath   = getVal["out_path"  ] // ExpandFileName;
	renewDir    [outPath];
	SetDirectory[outPath];
		
	With [{paclet = PackPaclet[buildPath]},
		StringForm["paclet is built: ``", paclet] // ToString // Print;
		Export["paclet.name", paclet, "Text"];
	];
]
