function get_inputs(path)
    vcat(open(path) do file
        map(readlines(file)) do line
            Int8.(collect(line) .== '#')'
        end
    end...)
end

function _advance!(O, M, active_ranges)
    @inbounds for i = active_ranges[1]
          for j = active_ranges[2]
             for k in active_ranges[3]
                o = M[i-1, j-1, k-1] + M[i-1, j, k-1] + M[i-1, j+1, k-1] +
                    M[i,   j-1, k-1] + M[i,   j, k-1] + M[i,   j+1, k-1] +
                    M[i+1, j-1, k-1] + M[i+1, j, k-1] + M[i+1, j+1, k-1] +

                    M[i-1, j-1, k  ] + M[i-1, j, k  ] + M[i-1, j+1, k  ] +
                    M[i,   j-1, k  ]          +         M[i,   j+1, k  ] +
                    M[i+1, j-1, k  ] + M[i+1, j, k  ] + M[i+1, j+1, k  ] +

                    M[i-1, j-1, k+1] + M[i-1, j, k+1] + M[i-1, j+1, k+1] +
                    M[i,   j-1, k+1] + M[i,   j, k+1] + M[i,   j+1, k+1] +
                    M[i+1, j-1, k+1] + M[i+1, j, k+1] + M[i+1, j+1, k+1]
                if M[i, j, k] == 1  # active
                    if !(2 <= o <= 3)
                        O[i, j, k] = 0
                    end
                else  # inactive
                    if o == 3
                        O[i, j, k] = 1
                    end
                end
            end
        end
    end
end

function solve1(inputs)
    iters = 6
    m, n = size(inputs)
    x, y = size(inputs) .+ 2*iters .+ 3
    z = 2*iters + 5
    M = zeros(Int8, x, y, z)
    active_range1 = div(x - m, 2) .+ (1:m)
    active_range2 = div(y - n, 2) .+ (1:n)
    active_range3 = div(z, 2):div(z, 2)
    M[active_range1, active_range2, active_range3] .= inputs
    O = copy(M)

    for _ in 1:iters
        active_range1 = (first(active_range1)-1):(last(active_range1)+1)
        active_range2 = (first(active_range2)-1):(last(active_range2)+1)
        active_range3 = (first(active_range3)-1):(last(active_range3)+1)
        _advance!(O, M, (active_range1, active_range2, active_range3))
        copyto!(M, O)
    end
    count(==(1), O)
end

function _advance!(O::Array{T,4}, M, active_ranges) where {T}
    @inbounds for i in active_ranges[1]
          for j in active_ranges[2]
             for k in active_ranges[3]
                 o = 0
                 for l in active_ranges[3]
                     o = 0
                     for f in -1:1
                        o += M[i-1, j-1, k-1, l+f] + M[i-1, j, k-1, l+f] + M[i-1, j+1, k-1, l+f] +
                             M[i,   j-1, k-1, l+f] + M[i,   j, k-1, l+f] + M[i,   j+1, k-1, l+f] +
                             M[i+1, j-1, k-1, l+f] + M[i+1, j, k-1, l+f] + M[i+1, j+1, k-1, l+f] +

                             M[i-1, j-1, k,   l+f] + M[i-1, j, k,   l+f] + M[i-1, j+1, k,   l+f] +
                             M[i,   j-1, k,   l+f] + M[i,   j, k,   l+f] + M[i,   j+1, k,   l+f] +
                             M[i+1, j-1, k,   l+f] + M[i+1, j, k,   l+f] + M[i+1, j+1, k,   l+f] +

                             M[i-1, j-1, k+1, l+f] + M[i-1, j, k+1, l+f] + M[i-1, j+1, k+1, l+f] +
                             M[i,   j-1, k+1, l+f] + M[i,   j, k+1, l+f] + M[i,   j+1, k+1, l+f] +
                             M[i+1, j-1, k+1, l+f] + M[i+1, j, k+1, l+f] + M[i+1, j+1, k+1, l+f]
                    end
                    middle = M[i, j, k, l]
                    o -= M[i, j, k, l]
                    if middle == 1  # active
                        if !(2 <= o <= 3)
                            O[i, j, k, l] = 0
                        end
                    else  # inactive
                        if o == 3
                            O[i, j, k, l] = 1
                        end
                    end
                end
            end
        end
    end
end

function solve2(inputs)
    iters = 6
    m, n = size(inputs)
    x, y = size(inputs) .+ 2*iters .+ 3
    z = 2*iters + 5
    M = zeros(Int8, x, y, z, z)
    active_range1 = div(x - m, 2) .+ (1:m)
    active_range2 = div(y - n, 2) .+ (1:n)
    active_range3 = div(z, 2):div(z, 2)
    M[active_range1, active_range2, active_range3, active_range3] .= inputs
    O = copy(M)

    for _ in 1:iters
        active_range1 = (first(active_range1)-1):(last(active_range1)+1)
        active_range2 = (first(active_range2)-1):(last(active_range2)+1)
        active_range3 = (first(active_range3)-1):(last(active_range3)+1)
        _advance!(O, M, (active_range1, active_range2, active_range3))
        copyto!(M, O)
    end
    count(==(1), O)
end


inputs = get_inputs("inputs.txt")
println(solve1(inputs))
println(solve2(inputs))
