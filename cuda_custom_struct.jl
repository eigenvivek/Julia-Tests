using BenchmarkTools
using Test

using Adapt
using CUDA


struct Interpolate{A}
    xs::A
    ys::A
end

Adapt.@adapt_structure Interpolate

function (itp::Interpolate)(x)
    i = searchsortedfirst(itp.xs, x)
    i = clamp(i, firstindex(itp.ys), lastindex(itp.ys))
    @inbounds itp.ys[i]
end


function bench_cpu()
    xs_cpu = [1.0, 2.0, 3.0]
    ys_cpu = [10.0,20.0,30.0]
    itp_cpu = Interpolate(xs_cpu, ys_cpu)
    pts_cpu = [1.1,2.3]
    result_cpu = itp_cpu.(pts_cpu)
end


function bench_gpu()
    xs_gpu = CuArray([1.0, 2.0, 3.0])
    ys_gpu = CuArray([10., 20., 30.])
    pts_gpu = CuArray([1.1, 2.3])
    itp_gpu = Interpolate(xs_gpu, ys_gpu)
    result_gpu = itp_gpu.(pts_gpu)
end


# Test the two implementations get the same result
result_cpu = bench_cpu() |> CuArray
result_gpu = bench_gpu()
# @test result_cpu .== result_gpu

# Benchmark CPU vs GPU performance
@show "Testing CPU implementation..."
@btime bench_cpu()

@show "Testing GPU implementation..."
@btime bench_gpu()
