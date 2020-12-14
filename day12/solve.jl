function get_inputs(path)
    open(path) do file
        map(readlines(file)) do line
            (line[1], parse(Int, line[2:end]))
        end
    end
end

function solve1(inputs)
    directions = ((0, 1), (-1, 0), (0, -1), (1, 0))
    k = 1
    north, east = 0, 0
    di, dj = 0, 1
    @inbounds for (d, n) in inputs
        if d == 'N'
            north += n
        elseif d == 'S'
            north -= n
        elseif d == 'E'
            east += n
        elseif d == 'W'
            east -= n
        elseif d == 'L'
            k = mod1(k - div(n, 90), 4)
            di, dj = directions[k]
        elseif d == 'R'
            k = mod1(k + div(n, 90), 4)
            di, dj = directions[k]
        elseif d == 'F'
            north += n * di
            east += n * dj
        end
    end
    abs(north) + abs(east)
end

function solve2(inputs)
    ship_north, ship_east = 0, 0
    waypoint_north, waypoint_east = 1, 10
    @inbounds for (d, n) in inputs
        if d == 'N'
            waypoint_north += n
        elseif d == 'S'
            waypoint_north -= n
        elseif d == 'E'
            waypoint_east += n
        elseif d == 'W'
            waypoint_east -= n
        elseif d == 'L'
            for _ = 1:div(n, 90)
                waypoint_north, waypoint_east = waypoint_east, -waypoint_north
            end
        elseif d == 'R'
            for _ = 1:div(n, 90)
                waypoint_north, waypoint_east = -waypoint_east, waypoint_north
            end
        elseif d == 'F'
            ship_north += n * waypoint_north
            ship_east += n * waypoint_east
        end
    end
    abs(ship_north) + abs(ship_east)
end


inputs = get_inputs("inputs.txt")
println(solve1(inputs))
println(solve2(inputs))
