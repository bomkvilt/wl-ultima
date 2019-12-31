#!/usr/bin/env wolframscript
(* ::Package:: *)

libs`Installer`packages = {
	  {name -> "paclet", type -> "plane"}
	, {name -> "common", type -> "plane"}
	, {name -> "style" , type -> "plane"}
	, {name -> "grid"  , type -> "pack" }
};
libs`Installer`buildPath = FileNameJoin[{Directory[], "build"}];


libs`Installer`build[pack_] := Module[{
	path = FileNameJoin[{Directory[], name /. pack}]
}, 
	Switch[type /. pack
	, "pack",
		out  = RunProcess[{"./pack.bat", libs`Installer`buildPath}, ProcessDirectory -> path];
		code = "ExitCode" /. out;
		If [code != 0, 
			Throw @ StringForm["cannot build the pack: ``: ``", pack, out]
		];
	, _, 
		out  = RunProcess[{"xcopy", path, libs`Installer`buildPath, "/e"}, ProcessDirectory -> path];
		code = "ExitCode" /. out;
		If [code != 0, 
			Throw @ StringForm["cannot build the pack: ``: ``", pack, out]
		];
	];
	StringForm["package processed: ``", (name /. pack)] // ToString // Print;
]

DeleteDirectory[libs`Installer`buildPath, DeleteContents->True];
CreateDirectory[libs`Installer`buildPath];

libs`Installer`build /@ libs`Installer`packages;


packlet = PackPaclet[libs`Installer`buildPath];
StringForm["parclet: ``", packlet] // ToString // Print;

PacletUninstall["libs"];
PacletInstall[packlet] // Print;
PacletFind["libs"] // Print;


Pause[4];
