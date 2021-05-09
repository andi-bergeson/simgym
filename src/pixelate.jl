function pixelate(s::Simulation, dim, sparsity_level, cushion)
	# either add percent occupation, make new function for it
	im = zeros(dim,dim)
	# ascertain limits of distribution - 4 sigma away!
	localmin = -4*sparsity_level
	localmax = 4*sparsity_level
	# create new bounds for scaling purposes
	globmin = localmin*(1+cushion)
	globmax = localmax*(1+cushion)
	# normalize and scale cell origins to pixel locations
	o = []
	for c in s.cells
		origin = [((c.p .- globmin) ./ (globmax - globmin)) .* dim]
		append!(o,origin)
	end
	# normalize radius to image
	r_im = (1/2.7) * (dim / (localmax-localmin))
	# check in terminal that the radius is reasonable
	#println(r_im)

	for x in 1:length(im[1,:])
		for y in 1:length(im[:,1])
			for i in 1:length(o)
				h = o[i][1]
				k = o[i][2]
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