### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ a55cdb1e-7817-11eb-24a9-ed2c2a6c4d34
# import necessary packages
using Plots, LinearAlgebra, Statistics

# ╔═╡ 14e5f99c-7814-11eb-0b4d-81c01d3d0c66
md""" ### Quick Julia tutorial...
"""

# ╔═╡ 0e9d8542-7813-11eb-1055-2ba3acfbbb5c
# global variable
aaa = 9.5

# ╔═╡ 60e99354-7813-11eb-3df6-ada85aae7a37
areaofcircle(r) = pi * r^2

# ╔═╡ 61fa4bbc-7813-11eb-0586-81dd09dcbe4e
# this updates **automatically** if you change the first cell
bep = areaofcircle(aaa)

# ╔═╡ f96cf846-7813-11eb-2f52-b900164fa0fd
md"""
##### Some words on scope...
In Julia, like all other languages, there are globally and locally scoped variables. Locally scoped can be considered hard or soft; difference being that soft local variables unassigned locally and defined globally reassign the global variable, whereas hard scope remains local.

Julia uses lexical scoping, meaning that a function's scope refers to the one in which it was defined. For example, calling "bleep" from a global scope is different from bleep's used scope:
"""

# ╔═╡ d1cd8d70-7816-11eb-1e8c-d91ecd9f3b34
module Bleep
	aaa = 1
	foo() = aaa
end

# ╔═╡ d29bb4d4-7816-11eb-17fe-15b22dbb8669
Bleep.foo()

# ╔═╡ 5711ca0a-7817-11eb-35a8-c75d3d15ee9e
md"""
And Deeee's global scope is separate from the caller's global scope:
"""

# ╔═╡ d385044a-7816-11eb-1f29-d110b7db73de
module Deeee
	beh = aaa
end

# ╔═╡ f24afac8-7821-11eb-20db-030a761fc5dc
md"""Also, changing a global variable with a function will result in that variable remaining modified - called 'pass-by-sharing'. Conventionally, these functions will have '!' after their names.
"""

# ╔═╡ 5770cb76-7822-11eb-3048-e9bf049f1113
function changer!(bees)
    bees .+= 1
    return
end

# ╔═╡ 5739cd2e-7822-11eb-0366-c5e56c1bf97e
ty = [1.0,2.0,3.0]

# ╔═╡ 56f7e7b0-7822-11eb-1307-7771b2a42189
changer!(ty)

# ╔═╡ 7a28e450-7822-11eb-31fd-139081d8f0ae
ty

# ╔═╡ 8b323d4a-7bed-11eb-3957-6f2f297d5e2a
md"""
###### Observe the difference between the following cells:
"""

# ╔═╡ a3851a20-7bed-11eb-2ebb-f549306380af
begin
	zip = [3,3]
	zop = [4,4]
end

# ╔═╡ a334c822-7bed-11eb-3a50-0b86390f9d9c
begin
	rip = [0,0]
	rip .= zip
	zip .= zop
	zop .= rip
end

# ╔═╡ 40f83caa-7bef-11eb-0b3c-3f3caa3f02a5
zip

# ╔═╡ 44a25458-7bef-11eb-0c7b-d5b378b0f6fa
zop

# ╔═╡ 59fb2584-7bef-11eb-2670-27158cbeec69
begin
	blip = [1,2,3]
	behhh = blip
end

# ╔═╡ 59cb6478-7bef-11eb-0109-fb0b6674a60c
behhh[2] = 4

# ╔═╡ 5979bc54-7bef-11eb-2a1b-a5527bed5f92
blip

# ╔═╡ 595c679e-7bef-11eb-1568-151849a773fe


# ╔═╡ a64c8748-7817-11eb-2a42-892fc3a72491
md"""
Other fun things include binding with a variety of inputs (copied from their sample notebook)...
"""

