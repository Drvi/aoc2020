const OUR_BAG = "shiny gold"
inputs = open("inputs.txt") do file
    D = map(readlines(file)) do line
        m = match(r"^(?<bag>\w+ \w+) bags? contains? (?<others>.*) bags?\.$", line)
        bag = m[:bag]

        D = Dict{String,Int}()
        for other in split(m[:others], r"\s*bags?,?\s*")
            other == "no other" && continue
            (n, other_bag) = split(other, limit = 2)
            D[other_bag] = parse(Int, n)
        end
        bag => D
    end
    Dict(D)
end

function solve1(inputs)
    invG = Dict{String,Set{String}}()
    for (k, vs) in inputs
        for v in keys(vs)
            if v in keys(invG)
                push!(invG[v], k)
            else
                invG[v] = Set{String}([k])
            end
        end
    end

    queue = [OUR_BAG]
    seen = Set{String}()
    while !isempty(queue)
        u = pop!(queue)
        !(u in keys(invG)) && continue
        for v in invG[u]
            if !(v in seen)
                push!(seen, v)
                push!(queue, v)
            end
        end
    end
    length(seen)
end

function _dfs_visit(inputs, u)
    out = 0
    @inbounds for v in keys(inputs[u])
        out += inputs[u][v] * (_dfs_visit(inputs, v) + 1)
    end
    out
end

function solve2(inputs)
    _dfs_visit(inputs, OUR_BAG)
end


println(solve1(inputs))
println(solve2(inputs))
