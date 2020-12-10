inputs = open("inputs.txt") do file
    parse.(Int, readlines(file))
end

function solve1(inputs)
    inputs = sort(inputs)
    prev_x = 0
    buf = zeros(Int, 3)
    @inbounds for x in inputs
        buf[x-prev_x] += 1
        prev_x = x
    end
    buf[1] * (buf[3] + 1)
end

function _ways!(D, i)
    get!(D, i) do
        _ways!(D, i - 1) + _ways!(D, i - 2) + _ways!(D, i - 3)
    end
end

# TODO(drvi): handle cases when difference is 2, now only 1 and 3 are handled
function solve2(inputs)
    inputs = sort(inputs)
    prev_x = 0
    streak = 0
    out = 1
    # length of streak of diffs of size 1 => number of valid connections
    D = Dict(i => 2^(i - 1) for i = 1:3)
    D[0] = 1
    for x in inputs
        d = x - prev_x
        streak += d == 1
        if d == 3 && streak != 0
            out *= _ways!(D, streak)
            streak = 0
        end
        prev_x = x
    end
    out * _ways!(D, streak)
end


println(solve1(inputs))
println(solve2(inputs))
