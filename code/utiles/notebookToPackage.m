(* ::Package:: *)

PackageExport["notebookToPackage"]
notebookToPackage[nbPath_String] := With[{
	nbObj = Get@nbPath
},
	If [nbObj =!= $Failed
	, ExportString[notebookToString@nbObj, {"Text", "Lines"}]
	, $Failed
	]
]


(* ::Text:: *)
(*private:*)


notebookToString[nbObj_] := With[{
	cells = Cases[nbObj, Cell[body_, style : "Code", ___] :> {body, style}, \[Infinity]]
}, Riffle[Replace[cells, $cellRules, {1}], "\n"]]


$cellRules = {
	{body_      , "Code"} :> boxesToStrings[body],
	{body_String, "Text"} :> commentate    [body]
};

$scratchContext = "Scratch`Private`";
boxesToStrings[boxes_] := With[{$Context = $scratchContext},
	Module[{data = ToExpression[StripBoxes[boxes], StandardForm, Hold]}, 
		data = Replace[Map[Hold, data, {1}], Hold -> List, {1}, Heads->True];
		data = DeleteCases[data, Hold[Null]];
		data = StringRiffle[stringulate[#]& /@ data, "\n"];
		data = StringReplace[data, {
			"PackageExport["~~Shortest[a__]~~"]"~~Shortest[" "...]~~";" :> 
			"PackageExport["<>         a   <>"]"
		}]
	]
]

(*Attributes[stringulate] = {HoldAllComplete};*)
stringulate[expr_] := StringReplace[ToString[Unevaluated[expr], InputForm
	, CharacterEncoding -> "ASCII"
	, PageWidth         -> 180
], "Hold["~~a___~~"]"~~EndOfString -> a]

commentate[s_String] := ToString["(*\n"<>s<>"\n*)", OutputForm
	, CharacterEncoding -> "ASCII"
	, PageWidth         -> 180
]
