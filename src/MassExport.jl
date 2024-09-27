module MassExport

    function exportall(filter::Function, mod::Module)
        for sym in names(mod; all = true, imported = true)
            filter(sym) == true || continue
            @eval mod export $(sym)
        end
    end

    macro exportall_underscore()
        return quote
            MassExport.exportall($(__module__)) do sym
                startswith(string(sym), "_") && return true
                startswith(string(sym), "@") && return true
                return false
            end
        end
    end

    macro exportall_words()
        return quote
            MassExport.exportall($(__module__)) do sym
                sym == :eval && return false
                sym == :include && return false
                startswith(string(sym), r"[a-zA-Z]") && return true
                startswith(string(sym), "@") && return true
                return false
            end
        end
    end

    macro exportall_non_underscore()
        return quote
            MassExport.exportall($(__module__)) do sym
                sym == :eval && return false
                sym == :include && return false
                startswith(string(sym), r"[^_#]") && return true
                startswith(string(sym), r"@[^_#]") && return true
                return false
            end
        end
    end

    macro exportall_uppercase()
        return quote
            MassExport.exportall($(__module__)) do sym
                startswith(string(sym), r"[A-Z]") && return true
                startswith(string(sym), "@") && return true
                return false
            end
        end
    end

    @exportall_words()
end
