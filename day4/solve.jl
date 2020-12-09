const MANDATORY_FIELDS = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
inputs = open("inputs.txt") do file
    map(split(read(file, String), r"\n{2}")) do passport_string
        fields = map(split(chomp(passport_string), r"\s+")) do field
            (k, v) = split(field, ":")
            k => v
        end
        Dict(fields)
    end
end

function solve1(inputs)
    count(inputs) do D
        isempty(setdiff(MANDATORY_FIELDS, keys(D)))
    end
end

function solve2(inputs)
    count(inputs) do D
        isempty(setdiff(MANDATORY_FIELDS, keys(D))) && begin
            hgt = match(r"^(?<height>\d+)(?<units>in|cm)$", D["hgt"])

            1920 <= parse(Int, D["byr"]) <= 2002 &&
                2010 <= parse(Int, D["iyr"]) <= 2020 &&
                2020 <= parse(Int, D["eyr"]) <= 2030 &&
                !isnothing(hgt) &&
                (
                    (hgt[:units] == "cm" && 150 <= parse(Int, hgt[:height]) <= 193) ||
                    (hgt[:units] == "in" && 59 <= parse(Int, hgt[:height]) <= 76)
                ) &&
                !isnothing(match(r"^\#[0-9a-z]{6}$", D["hcl"])) &&
                !isnothing(match(r"^(amb|blu|brn|gry|grn|hzl|oth)$", D["ecl"])) &&
                !isnothing(match(r"^\d{9}$", D["pid"]))
        end
    end
end


println(solve1(inputs))
println(solve2(inputs))
