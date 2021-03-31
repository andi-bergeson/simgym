function initialize(n, sparsity_level, temp)
	"""
	Creates arrays for the starting positions and velocities of cells.
	"""
	pos = sample(Float64[x for x in collect(-50:50)], (2,n), replace=false)
	vel = sample(Float64[x for x in collect(-50:50)], (2,n), replace=false)
	pos ./= sparsity_level
	vel ./= temp
	return pos, vel
end