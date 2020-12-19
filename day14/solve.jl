function get_inputs(path)
    open(path) do file
        program = read(file, String)
        out = Tuple{String,Vector{Pair{UInt,UInt}}}[]
        for pattern in split(program, "mask = ", keepempty = false)
            mask, assignments... = split(pattern, '\n', keepempty = false)
            p = Pair{UInt,UInt}[]
            for assignment in assignments
                m = match(r"mem\[(?<address>\d+)\] = (?<val>\d+)", assignment)
                push!(p, parse(UInt, m[:address]) => parse(UInt, m[:val]))
            end
            push!(out, (mask, p))
        end
        out
    end
end

function parsemask(mask)
    M = 0
    X = 0
    for (i, c) in enumerate(mask)
        if c == 'X'
            X += 1 << (36 - i)
        elseif c == '1'
            M += 1 << (36 - i)
        end
    end
    (M, X)
end

function solve1(inputs)
    mem = Dict{UInt,UInt}()
    for (mask, assignments) in inputs
        M, X = parsemask(mask)
        for (address, value) in assignments
            mem[address] = M + value & X
        end
    end
    sum(values(mem))
end


function decompose_to_squares(x)
    out = Int[]
    p = 1
    sizehint!(out, 36)
    for i = 0:36
        if ((x >> i) & 1) == 1
            push!(out, p)
        end
        p *= 2
    end
    out
end

function apply_square_subsets!(mem, squares, base_address, value)
    _apply_square_subsets!(mem, squares, base_address, value, true)
    _apply_square_subsets!(mem, squares, base_address, value, false)
end

function _apply_square_subsets!(mem, squares, base_address, value, skip, i = 1, offset = 0)
    if i > length(squares)
        skip && (mem[base_address+offset] = value)
        return
    end
    @inbounds offset = skip ? offset : offset + squares[i]
    _apply_square_subsets!(mem, squares, base_address, value, true, i + 1, offset)
    _apply_square_subsets!(mem, squares, base_address, value, false, i + 1, offset)
end

function solve2(inputs)
    mem = Dict{UInt,UInt}()
    for (mask, assignments) in inputs
        M, X = parsemask(mask)
        invX = xor(X, 68719476735)
        for (address, value) in assignments
            apply_square_subsets!(mem, decompose_to_squares(X), M | (address & invX), value)
        end
    end
    sum(values(mem))
end


inputs = get_inputs("inputs.txt")
println(solve1(inputs))
println(solve2(inputs))
