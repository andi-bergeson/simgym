### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ a55cdb1e-7817-11eb-24a9-ed2c2a6c4d34
# import necessary packages
using Plots, LinearAlgebra, Statistics, StatsBase

# ╔═╡ 0fc4da60-7b01-11eb-16dd-9530cca12ed0
md"""
##### Differences from other languages that may not be immediately obvious...

https://docs.julialang.org/en/v1/manual/noteworthy-differences/

https://erik-engheim.medium.com/defining-custom-units-in-julia-and-python-513c34a4c971
"""

# ╔═╡ 4400d1bc-781d-11eb-2c1b-67d229778938
md"""
# Demo time!
"""

# ╔═╡ 492e78f2-a579-4898-bd83-f567dc9155fa
begin
	struct Cell{T<:Real}
	    p::Vector{T} #position of the central point of the cell
	    v::Vector{T} #velocity
	    v2::Vector{T} # velocity half step
	    a::Vector{T} # acceleration
		#l::Float64 #length of the cylindrical element of the cell
		#r::Float64 #radius of the semi-circle at each end of the cylinder
		#orient::Int #orientation, [0:180], of line segment of cell center +/- portion of length with respect to vertical axis of photo
		#curv:: #probability of deviation from orientation at each line segment
	end
	
	#outer constructor
	Cell(p::Vector{T}, v::Vector{T}) where T<:Real = Cell(p,v,zeros(T,2),zeros(T,2))
end

# ╔═╡ 35629b27-94e0-4d3d-8f55-0c3258044ba9
struct Simulation
    cells::Vector{Cell} # Vector that holds all the cells in the simulations
    potentials # potential functions
end

# ╔═╡ 46eb46b5-be39-404c-923b-fc60ed9e57c7
function leapfrog!(s::Simulation, dt)
	"""Leapfrog integration step"""
    for c in s.cells
        @. c.v2 = c.v + 0.5*dt*c.a
        @. c.p += dt*c.v2
    end
    return
end

# ╔═╡ 372ff4a7-115e-468b-913f-d278725430c3
function calc_acceleration!(s::Simulation,ϵ::Float64)
    for i in eachindex(s.cells)
        #for j in eachindex(s.potentials)
        a = sum(s.potentials.(Ref(s.cells[i]),s.cells,ϵ))
        s.cells[i].a .= a
        #end
    end
end

# ╔═╡ 443bb3ac-5563-4725-b71c-c3dae3504e7c
function stepv!(s::Simulation, dt)
    for c in s.cells
	    @. c.v = c.v2 + 0.5*dt*c.a
    end
end

# ╔═╡ 7c3a6995-5b43-4639-b79f-7dafb8b3b978
function integrate!(s::Simulation, dt, nsteps, ϵ::Float64)
    for i in 1:nsteps
        leapfrog!(s, dt)
        calc_acceleration!(s,ϵ)
        stepv!(s, dt)
    end
end

# ╔═╡ 57086bd8-0205-486b-9a0e-ae58d0547158
function len_jones(c1::Cell,c2::Cell,ϵ::Float64)
    """
	Models interactions on scales in which electrically neutral soft-matter
    is not hindered by the medium in its soft attraction and strong repulsion against itself
	"""
    if c1==c2; return zeros(2); end

    σ = 1.
    A = 4*ϵ*(σ^12)
    B = 4*ϵ*(σ^6)
    r = norm(c1.p .- c2.p)
    r_unit = (c1.p .- c2.p) ./ r
    mass = 1. #gotta fiddle

    U = (A/r^12) - (B/r^6)
    F = U .* r_unit
    a = F ./ mass
    return a
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

# ╔═╡ fab634b3-100a-4da6-ad44-ab1e94f00430
function initi(n, sparsity_level, temp)
	"""
	Creates arrays for the starting positions and velocities of cells.
	"""
	pos = rand(Float64, (2,n))
	vel = rand(Float64, (2,n))
	#pos = sample(Float64[x for x in collect(0:1000)], (2,n), replace=false)
	#vel = sample(Float64[x for x in collect(-1000:1000)], (2,n), replace=false)
	pos .*= sparsity_level
	vel ./= temp

	cellarray = Cell[]
	for i in 1:n
		boop = [Cell(pos[:,i],vel[:,i])]
		append!(cellarray,boop)
	end
	return cellarray
end