# ╔═╡ a633a61c-7817-11eb-1178-5bda8a9987b4
md"""
`zoot = ` $(@bind zoot html"<input type=range min=5 max=35>")

`beef = ` $(@bind beef html"<input type=text >")

`crr = ` $(@bind crr html"<input type=button value='Click'>")

`drrt = ` $(@bind drrt html"<input type=checkbox >")

`efff = ` $(@bind efff html"<select><option value='one'>First</option><option value='two'>Second</option></select>")

`fooop = ` $(@bind fooop html"<input type=color >")

"""

# ╔═╡ a5ff4c82-7817-11eb-3263-1df67acc3a16
(zoot, beef, crr, drrt, efff, fooop)

# ╔═╡ a5e3feaa-7817-11eb-2baf-adbc7d42fd08
md"""
#### Working with arrays, concatenation, and plotting...
"""

# ╔═╡ a06ddb20-781b-11eb-00ef-0908eeeba6fc
begin
	years = collect(2001:2005)
	oranges = [3, 7, 12, 89, 20]
	pears = zeros(5,1)
	apples = rand(1:100, 5)
	bananas = rand(1:100, 5)
end

# ╔═╡ a0253856-781b-11eb-0ac3-3b7dcc9f11b1
fruits = hcat(apples, oranges, pears, bananas)

# ╔═╡ 749d7ee6-781e-11eb-36d1-3189d619d478
sort(fruits, dims=2)

# ╔═╡ 9fcf36f2-781b-11eb-2e17-d9aaee3222cc
plot(years, fruits, layout=(4, 1), legend=false)

# ╔═╡ 9f1c1f40-781b-11eb-024c-a3e7a6adab25
collect(1:3:15)

# ╔═╡ f0ba15bc-781a-11eb-3c35-ff4c9969aac3
all(i->(4<=i<=6), [4,5,6])

# ╔═╡ 39556e5e-7b02-11eb-2915-1bd43f4e8cdd


# ╔═╡ 0d3a1b8e-7b01-11eb-3e0f-5b454d05e4d5
md"""
#### Fun with structs!

Julia structs do not require inheritance like OOP languages do (of which Julia is not considered to be, due to the fact that you cannot attach 

"""

# ╔═╡ 0e6ddf9a-7b01-11eb-2188-85c9743f0513
struct limbs
	hands :: Float64
	leg :: Integer
end

# ╔═╡ 0f1fa900-7b01-11eb-12ad-e723b2f4c83b
struct boy
	#body_parts :: limbs
	boy(hands, leg) = new(limbs(hands, leg))
end

# ╔═╡ 2b4f0494-7b02-11eb-0ef3-15e5db3ec568
begin
	joseph = boy(2.,1)
	joseph.body_parts.hands
end

# ╔═╡ 2a7e876a-7b02-11eb-153c-4914b1e0d341


# ╔═╡ 0fc4da60-7b01-11eb-16dd-9530cca12ed0
md"""
##### Differences from other languages that may not be immediately obvious...

https://docs.julialang.org/en/v1/manual/noteworthy-differences/

Julia arrays are not copied when assigned to another variable. After A = B, changing elements of B will modify A as well.

Built-in multiple dispatch

https://erik-engheim.medium.com/defining-custom-units-in-julia-and-python-513c34a4c971
"""

# ╔═╡ 3a54c6d0-7b03-11eb-01db-1f76c367035a


# ╔═╡ 39ece420-7b03-11eb-0fe3-b3baaf74aa93


# ╔═╡ 39697630-7b03-11eb-19e1-9fd4ca6209f5


# ╔═╡ 4400d1bc-781d-11eb-2c1b-67d229778938
md"""
### Now let's collide some Things...
"""

# ╔═╡ 8f05c7e2-781f-11eb-3546-fb5d1dd7e17d


