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
using Plots, LinearAlgebra, Statistics, StatsBase

# ╔═╡ 14e5f99c-7814-11eb-0b4d-81c01d3d0c66
md""" ### Quick Julia tutorial...
"""

# ╔═╡ 0e9d8542-7813-11eb-1055-2ba3acfbbb5c
# global variable
example = 9.5

# ╔═╡ 60e99354-7813-11eb-3df6-ada85aae7a37
areaofcircle(r) = pi * r^2

# ╔═╡ 61fa4bbc-7813-11eb-0586-81dd09dcbe4e
# this updates **automatically** if you change the first cell
bep = areaofcircle(example)

# ╔═╡ f96cf846-7813-11eb-2f52-b900164fa0fd
md"""
##### Some words on scope...
In Julia, like all other languages, there are globally and locally scoped variables. Locally scoped can be considered hard or soft; difference being that soft local variables unassigned locally and defined globally reassign the global variable, whereas hard scope remains local.

Julia uses lexical scoping, meaning that a function's scope refers to the one in which it was defined. For example, calling the module "Bleep" from a global scope will use the scope independent to Bleep, NOT the caller's global scope:
"""

# ╔═╡ d1cd8d70-7816-11eb-1e8c-d91ecd9f3b34
module Bleep
	example = 1
	foo() = example
end

# ╔═╡ d29bb4d4-7816-11eb-17fe-15b22dbb8669
Bleep.foo()

# ╔═╡ 5711ca0a-7817-11eb-35a8-c75d3d15ee9e
md"""
And this new module's independent scope is separate from the caller's global scope:
"""

# ╔═╡ d385044a-7816-11eb-1f29-d110b7db73de
module Deeee
	beh = example
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
Additionally, if one variable is defined as another, any modification to the new variable will result in the same change in the original.
"""

# ╔═╡ 59fb2584-7bef-11eb-2670-27158cbeec69
begin
	blip = [1,2,3]
	behhh = blip
end

# ╔═╡ 59cb6478-7bef-11eb-0109-fb0b6674a60c
behhh[2] = 4

# ╔═╡ 5979bc54-7bef-11eb-2a1b-a5527bed5f92
blip

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

# ╔═╡ f0ba15bc-781a-11eb-3c35-ff4c9969aac3
all(i->(4<=i<=6), [4,5,6])

# ╔═╡ 0d3a1b8e-7b01-11eb-3e0f-5b454d05e4d5
md"""
#### Fun with structs!

Julia structs do not require inheritance like OOP languages do - of which Julia is not considered to be, due to the fact that you cannot attach a method (a behavior of a function) to a type. Dispatch, or the choice of method, depends on the first argument in OOP, while in Julia, it chooses which of a function's methods to call depending on the types of all the arguments. This is called multiple dispatch, and is the primary differentiator from other languages.

Types can be either system-defined or user-defined, and allow for structs to define a "supertype" which can be called by any number of functions or structs, as follows.

"""

# ╔═╡ 0e6ddf9a-7b01-11eb-2188-85c9743f0513
struct Limbs
	hands :: Float64
	leg :: Integer
end

# ╔═╡ 0f1fa900-7b01-11eb-12ad-e723b2f4c83b
struct boy
	body_parts :: Limbs #declaring body_parts as a Composite Type, defined by Limbs
	# only inner constructors have access to this "new" function
	boy(hands, leg) = new(Limbs(hands, leg))
end

# ╔═╡ 2b4f0494-7b02-11eb-0ef3-15e5db3ec568
begin
	joseph = boy(2.,1)
	joseph.body_parts.hands
end

# ╔═╡ 2a7e876a-7b02-11eb-153c-4914b1e0d341
md"""
This will come into play with user-defined type "Cell" that can be acted on by any number of functions.
"""

# ╔═╡ 0fc4da60-7b01-11eb-16dd-9530cca12ed0
md"""
##### Differences from other languages that may not be immediately obvious...

https://docs.julialang.org/en/v1/manual/noteworthy-differences/

