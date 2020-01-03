## How to enable dark theme
```mathematica
(* .wl and .m  files *)
CurrentValue[$FrontEnd, "DefaultPackageStyleDefinitions"] = FrontEnd`FileName[{"ultima", "ultimaPackageDark.nb"}]

(* .nb files *)
CurrentValue[$FrontEnd, "DefaultStyleDefinitions"] = FrontEnd`FileName[{"ultima", "ultimaPackageDark.nb"}]
```

## know issues
 - using of the package symbols in the same block with ```Needs["ultima`"]``` couses ununderstandable error of symbol shading
