(* ::Package:: *)

Package["ultima`"]; PackageScope["dynamics"]


PackageExport["stopIntegration"]
HoldAll[stopIntegration];
stopIntegration[event_, action_] := Method -> {
	"EventLocator"
	, "Event" :> event
	, "EventAction" :> Throw[action[], "StopIntegration"]
}