https://erik-engheim.medium.com/defining-custom-units-in-julia-and-python-513c34a4c971
"""

# ╔═╡ 4400d1bc-781d-11eb-2c1b-67d229778938
md"""
# Now let's collide some Things...
"""

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
function updatepos!(c::Cell, dt, deccel, terminal_v)
	
	"""
	A function which uses Newtonian dynamics to update position & velocity
	vectors according to viscious drag, 'deccel'
	"""
	
	c.p .+= c.v .* dt
	
	while abs(c.v[1]) > terminal_v
		if c.v[1] >= 0.
			c.v[1] -= deccel*dt
		elseif c.v[1] < 0.
			c.v[1] += deccel*dt
		end
	end
	
	while abs(c.v[2]) > terminal_v
		if c.v[2] >= 0.
			c.v[2] -= deccel*dt
		elseif c.v[2] < 0.
			c.v[2] += deccel*dt
		end
	end
end

# ╔═╡ 063bcc80-8d29-11eb-2f53-6f34ee1a45ef
function lennard_jones!(cellarray, dt, r, dispersion_E, terminal_v)
	"""
	Models interactions on scales in which electrically neutral soft-matter is not hindered by the medium in its soft attraction and strong repulsion against itself
	"""
	A = 4 * dispersion_E * r^12
	B = 4 * dispersion_E * r^6
	
	Vx = zeros(length(cellarray),length(cellarray))
	Vy = zeros(length(cellarray),length(cellarray))
	
	for j in 1:length(cellarray)
		for k in 1:length(cellarray)
			dx = cellarray[j].p[1] - cellarray[k].p[1]
			dy = cellarray[j].p[2] - cellarray[k].p[2]
			
			if j==k
				nothing
				
			elseif dx < 0
				Vx[j,k] = -(A / (dx^12)) - (B / (dx^6))
			elseif dx > 0
				Vx[j,k] = (A / (dx^12)) - (B / (dx^6))
				
			elseif dy < 0
				Vy[j,k] = -(A / (dy^12)) - (B / (dy^6))
			elseif dy > 0
				Vy[j,k] = (A / (dy^12)) - (B / (dy^6))
			else
				nothing
			end
		end
	end
	
	mass = 0.0000001
	for i in 1:length(cellarray)
		tot_vx = sum(Vx[i,:]) * mass
		tot_vy = sum(Vy[i,:]) * mass
		cellarray[i].v[1] += tot_vx*dt
		cellarray[i].v[2] += tot_vy*dt
		if cellarray[i].v[1] > terminal_v
			cellarray[i].v[1] = terminal_v
		elseif cellarray[i].v[1] < (-1*terminal_v)
			cellarray[i].v[1] = (-1*terminal_v)
		elseif cellarray[i].v[2] > terminal_v
			cellarray[i].v[2] = terminal_v
		elseif cellarray[i].v[2] < (-1*terminal_v)
			cellarray[i].v[2] = (-1*terminal_v)
		else
			nothing
		end
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
md"""Because masses are assumed to be equal and we are ignoring cases where cells stick together (aka inelastic collision), we can use basic position updating and velocity swapping.
"""

# ╔═╡ 5be70cd4-8d3e-11eb-2434-25892caaa68e
function elastic!(c1::Cell, c2::Cell, r, dt, deccel, terminal_v)
	
	"""
	If both of cell 1's position values are close to both of cell 2's,
	their velocities will swap. Eventually, we may need to introduce multi-coordinate
	checking in the case of long cells, and adjustment to orientation.
	"""
	
	if abs(c1.p[1] - c2.p[1]) <= r && abs(c1.p[2] - c2.p[2]) <= r
		tmp = zeros(size(c1.v))
		tmp .= c1.v
		c1.v .= c2.v
		c2.v .= tmp
		
		#update pos
		c1.p .+= c1.v .* dt
		c2.p .+= c2.v .* dt
	else
		nothing
	end
	
	if abs(c1.p[1] - c2.p[1]) <= r && abs(c1.p[2] - c2.p[2]) <= r && abs(c1.v[1]) <= terminal_v && abs(c1.v[2]) <= terminal_v
		overlap = c1.p .- c2.p
		if overlap[1] < 0
			c1.v[1] -= (terminal_v*.5)
		else
			c1.v[1] += (terminal_v*.5)
		end
		if overlap[2] < 0
			c1.v[2] -= (terminal_v*.5)
		else
			c1.v[2] += (terminal_v*.5)
		end
	end
	
	if abs(c1.p[1] - c2.p[1]) <= r && abs(c1.p[2] - c2.p[2]) <= r && abs(c2.v[1]) <= terminal_v && abs(c2.v[2]) <= terminal_v
		overlap = c2.p .- c1.p
		if overlap[1] < 0
			c2.v[1] -= (terminal_v)
		else
			c2.v[1] += (terminal_v)
		end
		if overlap[2] < 0
			c2.v[2] -= (terminal_v)
		else
			c2.v[2] += (terminal_v)
		end
	end

end

# ╔═╡ 9a285f94-7d84-11eb-27a8-a1474b2afcdb
function initialize(n, sparsity_level, temp)
	
	"""
	Creates arrays for the starting positions and velocities of cells.
	"""
	
	pos = sample(Float64[x for x in collect(-50:50)], (2,n), replace=false)
	vel = sample(Float64[x for x in collect(-50:50)], (2,n), replace=false)
	s = n / sparsity_level
	pos ./= s
	vel ./= temp
	return pos, vel
end

# ╔═╡ bec0320e-8d2d-11eb-39f2-2f0b52cd3d8a
function pixelate(cellarray, r, dim, locmin, locmax, cush)
	
	# either add percent occupation, make new function for it
	
	im = zeros(dim,dim)
	
	# create new bounds for scaling purposes
	globmin = (1+cush)*locmin
	globmax = (1+cush)*locmax
	
	# normalize and scale cell origins to pixel locations
	o = []
	for l in 1:length(cellarray)
		origin = [((cellarray[l].p .- globmin) ./ (globmax - globmin)) .* dim]
		append!(o,origin)
	end
	
	# normalize radius to image
	r_im = (r * dim) / (globmax - globmin)
	# check in terminal that the radius is reasonable
	#println(r_im)
	
	# for each cell origin, scan from leftmost pixel to origin
	# compute the angle to the pixel and the length of the hypotenuse
	# if that length is within radial distance, set pixel = cell index
	
	for x in 1:length(im[1,:])
		for y in 1:length(im[:,1])
			for i in 1:length(o)
				h = o[i][1]
				k = o[i][2]
				if ((x-h)^2 + (y-k)^2) <= (r_im^2)
					im[y,x] = 1
				else
					nothing
				end
			end
		end
	end
	
	return im
end

# ╔═╡ b7ee677c-7d97-11eb-3f35-135e8ff32d35
begin
	n_cells = 20
	dense = .6
	# i'll be changing this arbitrary stuff later but it's good enough for now
	nonsense = 150
	morenonsense = (n_cells / dense)
	minpos = (-50) / morenonsense
	maxpos = (50) / morenonsense
	
	init_p, init_v = initialize(n_cells,dense,nonsense)
	cellarray = []
	for i in 1:n_cells
		boop = [Cell(init_p[:,i],init_v[:,i])]
		append!(cellarray,boop)
	end
end

# ╔═╡ 9f6a9850-7d93-11eb-1a82-49ec5e717ff9
function plot_em()
	myboy = scatter([cellarray[1].p[1]],[cellarray[1].p[2]], xlims=(-5,5), ylims=(-5,5), legend=false, xticks=false, yticks=false, markersize=5)
	for i in 2:length(cellarray)
		scatter!([cellarray[i].p[1]],[cellarray[i].p[2]],markersize=5)
	end
	return myboy
end

# ╔═╡ 33cd3d70-7828-11eb-3814-0d24b6f35c08
begin
	#ims = []
	t=41
	anim = @animate for i=0:t
		
		# timestep
		dt = 0.1
		# min distance before collision
		r = .2
		# decceleration constant
		drag = 0.1
		# terminal velocity
		vT = 0.1
		# dispersion energy
		ep = -.0001
		
		updatepos!.(cellarray, dt, drag, vT) 
		
		#lennard_jones!(cellarray, dt, r, ep, vT)
		
		#collision stuff
		for j in 1:length(cellarray)-1
			k = 1+j
			while k <= length(cellarray)
				elastic!(cellarray[j],cellarray[k],r,dt,drag,vT)
				k += 1
			end
		end
		
		#im = pixelate(cellarray, r, 255, minpos, maxpos, .7)
		#heatmap(im, color=:grays, aspect_ratio=1)
		
		#append!(ims, im)
					
		plot_em()
				
	end
				
	gif(anim, fps = 10)
				
end

# ╔═╡ a6f01d32-8d3f-11eb-275b-657d79250e38
function giftime(cellarray, t)
	
	# timestep
	dt = 0.1
	# min distance before collision
	r = .2
	# decceleration constant
	drag = 0.1
	# terminal velocity
	vT = 0.1
	# dispersion energy
	ep = -.0001
	
	anim = @animate for i=1:t
		updatepos!.(cellarray, dt, drag, vT) 
		
		#collision stuff
		for j in 1:length(cellarray)-1
			k = 1+j
			while k <= length(cellarray)
				elastic!(cellarray[j],cellarray[k],r,dt,drag,vT)
				k += 1
			end
		end
		l = @layout [ a  b ]
		ax1 = plot_em()
		im = pixelate(cellarray, r, 255, minpos, maxpos, .8)
		ax2 = heatmap(im, color=:grays, aspect_ratio=1, legend=false, xticks=false, yticks=false)#, xflip = true, yflip=true)
		figure = plot(ax1,ax2,layout=l)
	end
	gif(anim,"example.gif")
end

# ╔═╡ ac69d51c-8d41-11eb-3fd2-d37e8c885c60
giftime(cellarray,60)

# ╔═╡ 5c84d70c-7a15-11eb-0c37-7dfc0b335c76
begin
	bah = pixelate(cellarray, .2, 255, minpos, maxpos, .4)
	heatmap(bah, color=:grays, aspect_ratio=1)
end

# ╔═╡ ef9f9636-8b71-11eb-0ad3-b3909cbe7a79


# ╔═╡ ef875bca-8b71-11eb-2c9c-b1f4f7af2402


# ╔═╡ ef703f1e-8b71-11eb-04ab-753cfa0484de


# ╔═╡ ef5778b0-8b71-11eb-035e-f559f2079d88


# ╔═╡ eedfd0e4-8b71-11eb-1d47-0dd1cc5bb4b9


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
# ╠═59fb2584-7bef-11eb-2670-27158cbeec69
# ╠═59cb6478-7bef-11eb-0109-fb0b6674a60c
# ╠═5979bc54-7bef-11eb-2a1b-a5527bed5f92
# ╟─a64c8748-7817-11eb-2a42-892fc3a72491
# ╟─a633a61c-7817-11eb-1178-5bda8a9987b4
# ╠═a5ff4c82-7817-11eb-3263-1df67acc3a16
# ╟─a5e3feaa-7817-11eb-2baf-adbc7d42fd08
# ╠═a06ddb20-781b-11eb-00ef-0908eeeba6fc
# ╠═a0253856-781b-11eb-0ac3-3b7dcc9f11b1
# ╠═749d7ee6-781e-11eb-36d1-3189d619d478
# ╠═9fcf36f2-781b-11eb-2e17-d9aaee3222cc
# ╠═f0ba15bc-781a-11eb-3c35-ff4c9969aac3
# ╟─0d3a1b8e-7b01-11eb-3e0f-5b454d05e4d5
# ╠═0e6ddf9a-7b01-11eb-2188-85c9743f0513
# ╠═0f1fa900-7b01-11eb-12ad-e723b2f4c83b
# ╠═2b4f0494-7b02-11eb-0ef3-15e5db3ec568
# ╟─2a7e876a-7b02-11eb-153c-4914b1e0d341
# ╟─0fc4da60-7b01-11eb-16dd-9530cca12ed0
# ╟─4400d1bc-781d-11eb-2c1b-67d229778938
# ╠═a55cdb1e-7817-11eb-24a9-ed2c2a6c4d34
# ╠═ebe9176e-5f76-11eb-1c02-e122c6af0b66
# ╟─af75dbdc-7867-11eb-31a2-7b9dd3679b8b
# ╠═cfd5dee2-6000-11eb-1305-5985de7b450f
# ╠═063bcc80-8d29-11eb-2f53-6f34ee1a45ef
# ╠═c83729e4-7bde-11eb-3b68-43f4860a75b3
# ╟─b7fd1100-786a-11eb-1479-9f90a62171a8
# ╠═5be70cd4-8d3e-11eb-2434-25892caaa68e
# ╠═9a285f94-7d84-11eb-27a8-a1474b2afcdb
# ╠═9f6a9850-7d93-11eb-1a82-49ec5e717ff9
# ╠═bec0320e-8d2d-11eb-39f2-2f0b52cd3d8a
# ╠═b7ee677c-7d97-11eb-3f35-135e8ff32d35
# ╠═33cd3d70-7828-11eb-3814-0d24b6f35c08
# ╠═a6f01d32-8d3f-11eb-275b-657d79250e38
# ╠═ac69d51c-8d41-11eb-3fd2-d37e8c885c60
# ╠═5c84d70c-7a15-11eb-0c37-7dfc0b335c76
# ╠═ef9f9636-8b71-11eb-0ad3-b3909cbe7a79
# ╠═ef875bca-8b71-11eb-2c9c-b1f4f7af2402
# ╠═ef703f1e-8b71-11eb-04ab-753cfa0484de
# ╠═ef5778b0-8b71-11eb-035e-f559f2079d88
# ╠═eedfd0e4-8b71-11eb-1d47-0dd1cc5bb4b9
