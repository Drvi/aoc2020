inputs = open("inputs.txt") do file
    parse.(Int, readlines(file))
end

function solve1(inputs)
    D = Dict(2020 - x => x for x in inputs)
    for x in inputs
        if x in keys(D)
            return D[x] * x
        end
    end
    throw(error("No solution found"))
end

function solve2(inputs)
    inputs = sort(inputs)
    @inbounds for (i, x) in enumerate(inputs)
        for (j, y) in enumerate(@view(inputs[i+1:end]))
            z = 2020 - x - y
            k = searchsorted(@view(inputs[j+i+1:end]), z)
            length(k) >= 1 && return (x * y * z)
        end
    end
    throw(error("No solution found"))
end

println(solve1(inputs))
println(solve2(inputs))