# ╔═╡ ebe9176e-5f76-11eb-1c02-e122c6af0b66
begin
	# builds the constructor which will organize cell features
	# eventually there will be spherocylindrical features
	
	struct Cell
		
		p::Vector #position of the central point of the cell
		
		v::Vector #velocity
		
		w::Vector #angular velocity
		
		#l::Float64 #length of the cylindrical element of the cell
		
		#r::Float64 #radius of the semi-circle at each end of the cylinder
		
		#orient::Int #orientation, [0:180], of line segment of cell center +/- portion of length with respect to vertical axis of photo
		
		#curv:: #probability of deviation from orientation at each line segment
		
	end
	
	# Outer contructor
	Cell(p::Vector, v::Vector) = Cell(p, v, [0.1,0.1])
end

# ╔═╡ af75dbdc-7867-11eb-31a2-7b9dd3679b8b
md"""Using $v_{1} = v_{0} + a\Delta t$ and 
$x_{1} = x_{0} + v\Delta t - \frac{1}{2}a\Delta t^{2}$,
"""

# ╔═╡ cfd5dee2-6000-11eb-1305-5985de7b450f
function updatepos!(c::Cell, dt, deccel)
	
	"""
	A function which uses Newtonian dynamics to update position & velocity
	vectors according to viscious drag, 'deccel'
	"""
	
	c.p .+= c.v .* dt .- (1/2)*deccel*dt^2
	
	if c.v[1] <= 0
		c.v[1] += deccel*dt
	elseif c.v[1] >= 0
		c.v[1] -= deccel*dt
	else
		nothing
	end
	
	if c.v[2] <= 0
		c.v[2] += deccel*dt
	elseif c.v[2] >= 0
		c.v[2] -= deccel*dt
	else
		nothing
	end
end

# ╔═╡ c83729e4-7bde-11eb-3b68-43f4860a75b3
function growndivide!(c::Cell, dt, lmax, mu)
	
	"""
	Modifies cell's length according to growth rate mu.
	Divides the cell when it reaches maximum length lmax,
	and creates a new cell.
	"""
	
	# Monod Equation:
	# mu = mumax * limiting_substrate / (limiting_substrate * halfv_const)
	# c.l += (mu * limiting_substrate * dt)
	
	# Simple First-Order
	#g = stats stuff, mean=mu, variance=sqrt(mu)
	#c.l += g * dt
	
	if c.l > lmax
		new_x1 = c.p[1] + .25*lmax*cos(c.orient)
		new_y1 = c.p[2] + .25*lmax*sin(c.orient)
		newcell = Cell([new_x1,new_y1],(-1).*c.v) #match orientation, change l
		
		c.p[1] -= .25*lmax*cos(c.orient)
		c.p[2] -= .25*lmax*sin(c.orient)
		c.l .= startingl
	else
		nothing
	end
end

# ╔═╡ b7fd1100-786a-11eb-1479-9f90a62171a8
md"""Because masses are assumed to be equal and we are ignoring cases where cells stick together (aka inelastic collision), we can use basic position updating, while using impulse due to normal force for velocity updating.
"""

# ╔═╡ f5ffedaa-7a00-11eb-1565-c51d05ef2afe
function elastic!(c1::Cell, c2::Cell, r)#, dt, deccel)
	
	"""
	
	"""
	
	if abs(c1.p[1] - c2.p[1]) <= r && abs(c1.p[2] - c2.p[2]) <= r
		tmp = zeros(size(c1.v))
		tmp .= c1.v
		c1.v .= c2.v
		c2.v .= tmp
	end
	
	#J1 = (c2.v .- c1.v) .* (c2.p .- c1.p)
	#J2 = (c1.v .- c2.v) .* (c1.p .- c2.p)
	
	#c1.v .+= ((c2.p .- c1.p) ./ r) .* J1
	#c2.v .+= ((c1.p .- c2.p) ./ r) .* J2
	
	#c1.p .+= c1.v.*dt .- (1/2)*deccel*dt^2
	#c2.p .+= c2.v.*dt .- (1/2)*deccel*dt^2
	return
