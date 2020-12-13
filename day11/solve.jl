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
    @inbounds for i = 3:h-2
          for j = 3:w-2
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
    M = zeros(eltype(inputs), h + 4, w + 4)
    M[3:h+2, 3:w+2] .= inputs
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
    while 1 <= i <= m && 1 <= j <= n
        inputs[i, j] != 0 && (return (i, j))
        i += di
        j += dj
    end
end

function create_index(inputs::Matrix{T}) where {T}
    directions = NTuple{8,Tuple{T,T}}(
        ((0, 1), (1, 0), (-1, 0), (0, -1), (1, 1), (-1, -1), (-1, 1), (1, -1))
    )
    m, n = size(inputs)
    zero_coord = let f = findfirst(==(0), inputs)
        f[1] + (f[2] - 1) * m
    end

    visible_neighbors = -ones(T, n * m, 9)
    visible_neighbors[:, 5] .= T(8)
    @inbounds for i = 1:m
        for j = 1:n
            linear_index = T(i + (j - 1) * m)
            x = inputs[i, j]
            neighbor_buffer = @view visible_neighbors[linear_index, :]
            if (x == 0 || neighbor_buffer[5] == 0)
                zero_coord = i + (j - 1) * m
                continue
            end
            for (di, dj) in directions
                rel_idx = 2 + di + (1 + dj) * 3
                neighbor_buffer[rel_idx] != -1 && continue
                other_loc = _serchdirected((i, j), (di, dj), inputs)
                neighbor_buffer[5] -= 1
                if !isnothing(other_loc)
                    I, J = other_loc
                    other_linear_index = T(I + (J - 1) * m)
                    neighbor_buffer[rel_idx] = other_linear_index
                    other_buffer = @view visible_neighbors[other_linear_index, :]
                    other_buffer[2-di+(1-dj)*3] = linear_index
                    other_buffer[5] -= 1
                else
                    neighbor_buffer[rel_idx] = zero_coord
                end
            end
        end
    end
    cnt_available = count(!iszero, inputs)
    out = Vector{SeatPosition{T}}(undef, cnt_available)
    j = 1
    @inbounds for i = 1:m*n
        inputs[i] == 0 && continue
        lc = @view visible_neighbors[i, :]
        out[j] = SeatPosition(T(i), lc[[1, 2, 3, 4, 6, 7, 8, 9]])
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
