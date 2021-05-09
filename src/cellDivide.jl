function reproduce!(s::Simulation, μ)
	indexarray = []
	nsteps = s.steptotal[1]
	r = .1
	for i in eachindex(s.cells)
		if s.cells[i].d == nsteps
			new_x1 = s.cells[i].p[1] + r*cosd(s.cells[i].o)
			new_y1 = s.cells[i].p[2] + r*sind(s.cells[i].o)
			new_x2 = s.cells[i].p[1] - r*cosd(s.cells[i].o)
			new_y2 = s.cells[i].p[2] - r*sind(s.cells[i].o)

			t_division1 = rand(DiscreteUniform(4+nsteps,μ+nsteps),1)
			t_division2 = rand(DiscreteUniform(4+nsteps,μ+nsteps),1)

			newcell1 = Cell([new_x1,new_y1],s.cells[i].v,t_division1[1],s.cells[i].o)
			newcell2 = Cell([new_x2,new_y2],-s.cells[i].v,t_division2[1],s.cells[i].o)

			# add the cell that has divided to the array of indices to be removed
			push!(indexarray, i)
			# add the new cells
			push!(s.cells, newcell1)
			push!(s.cells, newcell2)
		else
			nothing
		end
	end
	# remove the divided cells from array of cells
	deleteat!(s.cells, indexarray)
end