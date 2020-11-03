(* ::Package:: *)

Get @ "build/scripts/errors.m"
Get @ "build/scripts/config.m"
Get @ "build/scripts/exporter.m"
Get @ "build/scripts/builder.m"


Module[{
	cfg = loadConfig["packmap.m"]
},
	dropDirectory[cfg["build_path"]];
	dropDirectory[cfg["out_path"  ]];
	exportFiles[cfg];
	
	With [{
		buildRoot = cfg["build_path"] // ExpandFileName,
		outRoot   = cfg["out_path"  ] // ExpandFileName
	},
		SetDirectory[outRoot];
		With [{paclet = PackPaclet[buildRoot]},
			StringForm["paclet is built: ``", paclet] // ToString // Print;
			Export["paclet.name", paclet, "Text"];
		];

		SetDirectory[outRoot];
		If [!FileExistsQ["paclet.name"],
			pError["no build paclet is here"];
		];
		With [{paclet = Import["paclet.name", "Text"]},
			PacletUninstall["ultima"];
			With [{pacletInfo = PacletInstall[paclet]},
				StringForm["installed paclet info: ``", pacletInfo] // ToString // Print;
			];
		];
	];
]
