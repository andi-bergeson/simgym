function pixelate(s::Simulation, dim, locmin, locmax, cush)
	# either add percent occupation, make new function for it
	im = zeros(dim,dim)
	# create new bounds for scaling purposes
	globmin = (1+cush)*locmin
	globmax = (1+cush)*locmax
	# normalize and scale cell origins to pixel locations
	o = []
	for c in s.cells
		@. origin = [((c.p - globmin) / (globmax - globmin)) * dim]
		append!(o,origin)
	end
	# normalize radius to image
	r_im = dim * (1.) / (globmax - globmin)
	# for each cell origin, scan from leftmost pixel to origin
	# compute the angle to the pixel and the length of the hypotenuse
	# if that length is within radial distance, set pixel = cell index

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