end

# ╔═╡ 7148a0c4-6002-11eb-3163-6399f84c4e80
begin
	
	
	a = Cell([.1,.4],[.05,-.08])
	b = Cell([.5,-.1],[-.05,.02])
	c = Cell([.3,.2],[-.06,.03])
	d = Cell([-.3,-.2],[.05,.05])
	e = Cell([-.1,-.3],[-.02,-.04])
end

# ╔═╡ 1a352326-7a00-11eb-2dc8-8529933d1352
begin
	cellarray = Float64[x for x in collect(1:10)]
end

# ╔═╡ 12e53446-7828-11eb-390e-fb09926ba58a
function plot_cells()
	myplot = scatter([a.p[1]], [a.p[2]], xlims=(-.5,.6),ylims=(-.6,.6), label="cella")
	scatter!([b.p[1]], [b.p[2]], label="cellb")
	scatter!([c.p[1]], [c.p[2]], label="cellc")
	scatter!([d.p[1]], [d.p[2]], label="celld")
	scatter!([e.p[1]], [e.p[2]], label="celle")
	return myplot
end

# ╔═╡ a33a838a-7811-11eb-334d-8d069faac8cb
@bind t html"<input type=range min=1 max=80>"

# ╔═╡ 33cd3d70-7828-11eb-3814-0d24b6f35c08
begin
	anim = @animate for i=0:t
		
		# timestep
		dt = 0.2
		# min distance before collision
		r = 0.05
		# decceleration constant
		drag = 0.01
		
		cs = Cell[a,b,c,d,e]
		updatepos!.(cs, dt, drag)
		
		#collision stuff
		elastic!(a,b,r)
		elastic!(a,c,r)
		elastic!(a,d,r)
		elastic!(a,e,r)
		elastic!(b,c,r)
		elastic!(b,d,r)
		elastic!(b,e,r)
		elastic!(c,d,r)
		elastic!(c,e,r)
		elastic!(d,e,r)
		
		#plot it!
		plot_cells()
	end
	gif(anim, fps = 10)
end

# ╔═╡ 09980640-7819-11eb-2520-15099bf4c1b1
t

# ╔═╡ 0bc8c7fe-7819-11eb-31ac-43184a232bcb


# ╔═╡ 21a39a84-7a14-11eb-32f9-5f49b4469ad8


# ╔═╡ 5c84d70c-7a15-11eb-0c37-7dfc0b335c76


# ╔═╡ 006059e6-7a16-11eb-3ab3-3d057421d9bf


# ╔═╡ befd9e10-7a14-11eb-269d-75f8b0293fb4


