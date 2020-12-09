M = vcat(open("inputs.txt") do file
    map(readlines(file)) do line
        (collect(line) .== '#')'
    end
end...)

function solve(M, down, right)
    trees = 0
    j = 1
    @inbounds for i = 1:down:size(M, 1)
        trees += M[i, j]
        j = mod1(j + right, size(M, 2))
    end
    trees
end


println(solve(M, 1, 3))
println(solve(M, 1, 1) * solve(M, 1, 3) * solve(M, 1, 5) * solve(M, 1, 7) * solve(M, 2, 1))
