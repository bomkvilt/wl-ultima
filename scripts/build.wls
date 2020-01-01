#!/usr/bin/env wolframscript
(* ::Package:: *)

ultima`installer`packages = {
	  {type -> "paclet", name -> "paclet"}
	, {type -> "plane" , name -> "wl-utiles"}
	, {type -> "plane" , name -> "wl-style"}
	, {type -> "pack"  , name -> "wl-grid"}
};
ultima`installer`buildPath    = FileNameJoin[{Directory[], "build"}];
ultima`installer`buildSrcPath = FileNameJoin[{Directory[], "build", "src"}];


ultima`installer`copy[pack_] := Module[{},
	packName = name /. pack;
	basePath = FileNameJoin[{Directory[], packName}];
	destPath = ultima`installer`buildSrcPath;
	
	Switch[type /. pack
	, "paclet", ultima`installer`copyPaclet[basePath, destPath];
	, "plane" , ultima`installer`copyPlane [basePath, destPath, packName];
	, "pack"  , ultima`installer`copyPack  [basePath, destPath, packName];
	];
	StringForm["package processed: ``", (name /. pack)] // ToString // Print;
]

ultima`installer`copyPaclet[basePath_, destPath_] := Module[{},
	ultima`installer`copyFiles[basePath, destPath];
]

ultima`installer`copyPlane[basePath_, destPath_, packName_] := Module[{},
	ultima`installer`copyFiles[basePath, FileNameJoin[{destPath, packName}]];
]

ultima`installer`copyPack[basePath_, destPath_, packName_] := Module[{},
	out  = RunProcess[{"./control.bat", "pack", FileNameJoin[{destPath, packName}]}
		, ProcessDirectory->basePath
	];
	code = "ExitCode" /. out;
	If [code != 0, Throw @ StringForm["cannot copy files: ``: ``", pack, out]];
]

ultima`installer`copyFiles[basePath_, destPath_] := Module[{},
	ultima`installer`refreshDirectory[destPath];
	out  = RunProcess[{"xcopy", basePath, destPath, "/e"}, ProcessDirectory->Directory[]];
	code = "ExitCode" /. out;
	If [code != 0, Throw @ StringForm["cannot copy files: ``: ``", pack, out]];
]

ultima`installer`refreshDirectory[path_] := Module[{},
	If [FileExistsQ[path], 
		DeleteDirectory[path, DeleteContents->True];
	];
	CreateDirectory[path];
]


ultima`installer`refreshDirectory[ultima`installer`buildPath];
ultima`installer`copy /@ ultima`installer`packages;


SetDirectory[ultima`installer`buildPath];

(* build paclet *)
paclet = PackPaclet[ultima`installer`buildSrcPath];
StringForm["paclet: ``", paclet] // ToString // Print;

(* re-install the paclet *)
PacletUninstall["ultima"];
pacletInfo = PacletInstall[paclet];
StringForm["paclet: ``", pacletInfo] // ToString // Print;


Quit[];
