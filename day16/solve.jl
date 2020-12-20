using Base.Iterators: flatten

function get_inputs(path)
    open(path) do file
        fields_str, ticket_str, other_tickets_str = split(read(file, String), r"\n{2}")
        fields = Dict{String,Tuple{UnitRange{Int64},UnitRange{Int64}}}()
        for field_str in split(fields_str, '\n')
            key, val = split(field_str, ": ")
            range1, range2 = map(x -> parse.(Int, x), split.(split(val, " or "), "-"))
            fields[key] = (range1[1]:range1[2], range2[1]:range2[2])
        end
        ticket = map(x -> parse(Int, x), split.(split(ticket_str, '\n')[2], ','))
        other_tickets = map(
            x -> parse.(Int, split(x, ',')),
            split(other_tickets_str, '\n', keepempty = false)[2:end],
        )
        (; fields, ticket, other_tickets)
    end
end

function solve1(inputs)
    valid = Set(flatten(flatten(values(inputs.fields))))
    out = 0
    for other_ticket in inputs.other_tickets
        for val in other_ticket
            if !in(val, valid)
                out += val
            end
        end
    end
    out
end

function solve2(inputs)
    uniques = Dict(k => Set(flatten(v)) for (k, v) in (inputs.fields))
    valid = Set(flatten(values(uniques)))

    int_to_field = Dict{Int,Vector{String}}()
    for i in valid
        for (k, v) in uniques
            if i in v
                push!(get!(int_to_field, i, String[]), k)
            end
        end
    end

    freqs = Dict(k => zeros(Int, length(inputs.ticket)) for k in keys(uniques))
    n_valid = 0
    for other_ticket in inputs.other_tickets
        all(x -> x in valid, other_ticket) || continue
        n_valid += 1
        for (i, val) in enumerate(other_ticket)
            for fieldname in int_to_field[val]
                @inbounds freqs[fieldname][i] += 1
            end
        end
    end

    mapping = Dict{Int, String}()
    for (k, cs) in sort!(collect(freqs), by = x -> sum(x[2]))
        idx = [i for (i, c) in enumerate(cs) if c == n_valid && !(i in keys(mapping))]
        mapping[idx[1]] = k
    end

    prod(inputs.ticket[i] for (i, k) in mapping if startswith(k, "departure"))
end


inputs = get_inputs("inputs.txt")
println(solve1(inputs))
println(solve2(inputs))
