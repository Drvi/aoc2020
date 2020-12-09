inputs = open("inputs.txt") do file
    map(x -> (x[1], parse(Int, x[2])), split.(readlines(file)))
end

function solve1(inputs)
    i = 1
    acc = 0
    seen = falses(length(inputs))
    @inbounds while true
        seen[i] && (return acc)
        seen[i] = true
        ins, val = inputs[i]
        if ins == "acc"
            acc += val
            i += 1
        elseif ins == "jmp"
            i += val
        elseif ins == "nop"
            i += 1
        end
    end
end

function _solve_from(inputs, i, acc, seen)
    n = length(inputs)
    @inbounds while true
        i == n + 1 && (return acc)
        seen[i] && (return nothing)
        seen[i] = true
        ins, val = inputs[i]
        if ins == "acc"
            acc += val
            i += 1
        elseif ins == "jmp"
            i += val
        elseif ins == "nop"
            i += 1
        end
    end
end

function solve2(inputs)
    n = length(inputs)
    i = 1
    acc = 0
    seen = falses(n)
    @inbounds while true
        seen[i] = true
        ins, val = inputs[i]
        if ins == "acc"
            acc += val
            i += 1
        elseif ins == "jmp"
            res = _solve_from(inputs, i + 1, acc, seen)
            !isnothing(res) && (return res)
            i += val
        elseif ins == "nop"
            res = _solve_from(inputs, i + val, acc, seen)
            !isnothing(res) && (return res)
            i += 1
        end
    end
end


println(solve1(inputs))
println(solve2(inputs))
