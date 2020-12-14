function get_inputs(path)
    vcat(open(path) do file
        map(readlines(file)) do line
            Int32.((collect(line) .== 'L')')
        end
    end...)
end


## 1
function _advance!(O, M)
    h, w = size(M)
    any_changed = false
    @inbounds for i = 2:h-1
          for j = 2:w-1
            x = M[i, j]
            x == 0 && continue
            o = (M[i-1, j-1] == 1) + (M[i-1, j] == 1) + (M[i-1, j+1] == 1) +
                (M[i,   j-1] == 1) +                    (M[i,   j+1] == 1) +
                (M[i+1, j-1] == 1) + (M[i+1, j] == 1) + (M[i+1, j+1] == 1)
            if x == 2  # free
                if o == 0
                    O[i, j] = 1
                    any_changed = true
                end
            else  # occupied
                if o >= 4
                    O[i, j] = 2
                    any_changed = true
                end
            end
        end
    end
    any_changed
end

function solve1(inputs)
    h, w = size(inputs)
    M = zeros(eltype(inputs), h + 2, w + 2)
    M[2:h+1, 2:w+1] .= inputs
    O = copy(M)
    while _advance!(O, M)
        copyto!(M, O)
    end
    count(==(1), O)
end

## 2
struct SeatPosition{T}
    coord::T
    visible_neighbors::Vector{T}
end

function _serchdirected(start, direction, inputs)
    m, n = size(inputs)
    di, dj = direction
    i, j = start .+ direction
    @inbounds while 1 <= i <= m && 1 <= j <= n
        inputs[i, j] != 0 && (return (i + (j - 1) * m))
        i += di
        j += dj
    end
end

function create_index(inputs::Matrix{T}) where {T}
    directions = ((-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1))
    m, n = size(inputs)
    cnt_available = m * n
    zero_index = let f = findfirst(==(0), inputs)
        f[1] + (f[2] - 1) * m
    end

    visible_neighbors = -ones(T, 8, n * m)
    @inbounds for i = 1:m
        for j = 1:n
            curr_index = T(i + (j - 1) * m)
            if inputs[curr_index] == 0
                cnt_available -= 1
                zero_index = curr_index
                continue
            end
            curr_buffer = @view visible_neighbors[:, curr_index]
            for (k, d) in enumerate(directions)
                curr_buffer[k] != -1 && continue
                neighbor_index = _serchdirected((i, j), d, inputs)
                if !isnothing(neighbor_index)
                    curr_buffer[k] = T(neighbor_index)
                    neighbor_buffer = @view visible_neighbors[:, neighbor_index]
                    neighbor_buffer[9-k] = curr_index
                else
                    curr_buffer[k] = zero_index
                end
            end
        end
    end

    out = Vector{SeatPosition{T}}(undef, cnt_available)
    j = 1
    @inbounds for i = 1:m*n
        inputs[i] == 0 && continue
        out[j] = SeatPosition(T(i), visible_neighbors[:, i])
        j += 1
    end
    out
end

function _advance!(O::Matrix{T}, M::Matrix{T}, index::Vector{SeatPosition{T}}) where {T}
    any_changed = false
    @inbounds for position_info in index
        i = position_info.coord
        idxs = position_info.visible_neighbors
        o = (M[idxs[1]] == 1) + (M[idxs[2]] == 1) + (M[idxs[3]] == 1) + (M[idxs[4]] == 1) +
            (M[idxs[5]] == 1) + (M[idxs[6]] == 1) + (M[idxs[7]] == 1) + (M[idxs[8]] == 1)
        if M[i] == 2  # free
            if o == 0
                O[i] = 1
                any_changed = true
            end
        else  # occupied
            if o >= 5
                O[i] = 2
                any_changed = true
            end
        end
    end
    any_changed
end

function solve2(inputs)
    M = copy(inputs)
    O = copy(inputs)
    index = create_index(inputs)
    while _advance!(O, M, index)
        copyto!(M, O)
    end
    count(==(1), O)
end


inputs = get_inputs("inputs.txt")
println(solve1(inputs))
println(solve2(inputs))
