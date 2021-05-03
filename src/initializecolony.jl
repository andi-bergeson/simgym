function initi(n, sparsity_level, temp)
	"""
	Creates arrays for the starting positions and velocities of cells.
	"""
	pos = rand(Float64, (2,n))
	vel = rand(Float64, (2,n))
	pos .*= sparsity_level
	vel ./= temp

	cellarray = Cell[]
	for i in 1:n
		boop = [Cell(pos[:,i],vel[:,i])]
		append!(cellarray,boop)
	end
	return cellarray
end