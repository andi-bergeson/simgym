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