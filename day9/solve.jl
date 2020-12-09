inputs = open("inputs.txt") do file
    parse.(Int, readlines(file))
end

function solve1(inputs)
    rolling_set = Set(inputs[begin:25])
    i = 26
    @inbounds while i <= length(inputs)
        x = inputs[i]
        found = false
        for j = i-25:i-1
            if abs(x - inputs[j]) in rolling_set
                found = true
                break
            end
        end
        !found && (return x)

        delete!(rolling_set, inputs[i-25])
        push!(rolling_set, inputs[i])
        i += 1
    end
    throw(error("No invalid number found"))
end

function solve2(inputs, N)
    i = 1
    j = 2
    s = inputs[i] + inputs[j]
    @inbounds while j <= length(inputs)
        if s == N
            return sum(extrema(inputs[i:j]))
        elseif s < N
            j += 1
            s += inputs[j]
        else
            s -= inputs[i]
            i += 1
        end
    end
    throw(error("No sequence summed up to $N"))
end

N = solve1(inputs);
println(N)
println(solve2(inputs, N))
