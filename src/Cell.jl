"""
builds the constructor which will organize cell features
eventually there will be spherocylindrical features
"""
struct Cell{T<:Real}
    p::Vector{T} #position of the central point of the cell
    v::Vector{T} #velocity
    d::Int64 # calculated death (aka division) of the cell
	o::Int64 # orientation, [0:180], of line segment of cell center +/- portion of length with respect to vertical axis of photo
    v2::Vector{T} # velocity half step
    a::Vector{T} # acceleration
end

Cell(p::Vector{T}, v::Vector{T}, d::Int64, o::Int64) where T<:Real = Cell(p,v,d,o,zeros(T,2),zeros(T,2))

function makeCellArray(n, sparsity_level, μ)
	"""
	Draws starting positions & velocities from Normal Distr and initiates cells.
	"""
	d = Normal(0,sparsity_level)
	pos = rand(d, (2,n))
	vel = rand(Normal(), (2,n))
	pos .*= sparsity_level
	vel ./= 1000.

	t_division = rand(DiscreteUniform(4,μ),n)
	#randomkick = rand(DiscreteUniform(4,μ),n)
	orientation = rand(DiscreteUniform(0,180),n)

	cellarray = Cell[]
	for i in 1:n
		boop = [Cell(pos[:,i],vel[:,i],t_division[i],orientation[i])]
		append!(cellarray,boop)
	end
	return cellarray
end