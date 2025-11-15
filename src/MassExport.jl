module MassExport

    """
        MassExport

        Utilities for mass-exporting bindings from a module, using simple
        filtering rules.

        The core entry point is [`exportall`](@ref), and several convenience
        macros are provided:

        * [`@exportall`](@ref)               - export everything except a few internals
        * [`@exportall_underscore`](@ref)    - export only names starting with `_` / `@_`
        * [`@exportall_words`](@ref)         - export names starting with a letter / `@letter`
        * [`@exportall_non_underscore`](@ref) - export names that do *not* start with `_` or `#`
        * [`@exportall_uppercase`](@ref)     - export names starting with an uppercase letter
    """

    using Reexport
    @reexport using Reexport

    #! include .
    include("export.jl")
    include("import.jl")
    include("utils.jl")

end