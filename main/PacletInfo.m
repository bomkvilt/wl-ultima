
Paclet[
    Name                -> "ultima",
    Version             -> "__version__",
    Creator             -> "bomkvilt",
    Description         -> "commands to make you code plus de simple",
    MathematicaVersion  -> "10.0+",
    Extensions -> {
        { "Kernel"
            , Root          -> "kernel"
            , Context       -> { "ultima`" }
            , HiddenImport  -> True
        },
        { "FrontEnd"
            , Root          -> "frontend"
            , Prepend       -> True
        }
    }
]
