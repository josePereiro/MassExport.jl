function _ismatch(str::String, reg::Regex)
    return !isnothing(match(reg, str))
end