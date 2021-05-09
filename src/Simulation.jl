struct Simulation
    cells::Vector{Cell{Float64}} # Vector that holds all the cells in the simulations
    potentials # potential functions
    steptotal::Vector{Int64}
	Simulation(cells::Vector{Cell{Float64}},potentials) = new(cells,potentials,[0])
end

"""Leapfrog integration step"""
function leapfrog!(s::Simulation, dt)
    terminal_v = (.001 / dt)
    for c in s.cells
        @. c.v2 = c.v + 0.5*dt*c.a

        if abs(c.v2[1]) >= terminal_v
			if c.v2[1] > 0
				c.v2[1] = (terminal_v)
			else
				c.v2[1] = (-terminal_v)
			end
		end
		if abs(c.v2[2]) >= terminal_v
			if c.v2[2] > 0
				c.v2[2] = (terminal_v)
			else
				c.v2[2] = (-terminal_v)
			end
		end

        @. c.p += dt*c.v2
    end
    return
end

function calcAcceleration!(s::Simulation,ϵ::Float64)
    for i in eachindex(s.cells)
        #for j in eachindex(s.potentials)
        a = sum(s.potentials.(Ref(s.cells[i]),s.cells,ϵ))
        s.cells[i].a .= a
        #end
    end
end

function stepV!(s::Simulation, dt)
    for c in s.cells
	    @. c.v = c.v2 + 0.5*dt*c.a
    end
end

function integrate!(s::Simulation, dt, nsteps, ϵ::Float64, μ)
    for i in 1:nsteps
        leapfrog!(s, dt)
        calcAcceleration!(s,ϵ)
        stepV!(s, dt)
        s.steptotal .+= 1
		reproduce!(s, μ)
    end
end