function get_inputs()
    [7, 12, 1, 0, 16, 2]
end

function get_curr_number(H2::Vector{T}, H1, last_number, t) where {T}
    idx = last_number + 1
    @inbounds h2 = H2[idx]
    @inbounds h1 = H1[idx]
    if h2 > 0
        (h2 - h1)
    else
        zero(T)
    end
end

function update_history!(H2, H1, curr_number, t)
    idx = curr_number + 1
    @inbounds begin
        if H1[idx] > 0
            if H2[idx] > 0
                H1[idx], H2[idx] = H2[idx], t
            else
                H2[idx] = t
            end
        else
            H1[idx] = t
        end
    end
    curr_number
end

function solve(inputs, rounds)
    n = max(rounds, maximum(inputs)) + 1
    H1 = zeros(Int32, n)
    H2 = zeros(Int32, n)
    for (t, num) in enumerate(inputs)
        H1[num+1] = t
        t += 1
    end
    last_number = Int32(inputs[end])
    for t = length(inputs)+1:rounds
        last_number = update_history!(H2, H1, get_curr_number(H2, H1, last_number, t), t)
    end
    last_number
end


inputs = get_inputs()
println(solve(inputs, 2020))
println(solve(inputs, 30_000_000))
