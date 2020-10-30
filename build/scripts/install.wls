#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


Module[{paclet
	, buildPath = ""
	, outPath   = ""
	, packmapFN = "packmap.m"
	, cwd       = Directory[]
	, pError    = (Print["\n  Error::" <> ToString@StringForm[##] <> "\n"]; Exit[1];)&
	, getVal = If [(# /.packmap) === Symbol
		, pError["configuration value '``' is missing", #];
		, # /.packmap
	]&
},
	If [!FileExistsQ[FileNameJoin[{cwd, packmapFN}]],
		pError["current directory is not a project root directory: ``", cwd];
	];
	Get @ FileNameJoin[{cwd, packmapFN}];
	If [packmap[[0]] === Symbol,
		pError["package map symbol is undefined"];
	];
	
	buildPath = getVal["build_path"] // ExpandFileName;
	outPath   = getVal["out_path"  ] // ExpandFileName;
	SetDirectory[outPath];
	
	If [!FileExistsQ["paclet.name"],
		pError["no build paclet is here"];
	];
	paclet = Import["paclet.name", "Text"];
	
	PacletUninstall["ultima"];
	With [{pacletInfo = PacletInstall[paclet]},
		StringForm["installed paclet info: ``", pacletInfo] // ToString // Print;
	];
	
	Exit[0];
]
