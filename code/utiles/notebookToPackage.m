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
	cells = Cases[nbObj, Cell[body_, style : "Code" | "Text", ___] :> {body, style}, \[Infinity]]
}, Riffle[Replace[cells, $cellRules, {1}], ""]]


$cellRules = {
	{body_      , "Code"} :> boxesToStrings[body],
	{body_String, "Text"} :> commentate    [body]
};

$scratchContext = "Scratch`Private`";
boxesToStrings[boxes_] := With[{$Context = $scratchContext},
	stringulate @@ ToExpression[StripBoxes[boxes], StandardForm, HoldComplete]
]

Attributes[stringulate] = {HoldAllComplete};
stringulate[expr_] := ToString[Unevaluated[expr], InputForm
	, CharacterEncoding -> "ASCII"
	, PageWidth         -> \[Infinity]
]

commentate[s_String] := ToString["(*\n"<>s<>"\n*)", OutputForm
	, CharacterEncoding -> "ASCII"
	, PageWidth         -> \[Infinity]
]