# ╔═╡ Cell order:
# ╟─14e5f99c-7814-11eb-0b4d-81c01d3d0c66
# ╠═0e9d8542-7813-11eb-1055-2ba3acfbbb5c
# ╠═60e99354-7813-11eb-3df6-ada85aae7a37
# ╠═61fa4bbc-7813-11eb-0586-81dd09dcbe4e
# ╟─f96cf846-7813-11eb-2f52-b900164fa0fd
# ╠═d1cd8d70-7816-11eb-1e8c-d91ecd9f3b34
# ╠═d29bb4d4-7816-11eb-17fe-15b22dbb8669
# ╟─5711ca0a-7817-11eb-35a8-c75d3d15ee9e
# ╠═d385044a-7816-11eb-1f29-d110b7db73de
# ╟─f24afac8-7821-11eb-20db-030a761fc5dc
# ╠═5770cb76-7822-11eb-3048-e9bf049f1113
# ╠═5739cd2e-7822-11eb-0366-c5e56c1bf97e
# ╠═56f7e7b0-7822-11eb-1307-7771b2a42189
# ╠═7a28e450-7822-11eb-31fd-139081d8f0ae
# ╟─8b323d4a-7bed-11eb-3957-6f2f297d5e2a
# ╠═a3851a20-7bed-11eb-2ebb-f549306380af
# ╠═a334c822-7bed-11eb-3a50-0b86390f9d9c
# ╠═40f83caa-7bef-11eb-0b3c-3f3caa3f02a5
# ╠═44a25458-7bef-11eb-0c7b-d5b378b0f6fa
# ╠═59fb2584-7bef-11eb-2670-27158cbeec69
# ╠═59cb6478-7bef-11eb-0109-fb0b6674a60c
# ╠═5979bc54-7bef-11eb-2a1b-a5527bed5f92
# ╠═595c679e-7bef-11eb-1568-151849a773fe
# ╟─a64c8748-7817-11eb-2a42-892fc3a72491
# ╟─a633a61c-7817-11eb-1178-5bda8a9987b4
# ╠═a5ff4c82-7817-11eb-3263-1df67acc3a16
# ╟─a5e3feaa-7817-11eb-2baf-adbc7d42fd08
# ╠═a06ddb20-781b-11eb-00ef-0908eeeba6fc
# ╠═a0253856-781b-11eb-0ac3-3b7dcc9f11b1
# ╠═749d7ee6-781e-11eb-36d1-3189d619d478
# ╠═9fcf36f2-781b-11eb-2e17-d9aaee3222cc
# ╠═9f1c1f40-781b-11eb-024c-a3e7a6adab25
# ╠═f0ba15bc-781a-11eb-3c35-ff4c9969aac3
# ╠═39556e5e-7b02-11eb-2915-1bd43f4e8cdd
# ╠═0d3a1b8e-7b01-11eb-3e0f-5b454d05e4d5
# ╠═0e6ddf9a-7b01-11eb-2188-85c9743f0513
# ╠═0f1fa900-7b01-11eb-12ad-e723b2f4c83b
# ╠═2b4f0494-7b02-11eb-0ef3-15e5db3ec568
# ╠═2a7e876a-7b02-11eb-153c-4914b1e0d341
# ╠═0fc4da60-7b01-11eb-16dd-9530cca12ed0
# ╠═3a54c6d0-7b03-11eb-01db-1f76c367035a
# ╠═39ece420-7b03-11eb-0fe3-b3baaf74aa93
# ╠═39697630-7b03-11eb-19e1-9fd4ca6209f5
# ╟─4400d1bc-781d-11eb-2c1b-67d229778938
# ╠═a55cdb1e-7817-11eb-24a9-ed2c2a6c4d34
# ╠═8f05c7e2-781f-11eb-3546-fb5d1dd7e17d
# ╠═ebe9176e-5f76-11eb-1c02-e122c6af0b66
# ╟─af75dbdc-7867-11eb-31a2-7b9dd3679b8b
# ╠═cfd5dee2-6000-11eb-1305-5985de7b450f
# ╠═c83729e4-7bde-11eb-3b68-43f4860a75b3
# ╟─b7fd1100-786a-11eb-1479-9f90a62171a8
# ╠═f5ffedaa-7a00-11eb-1565-c51d05ef2afe
# ╠═7148a0c4-6002-11eb-3163-6399f84c4e80
# ╠═1a352326-7a00-11eb-2dc8-8529933d1352
# ╠═12e53446-7828-11eb-390e-fb09926ba58a
# ╠═33cd3d70-7828-11eb-3814-0d24b6f35c08
# ╠═a33a838a-7811-11eb-334d-8d069faac8cb
# ╠═09980640-7819-11eb-2520-15099bf4c1b1
# ╠═0bc8c7fe-7819-11eb-31ac-43184a232bcb
# ╠═21a39a84-7a14-11eb-32f9-5f49b4469ad8
# ╠═5c84d70c-7a15-11eb-0c37-7dfc0b335c76
# ╠═006059e6-7a16-11eb-3ab3-3d057421d9bf
# ╠═befd9e10-7a14-11eb-269d-75f8b0293fb4
