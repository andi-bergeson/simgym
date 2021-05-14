function pixelate(s::Simulation, dim::Int64, sparsity_level::T, cushion::T) where T<:Real
	nsteps = s.steptotal[1]
	# either add percent occupation, make new function for it
	im = zeros(dim,dim)
	# ascertain limits of distribution - 4 sigma away!
	localmin = -4*sparsity_level
	localmax = 4*sparsity_level
	# create new bounds for scaling purposes
	globmin = localmin*(1+cushion)
	globmax = localmax*(1+cushion)
	# normalize and scale cell origins to pixel locations
	livingcellIDs = []
	for i in 1:length(s.cells)
		if s.cells[i].d < nsteps
			nothing
		else
			push!(livingcellIDs,i)
		end
	end
	o = zeros(T,length(livingcellIDs),2)
	for i in 1:length(livingcellIDs)
		o[i,1] = s.cells[livingcellIDs[i]].p[1] - globmin
		o[i,2] = s.cells[livingcellIDs[i]].p[2] - globmin
	end
	o .*= (dim / (globmax - globmin))
	# normalize radius to image
	r_im = (1/2.33) * (dim / (localmax-localmin))
	# check in terminal that the radius is reasonable
	#println(r_im)

	for x in 1:length(im[1,:])
		for y in 1:length(im[:,1])
			for i in 1:length(o[:,1])
				h = o[i,1]
				k = o[i,2]
				if ((x-h)^2 + (y-k)^2) < (r_im^2)
					im[y,x] = 1
				else
					nothing
				end
			end
		end
	end
	return im
end