# ╔═╡ 5864411d-39ea-4f46-b125-5d4d01f5943f
function pixelate(s::Simulation, dim, locmin, locmax, cush)
	# either add percent occupation, make new function for it
	im = zeros(dim,dim)
	# create new bounds for scaling purposes
	globmin = locmin#*(1+cush)
	globmax = locmax#*(1+cush)
	# normalize and scale cell origins to pixel locations
	o = []
	for c in s.cells
		@. origin = [((c.p - globmin) / (globmax - globmin)) * dim]
		append!(o,origin)
	end
	# normalize radius to image
	r_im = dim* (.5 / locmax)
	# check in terminal that the radius is reasonable
	println(r_im)
	
	#= for each cell origin, scan from leftmost pixel to origin
	compute the angle to the pixel and the length of the hypotenuse
	if that length is within radial distance, set pixel = cell index =#

	for x in 1:length(im[1,:])
		for y in 1:length(im[:,1])
			for i in 1:length(o)
				h = o[i][1]
				k = o[i][2]
				if ((x-h)^2 + (y-k)^2) <= (r_im^2)
					im[x,y] = 1
				else
					nothing
				end
			end
		end
	end
	return im
end

# ╔═╡ 85f4f2d9-87c8-46a5-bab7-d0ed1547d8d4
function plot_em(max)
	myboy = scatter([cellarray[1].p[1]],[cellarray[1].p[2]], legend=false, markersize=5, xlims=(0,max), ylims=(0,max))
	for i in 2:length(cellarray)
		scatter!([cellarray[i].p[1]],[cellarray[i].p[2]],markersize=5)
	end
	return myboy
end

# ╔═╡ 8540098d-0683-4a47-bb7e-7e7b441658f9
#=begin (from lennard)
	n_cells = 20
	dense = 100.
	# i'll be changing this arbitrary stuff later but it's good enough for now
	nonsensetemp = 10000.
	maxpos = (1000) / dense
	
	init_p, init_v = initialize(n_cells,dense,nonsensetemp)
	cellarray = []
	for i in 1:n_cells
		boop = [Cell(init_p[:,i],init_v[:,i])]
		append!(cellarray,boop)
	end
end

begin (from this)
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

=#

# ╔═╡ 33cd3d70-7828-11eb-3814-0d24b6f35c08
begin
	#ims = []
	t=41
	anim = @animate for i=0:t
		# timestep
		dt = 0.1
		
		#im = pixelate(cellarray, r, 255, minpos, maxpos, .7)
		#heatmap(im, color=:grays, aspect_ratio=1)
		
		#append!(ims, im)
					
		plot_em()
				
	end
				
	gif(anim, fps = 10)
				
end

# ╔═╡ a6f01d32-8d3f-11eb-275b-657d79250e38
#=function giftime(cellarray, t)
	
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
end=#

# ╔═╡ 5c84d70c-7a15-11eb-0c37-7dfc0b335c76
#=begin
	bah = pixelate(cellarray, .2, 255, minpos, maxpos, .4)
	heatmap(bah, color=:grays, aspect_ratio=1)
end=#

# ╔═╡ ef9f9636-8b71-11eb-0ad3-b3909cbe7a79


# ╔═╡ ef5778b0-8b71-11eb-035e-f559f2079d88


# ╔═╡ eedfd0e4-8b71-11eb-1d47-0dd1cc5bb4b9


# ╔═╡ Cell order:
# ╟─0fc4da60-7b01-11eb-16dd-9530cca12ed0
# ╟─4400d1bc-781d-11eb-2c1b-67d229778938
# ╠═a55cdb1e-7817-11eb-24a9-ed2c2a6c4d34
# ╠═492e78f2-a579-4898-bd83-f567dc9155fa
# ╠═35629b27-94e0-4d3d-8f55-0c3258044ba9
# ╠═46eb46b5-be39-404c-923b-fc60ed9e57c7
# ╠═372ff4a7-115e-468b-913f-d278725430c3
# ╠═443bb3ac-5563-4725-b71c-c3dae3504e7c
# ╠═7c3a6995-5b43-4639-b79f-7dafb8b3b978
# ╠═57086bd8-0205-486b-9a0e-ae58d0547158
# ╠═c83729e4-7bde-11eb-3b68-43f4860a75b3
# ╠═fab634b3-100a-4da6-ad44-ab1e94f00430
# ╠═5864411d-39ea-4f46-b125-5d4d01f5943f
# ╠═85f4f2d9-87c8-46a5-bab7-d0ed1547d8d4
# ╠═8540098d-0683-4a47-bb7e-7e7b441658f9
# ╠═33cd3d70-7828-11eb-3814-0d24b6f35c08
# ╠═a6f01d32-8d3f-11eb-275b-657d79250e38
# ╠═5c84d70c-7a15-11eb-0c37-7dfc0b335c76
# ╠═ef9f9636-8b71-11eb-0ad3-b3909cbe7a79
# ╠═ef5778b0-8b71-11eb-035e-f559f2079d88
# ╠═eedfd0e4-8b71-11eb-1d47-0dd1cc5bb4b9
