(* ::Package:: *)

BeginPackage["ultima`"]
Begin["ultima`Bootstrap`Private`"]


(* load dependencies *)
Quiet @ Needs["GeneralUtilities`"];


(* clear protected symbols *)
syms = PacletExportedSymbols["ultima"];
Unprotect @@ syms;
ClearAll  @@ syms;


(* obtain files to load *)
$basePath = DirectoryName[$InputFileName, 2];
subPath[p__] := FileNameJoin[{$basePath, p}];
$filesm  = FileNames["*.m" , $basePath, \[Infinity]];
$fileswl = FileNames["*.wl", $basePath, \[Infinity]];
$ignoreFiles = Flatten @ {
	subPath["kernel", "init.m"],
	subpath["ParcletInfo.m"]
}

$files = Complement[Join[$filesm, $fileswl]
	, $ignoreFiles
];
(* Then it might be usefull to sort the files *)


(* scan for scoped and exported symbols *)
$lines = StringSplit[StringTrim @ FindList[$files, {"PackageScope", "PackageExport"}], {"[", "]", "\""}]
$private = Cases[$lines, {"PackageScope" , _, name_} :> name];
$public  = Cases[$lines, {"PackageExport", _, name_} :> name];
$public  = Complement[$public, Names["System`*"]];

(* create symbols in the right context *)
createInContext[context_, names_] := Block[{
	$ContextPath = {}, 
	$Context = context
}, ToExpression[names, InputForm, Hold]];
createInContext["ultima`"        , $public ];
createInContext["ultima`Private`", $private];


(* load files *)
$contexts = {"System`", "Developer`", "Internal`", "GeneralUtilities`"
	, "ultima`"
	, "ultima`Private`"
};

Block[{$ContextPath = $contexts},
	primer = "(* ::Package:: *)\n\nPackage['ultima`']\n";
	dropSize = StringLength[primer];
	primer = StringReplace[primer, {"'" -> "\""}, \[Infinity]];

	loadFile[file_] := Block[{
		  $Context = "ultima`Private`" <> FileBaseName[file] <> "`"
		, ultima`pack`$fileName = file
	},
		data = FileString[file];
		If [!StringStartsQ[data, primer], Return[]];
		data = StringDrop[data, dropSize];
		
		Check[ToExpression[data, InputForm]
			, Print["Message occurred during file: ", file];
		];
	];
	Scan[loadFile, $files]
]


(* protect symbols *)
Protect @@ syms;


End[];
EndPackage[];
