(* ::Package:: *)

Package["ultima`"]; PackageScope["prints"]


PackageExport["block"]
block[c_] := Print[Row @ {">> ", c, ":"}]


PackageExport["printm"]
PackageExport["printt"]
PackageExport["printp"]

printBase[v_, clb_] := (
	Print[clb @ v];
	Return @ v;
)

printm[v_] := printBase[v, MatrixForm]
printt[v_] := printBase[v, TableForm[#, TableSpacing->{0,3}]&]
printp[pp__] := Print[#]& /@ seq2list[pp]
