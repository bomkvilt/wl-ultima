(* ::Package:: *)

Paclet[
	Name    -> "ultima",
	Version -> "0.1.1",
	Creator -> "",
	Description -> "",
	MathematicaVersion -> "10.0+",
	Extensions -> {
		{ "Kernel"
			, Root -> "kernel"
			, HiddenImport -> True
			, Context -> {"ultima`"}
		},
		{ "FrontEnd"
			, Root -> "frontend"
			, Prepend -> True
		}
	}
]
