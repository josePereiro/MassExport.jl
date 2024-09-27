using MassExport
using Test

# exportall_underscore
module Test_exportall_underscore
    using MassExport
    Test_exportall_underscore_no_export = 1;
    _Test_exportall_underscore_export = 1;
    @exportall_underscore()
end
using .Test_exportall_underscore

# exportall_words
module Test_exportall_words
    using MassExport
    Test_exportall_words_export = 1;
    test_exportall_words_export = 1;
    _Test_exportall_words_no_export = 1;
    @exportall_words()
end
using .Test_exportall_words

# exportall_non_underscore
module Test_exportall_non_underscore
    using MassExport
    Test_exportall_non_underscore_export = 1;
    test_exportall_non_underscore_export = 1;
    _Test_exportall_non_underscore_no_export = 1;
    @exportall_non_underscore()
end
using .Test_exportall_non_underscore

# exportall_uppercase
module Test_exportall_uppercase
    using MassExport
    Test_exportall_uppercase_export = 1;
    test_exportall_uppercase_no_export = 1;
    _Test_exportall_uppercase_no_export = 1;
    _test_exportall_uppercase_no_export = 1;
    @exportall_uppercase()
end
using .Test_exportall_uppercase

@testset "MassExport.jl" begin
    
    # exportall_underscore
    @test isdefined(Main, Symbol("@exportall_underscore"))
    @test !isdefined(Main, Symbol("Test_exportall_underscore_no_export"))
    @test isdefined(Main, Symbol("_Test_exportall_underscore_export"))
    
    # exportall_words
    @test isdefined(Main, Symbol("@exportall_words"))
    @test isdefined(Main, Symbol("Test_exportall_words_export"))
    @test isdefined(Main, Symbol("test_exportall_words_export"))
    @test !isdefined(Main, Symbol("_Test_exportall_words_no_export"))

    # exportall_non_underscore
    @test isdefined(Main, Symbol("@exportall_non_underscore"))
    @test isdefined(Main, Symbol("Test_exportall_non_underscore_export"))
    @test isdefined(Main, Symbol("test_exportall_non_underscore_export"))
    @test !isdefined(Main, Symbol("_Test_exportall_non_underscore_no_export"))

    # exportall_uppercase
    @test isdefined(Main, Symbol("@exportall_uppercase"))
    @test isdefined(Main, Symbol("Test_exportall_uppercase_export"))
    @test !isdefined(Main, Symbol("test_exportall_uppercase_no_export"))
    @test !isdefined(Main, Symbol("_Test_exportall_uppercase_no_export"))
    @test !isdefined(Main, Symbol("_test_exportall_uppercase_no_export"))

end
