export exportall
export @exportall
export @exportall_underscore
export @exportall_words
export @exportall_non_underscore
export @exportall_uppercase

const _ALWAYS_SKIP = Set((
    :eval,
    :include,
    Symbol("@__LINE__"),
    Symbol("@__FILE__"),
    Symbol("@__DIR__"),
    Symbol("@__MODULE__"),
))


function _toskip(sym::Symbol)
    sym in _ALWAYS_SKIP && return true
    str = string(sym)
    _ismatch(str, r"^#") && return true
    _ismatch(str, r"^@#") && return true
    return false
end

    
"""
    exportall(filter, mod)

Export every symbol in `mod` for which `filter(sym)` returns `true`.

This is the low-level engine behind all `@exportall_*` macros.  
It applies the filter to *every* name in the module (including imported and
compiler-generated ones), so callers usually apply `_toskip` first.
"""
function exportall(filter::Function, mod::Module)
    for sym in names(mod; all = true, imported = true)
        filter(sym) == true || continue
        @eval mod export $(sym)
    end
end


"""
    @exportall

Export all symbols from the current module except those in the global skip list:
- `eval`, `include`
- compiler-generated names starting with `#`
- internal location macros like `@__LINE__`

This macro is intentionally broad. Use it only when your module is small and you
want “everything public” without writing out exports manually.
"""
macro exportall()
    return quote
        MassExport.exportall($(__module__)) do sym
            MassExport._toskip(sym) && return false
            return true
        end
    end
end

"""
    @exportall_underscore

Export all names that start with `_` or `@_`, minus anything in the global
skip list.

Useful when your convention is:  
- leading underscore = “export this as a grouped subsystem”,  
- normal names = “private helper unless exported explicitly”.

Most packages use `_` for internals, so this macro is niche but intentional.
"""
macro exportall_underscore()
    return quote
        MassExport.exportall($(__module__)) do sym
            MassExport._toskip(sym) && return false
            str = string(sym)
            MassExport._ismatch(str, r"^_") && return true
            MassExport._ismatch(str, r"^@_") && return true
            return false
        end
    end
end

"""
    @exportall_words

Export all names that begin with an ASCII letter (`A-Z` or `a-z`) or `@` followed
by a letter, while still applying the global skip rules.

This effectively means:  
- export “normal, human-named” identifiers,  
- skip `_foo`, `#internal`, and compiler helpers.

A good choice when your public API uses conventional names and internal helpers
use `_` or other punctuation.
"""
macro exportall_words()
    return quote
        MassExport.exportall($(__module__)) do sym
            MassExport._toskip(sym) && return false
            str = string(sym)
            MassExport._ismatch(str, r"^[a-zA-Z]") && return true
            MassExport._ismatch(str, r"^@[a-zA-Z]") && return true
            return false
        end
    end
end

"""
    @exportall_non_underscore

Export every name *except* those starting with `_`, plus the global skip list.

This means: “anything that doesn't start with `_` is considered public”.

If your coding style treats leading underscore as “private/internal”, this macro
is a natural way to export everything that counts as part of the package's public
API without listing names manually.
"""
macro exportall_non_underscore()
    return quote
        MassExport.exportall($(__module__)) do sym
            MassExport._toskip(sym) && return false
            str = string(sym)
            MassExport._ismatch(str, r"^[^_]") && return true
            MassExport._ismatch(str, r"^@[^_]") && return true
            return false
        end
    end
end

"""
    @exportall_uppercase

Export all names that start with an uppercase letter (`A-Z`) or `@` followed by
an uppercase letter, minus the global skip list.

Great if your public API consists mainly of:
- types (which conventionally start with capitals)
- constants or module-level objects with capitalized names

Everything else—helpers, lowercase functions, underscore internals—remains unexported.
"""
macro exportall_uppercase()
    return quote
        MassExport.exportall($(__module__)) do sym
            MassExport._toskip(sym) && return false
            str = string(sym)
            MassExport._ismatch(str, r"^[A-Z]") && return true
            MassExport._ismatch(str, r"^@[A-Z]") && return true
            return false
        end
    end
end
