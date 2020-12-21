get_inputs(path) = open(readlines, path)

(x ⊕ y) = x * y
(x ⟰ y) = x + y

solve1(inputs) = sum(x->eval(Meta.parse(replace(x, "*" => "⊕"))), inputs)
solve2(inputs) = sum(x->eval(Meta.parse(replace(x, "+" => "⟰"))), inputs)


inputs = get_inputs("inputs.txt")
println(solve1(inputs))
println(solve2(inputs))
