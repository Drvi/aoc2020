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
    @inbounds while 1 <= i <= m && 1 <= j <= n
        inputs[i, j] != 0 && (return (i + (j - 1) * m))
        i += di
        j += dj
    end
end

function create_index(inputs::Matrix{T}) where {T}
    directions = (
        ((-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1))
    )
    m, n = size(inputs)
    zero_index = let f = findfirst(==(0), inputs)
        f[1] + (f[2] - 1) * m
    end

    visible_neighbors = -ones(T, 8, n * m)
    @inbounds for i = 1:m
        for j = 1:n
            linear_index = T(i + (j - 1) * m)
            if inputs[linear_index] == 0
                zero_index = linear_index
                continue
            end
            neighbor_buffer = @view visible_neighbors[:, linear_index]
            for (k, d) in enumerate(directions)
                neighbor_buffer[k] != -1 && continue
                other_linear_index = _serchdirected((i, j), d, inputs)
                if !isnothing(other_linear_index)
                    neighbor_buffer[k] = T(other_linear_index)
                    other_buffer = @view visible_neighbors[:, other_linear_index]
                    other_buffer[9-k] = linear_index
                else
                    neighbor_buffer[k] = zero_index
                end
            end
        end
    end
    cnt_available = count(!iszero, inputs)
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
