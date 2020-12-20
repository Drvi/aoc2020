function get_inputs()
    [7, 12, 1, 0, 16, 2]
end

function get_curr_number(H, last_number)::Int
    v = get(H, last_number, nothing)
    (!isnothing(v)) && (length(v) == 2) && (return (v[2] - v[1]))
    0
end

function update_history!(H, S, curr_number)
    v = get(H, curr_number, nothing)
    if isnothing(v)
        def = get(S, curr_number, nothing)
        if !isnothing(def)
            return H[curr_number] = sizehint!(Int[def], 2)
        else
            return H[curr_number] = sizehint!(Int[], 2)
        end
    end
    v
end

function solve(inputs, rounds)
    S = Dict{Int,Int}()
    H = Dict{Int,Vector{Int}}()
    t = 1
    for num in inputs
        S[num] = t
        t += 1
    end
    curr_number = 0
    last_number = inputs[end]
    @inbounds for t = length(inputs)+1:rounds
        # @show t H curr_number last_number
        curr_number = get_curr_number(H, last_number)
        v = update_history!(H, S, curr_number)
        if length(v) < 2
            push!(v, t)
        else
            v[1] = v[2]
            v[2] = t
        end
        last_number = curr_number
    end
    last_number
end


inputs = get_inputs()
println(solve(inputs, 2020))
println(solve(inputs, 30_000_000))
