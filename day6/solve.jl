inputs = open("inputs.txt") do file
    s = read(file, String)
    groups = split(s, r"\n{2}")
    map(split, groups)
end

function solve1(inputs)
    sum(inputs) do input
        length(mapreduce(Set, union, input))
    end
end

function solve2(inputs)
    sum(inputs) do input
        length(mapreduce(Set, intersect, input))
    end
end


println(solve1(inputs))
println(solve2(inputs))
