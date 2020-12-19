function get_inputs(path)
    open(path) do file
        t = parse(Int, readline(file))
        line = readline(file)
        ids = parse.(Int, split(line, r",(x,)*"))
        xs = count.(==('x'), split(line, r",?\d+,?"))[2:end-1] .+ 1
        (;t, ids, xs)
    end
end

function solve1(inputs)
    arrivals = cld.(inputs.t, inputs.ids) .* inputs.ids
    i = argmin(arrivals)
    (arrivals[i] - inputs.t) * inputs.ids[i]
end

function chinese_remainder_theorem(ds, mods)
    N = prod(mods)
    out = 0
    for (d, m) in zip(ds, mods)
        n = div(N, m)
        s = invmod(n, m)
        out += d * s * n
    end
    mod(out, N)
end

function solve2(inputs)
    len = length(inputs.ids)
    distances_to_last = zeros(Int, len)
    for i in len-1:-1:1
        distances_to_last[i] = distances_to_last[i+1] + inputs.xs[i]
    end
    chinese_remainder_theorem(distances_to_last, inputs.ids) - distances_to_last[1]
end


inputs = get_inputs("inputs.txt")
println(solve1(inputs))
println(solve2(inputs))
