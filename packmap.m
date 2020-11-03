packmap = {
    "version"    -> "0.2.0",
    "build_path" -> "build/pack",
    "out_path"   -> "build/out",
    "map" -> {
        { 
            (* package manifest *)
            "type" -> "pack",
            "path" -> "main/PacletInfo.m",
            "dest" -> ""
        }
        ,
        {
            (* package entry point *)
            "type" -> "code",
            "path" -> "main/init.m",
            "dest" -> "kernel"
        },
        {
            (* package style sheets *)
            "type" -> "style",
            "path" -> "style/*",
            "dest" -> "frontend/StyleSheets/ultima"
        },
        {
            (* common code *)
            "type" -> "code",
            "path" -> "code",
            "dest" -> "kernel/code"
        }
    }
};
