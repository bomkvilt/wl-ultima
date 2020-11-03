(* ::Package:: *)

Get @ "code/utiles/notebookToPackage.m"


exportFiles[conf_] := (exportFiles[conf, #])& /@ conf["map"]
exportFiles[conf_, rule_] := Module[{files, pos, relPath
	, type = "type" /. rule
	, path = "path" /. rule // ExpandFileName
	, dest = "dest" /. rule
},
	If [DirectoryQ[path], path = FileNameJoin[{path, "*"}]];
	
	If [pos = StringPosition[path, "*"]; Length@pos > 0
	, relPath = StringTake[path, pos[[1,1]] - 1];
	, relPath = DirectoryName[path];
	];
	dest = FileNameJoin[{conf["build_path"], dest}] // ExpandFileName;
	
	files = FileNames[path, "", \[Infinity]];
	files = Select[files, (!DirectoryQ[#])&];
	exportFile[#, relPath, dest, type, conf]& /@ files;
]


exportFile[src_String, relPath_String, dest_String, type_String, conf_] := 
Module[{base, ext, out
	, cat = DirectoryName @ StringDelete[src, StartOfString~~relPath~~(""|"/"|"\\")]
},
	Which[
	  !FileExistsQ[src ], pError["source file doesn't exist: ``", src];
	,  DirectoryQ [src ], pError["source file is not a file: ``", src];
	, !FileExistsQ[dest], CreateDirectory[dest, CreateIntermediateDirectories->True]; 
	, !DirectoryQ [dest], pError["diestination root is not a directory: ``", dest  ];
	];
	base = FileBaseName [src];
	ext  = FileExtension[src];
	out  = doFileExport[ext, type, src, dest, base, conf];
	src -> out // Print;
	
	ext = FileExtension[out];
	doFileFix[ext, type, out, conf];
]


doFileExport[ext_, type_, src_, dest_, base_, conf_] := 
	CopyFile[src, FileNameJoin[{dest, base <> "." <> ext}]]

doFileExport["nb", "code", src_, dest_, base_, conf_] := 	
	Export[FileNameJoin[{dest, base <> ".m"}], notebookToPackage[src], "Text"]


doFileFix[ext_, type_, file_, conf_] := file;
doFileFix["m", "pack", file_, conf_] := Module[{text = Import[file, "Text"]},
	text = StringReplace[text, "__version__" -> conf["version"]];
	Export[file, text, "Text"];
]
doFileFix["m", "code", file_, conf_] := Module[{text = Import[file, "Text"]},
	text = "Package[\"ultima`\"]\n\n" <> text;
	Export[file, text, "Text"];
]
