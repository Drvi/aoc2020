function solve1()
    open("inputs.txt") do file
        count(readlines(file)) do line
            m = match(r"(?<lo>\d+)-(?<hi>\d+) (?<letter>\w): (?<password>.+)", line)
            (lo, hi) = (parse(Int, m[:lo]), parse(Int, m[:hi]))
            lo <= count(m[:letter], m[:password]) <= hi
        end
    end
end

function solve2()
    open("inputs.txt") do file
        count(readlines(file)) do line
            m = match(r"(?<lo>\d+)-(?<hi>\d+) (?<letter>\w): (?<password>.+)", line)
            (lo, hi) = (parse(Int, m[:lo]), parse(Int, m[:hi]))
            xor(m[:letter] == m[:password][lo:lo], m[:letter] == m[:password][hi:hi])
        end
    end
end


println(solve1())
println(solve2())
