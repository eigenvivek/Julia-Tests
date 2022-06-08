using Zygote

function addone(a::AbstractArray)
    b = similar(a)
    b .= a .+ 1
    return sum(b)
end

a = randn(5)
gradient(addone, a)  # The gradient should not work because mutating arrays is not supported in Zygote

Zygote.refresh()  # The incorrect gradient calculated above was cached and our newly defined rule will not be used
using ChainRulesCore  # If you only want to define rules and use them in Zygote, import ChainRulesCore instead of ChainRules (see https://juliadiff.org/ChainRulesCore.jl/stable/FAQ.html#When-to-use-ChainRules-vs-ChainRulesCore?)

function ChainRulesCore.rrule(::typeof(addone), a)  # Define the gradient for addone and its fields with a reverse rule
    y = addone(a)  # Compute the result of addone
    function addone_pullback(ȳ)  # ȳ is the pullback?
        f̄ = NoTangent()  # NoTangent() means that if we purturb the inputs, the function will error. If the function value will not change, use ZeroTangent() instead.
        ā = ones(length(a))  # Derivative of a+1 wrt to a is 1
        return f̄, ā
    end
    return y, addone_pullback
end

gradient(addone, a)