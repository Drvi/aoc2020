inputs = open("inputs.txt") do file
    readlines(file)
end

function _decode_binary(input, comp)
    out = 0x00
    n = length(input)
    for (i, c) in enumerate(input)
        out |= (c == comp) << (n - i)
    end
    out
end

function seatid(input)
    8 * _decode_binary(@view(input[begin:7]), 'B') + _decode_binary(@view(input[8:end]), 'R')
end

function solve1(inputs)
    maximum(seatid, inputs)
end

function solve2(inputs)
    sorted = sort!(map(seatid, inputs))
    for (a, b) in @views zip(sorted[1:end-1], sorted[2:end])
        if b - a != 1
            return a + 1
        end
    end
    throw(error("No gap found"))
end


println(solve1(inputs))
println(solve2(inputs))
