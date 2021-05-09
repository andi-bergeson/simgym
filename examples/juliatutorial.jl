### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 876e6928-abdc-11eb-0fea-d51de2d4b971
md""" ### Quick Julia tutorial...
"""

# ╔═╡ 9e95da34-fc21-4e7e-99a9-aea83edacd19
# global variable
example = 9.5

# ╔═╡ 34282b28-b73f-4aa7-96be-31dd6700084f
areaofcircle(r) = pi * r^2

# ╔═╡ 451499e9-76d9-4088-af2f-f35a9222afca
#= this updates 
~automatically~
if you change the first cell
(and here's how you do multi-line commenting!) =#

bep = areaofcircle(example)

# ╔═╡ 1a3a323e-3f6b-4d65-bcbe-7c1c98aeb150
md"""
##### Some words on scope...
In Julia, like all other languages, there are globally and locally scoped variables. Locally scoped can be considered hard or soft; difference being that soft local variables unassigned locally and defined globally reassign the global variable, whereas hard scope remains local.

Julia uses lexical scoping, meaning that a function's scope refers to the one in which it was defined. For example, calling the module "Bleep" from a global scope will use the scope independent to Bleep, NOT the caller's global scope:
"""

# ╔═╡ 3f2ba373-77c6-4462-b30b-94fc8602298e
module Bleep
	example = 1
	foo() = example
end

# ╔═╡ 6315a551-f39b-40be-8c84-d3fbf34de4d0
Bleep.foo()

# ╔═╡ fa32bf73-e41a-4db5-ab2a-3e5a9e383aef
md"""
And this new module's independent scope is separate from the caller's global scope:
"""

# ╔═╡ 0cd019ae-3521-4323-9371-020190603204
module Deeee
	beh = example
end

# ╔═╡ 92cfd5a5-09ef-401d-a4a6-53d2576b314f
md"""Also, changing a global variable with a function will result in that variable remaining modified - called 'pass-by-sharing'. Conventionally, these functions will have '!' after their names.
"""

# ╔═╡ 92713261-8080-4797-8e48-0f0c2ce0e391
function changer!(bees)
    bees .+= 1
    return
end

# ╔═╡ 997f3fe0-d920-4055-b81e-b259fce128a3
ty = [1.0,2.0,3.0]

# ╔═╡ b6fa822c-7a55-46fe-b3a3-f191fe3ebd3d
begin
	changer!(ty)
	ty
end

# ╔═╡ 883334fb-f81b-4c24-9527-571a26ce7ce8
md"""
Additionally, if one variable is defined as another, any modification to the new variable will result in the same change in the original.
"""

# ╔═╡ dc423ed7-c9ee-416a-a0b2-a3c1408221cd
begin
	blip = [1,2,3]
	behhh = blip
end

# ╔═╡ b9aab8cc-c738-4f3c-a845-52f5078d1478
behhh[2] = 4

# ╔═╡ 0b04f67a-e413-4c9a-b298-610a294561b8
blip

# ╔═╡ 251313ac-b425-47c5-aae8-d78e5167b052
md"""
Other fun things include binding with a variety of inputs (copied from their sample notebook)... click the eyeball on the left to see the cell!
"""

# ╔═╡ 9f9fb7dd-b0f6-4bb8-b523-6053b5bc39dc
md"""
`zoot = ` $(@bind zoot html"<input type=range min=5 max=35>")

`beef = ` $(@bind beef html"<input type=text >")

`crr = ` $(@bind crr html"<input type=button value='Click'>")

`drrt = ` $(@bind drrt html"<input type=checkbox >")

`efff = ` $(@bind efff html"<select><option value='one'>First</option><option value='two'>Second</option></select>")

`fooop = ` $(@bind fooop html"<input type=color >")

"""

# ╔═╡ b03cc059-d281-4973-a22a-fabeb5de06e0
(zoot, beef, crr, drrt, efff, fooop)

# ╔═╡ c423ec0a-dbf7-4400-99f9-8357ac59edd1
md"""
#### Working with arrays, concatenation, and plotting...
"""

# ╔═╡ d5e187ee-c6b0-4490-80e0-12a47e809d27
begin
	years = collect(2001:2005)
	oranges = [3, 7, 12, 89, 20]
	pears = zeros(5,1)
	apples = rand(1:100, 5)
	bananas = rand(1:100, 5)
end

# ╔═╡ d50d1e34-9ef2-41de-8dac-bb763685fd5f
fruits = hcat(apples, oranges, pears, bananas)

# ╔═╡ 2f248615-aaca-44ce-a0d9-0ac31e12ba52
begin
	using Plots
	plot(years, fruits, layout=(4, 1), legend=false)
end

# ╔═╡ 6658d1dc-aefd-449b-8d81-f2b9f6a6fe3c
sort(fruits, dims=2)

# ╔═╡ 3bc93ea9-0718-47b9-ae4c-d1286641c9f2
all(i->(4<=i<=6), [4,5,6])

# ╔═╡ 28108af6-a838-417b-85a5-5e3fff0ae49b
md"""
#### Fun with structs!

Julia structs do not require inheritance like OOP languages do - of which Julia is not considered to be, due to the fact that you cannot attach a method (a behavior of a function) to a type. Dispatch, or the choice of method, depends on the first argument in OOP, while in Julia, it chooses which of a function's methods to call depending on the types of all the arguments. This is called multiple dispatch, and is the primary differentiator from other languages.

Types can be either system-defined or user-defined, and allow for structs to define a "supertype" which can be called by any number of functions or structs, as follows.

"""

# ╔═╡ cca3129b-8ccb-4747-b75d-cb34f3ff5b23
struct Limbs
	hands :: Float64
	leg :: Integer
end

# ╔═╡ b1ce5d0c-c3f6-411c-8f04-c44854fa89b1
struct boy
	body_parts :: Limbs #declaring body_parts as a Composite Type, defined by Limbs
	# only inner constructors have access to this "new" function
	boy(hands, leg) = new(Limbs(hands, leg))
end

# ╔═╡ 26730fa4-254c-4bef-81e5-39803ebcaa2e
begin
	joseph = boy(2.,1)
	joseph.body_parts.hands
end

# ╔═╡ 921051ca-54dc-4563-a116-0756cca43557
md"""
This will come into play with user-defined type "Cell" that can be acted on by any number of functions.
"""

# ╔═╡ 8a3ee669-bad2-4086-b90a-1744b85dcf76
md"""
##### Differences from other languages that may not be immediately obvious...

https://docs.julialang.org/en/v1/manual/noteworthy-differences/

https://erik-engheim.medium.com/defining-custom-units-in-julia-and-python-513c34a4c971
"""

# ╔═╡ 39d444ec-f84a-4d1b-9ba4-19af636bf3dd


# ╔═╡ Cell order:
# ╟─876e6928-abdc-11eb-0fea-d51de2d4b971
# ╠═9e95da34-fc21-4e7e-99a9-aea83edacd19
# ╠═34282b28-b73f-4aa7-96be-31dd6700084f
# ╠═451499e9-76d9-4088-af2f-f35a9222afca
# ╟─1a3a323e-3f6b-4d65-bcbe-7c1c98aeb150
# ╠═3f2ba373-77c6-4462-b30b-94fc8602298e
# ╠═6315a551-f39b-40be-8c84-d3fbf34de4d0
# ╟─fa32bf73-e41a-4db5-ab2a-3e5a9e383aef
# ╠═0cd019ae-3521-4323-9371-020190603204
# ╟─92cfd5a5-09ef-401d-a4a6-53d2576b314f
# ╠═92713261-8080-4797-8e48-0f0c2ce0e391
# ╠═997f3fe0-d920-4055-b81e-b259fce128a3
# ╠═b6fa822c-7a55-46fe-b3a3-f191fe3ebd3d
# ╟─883334fb-f81b-4c24-9527-571a26ce7ce8
# ╠═dc423ed7-c9ee-416a-a0b2-a3c1408221cd
# ╠═b9aab8cc-c738-4f3c-a845-52f5078d1478
# ╠═0b04f67a-e413-4c9a-b298-610a294561b8
# ╟─251313ac-b425-47c5-aae8-d78e5167b052
# ╟─9f9fb7dd-b0f6-4bb8-b523-6053b5bc39dc
# ╠═b03cc059-d281-4973-a22a-fabeb5de06e0
# ╟─c423ec0a-dbf7-4400-99f9-8357ac59edd1
# ╠═d5e187ee-c6b0-4490-80e0-12a47e809d27
# ╠═d50d1e34-9ef2-41de-8dac-bb763685fd5f
# ╠═6658d1dc-aefd-449b-8d81-f2b9f6a6fe3c
# ╠═2f248615-aaca-44ce-a0d9-0ac31e12ba52
# ╠═3bc93ea9-0718-47b9-ae4c-d1286641c9f2
# ╟─28108af6-a838-417b-85a5-5e3fff0ae49b
# ╠═cca3129b-8ccb-4747-b75d-cb34f3ff5b23
# ╠═b1ce5d0c-c3f6-411c-8f04-c44854fa89b1
# ╠═26730fa4-254c-4bef-81e5-39803ebcaa2e
# ╟─921051ca-54dc-4563-a116-0756cca43557
# ╟─8a3ee669-bad2-4086-b90a-1744b85dcf76
# ╠═39d444ec-f84a-4d1b-9ba4-19af636bf3dd
