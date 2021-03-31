"""
builds the constructor which will organize cell features
eventually there will be spherocylindrical features
"""
struct Cell{T<:Real}
    p::Vector{T} #position of the central point of the cell
    v::Vector{T} #velocity
    v2::Vector{T} # velocity half step
    a::Vector{T} # acceleration
end

Cell(p::Vector{T}, v::Vector{T}) where T<:Real = Cell(p,v,zeros(T,3),zeros(T,3))

struct Simulation
    cells::Vector{Cell} # Vector that holds all the cells in the simulations
    potentials # potential functions
end

"""Leapfrog integration step"""
function leapfrog!(s::Simulation, dt)
    for c in s.cells
        @. c.v2 = c.v + 0.5*dt*c.a
        @. c.p += dt*c.v2
    end
    return
end

function calc_acceleration!(s::Simulation,ϵ)
    for i in eachindex(s.cells)
        for j in eachindex(s.potentials)
            a = sum(s.potentials[j].(Ref(s.cells[i]),s.cells,ϵ))
            s.cells[i].a .= a
        end
    end
end

function stepv!(s::Simulation, dt)
    for c in s.cells
	    @. c.v = c.v2 + 0.5*dt*c.a
end

function integrate!(s::Simulation, dt, nsteps)
    for i in 1:nsteps
        leapfrog!(s, dt)
        calc_acceleration!(s,ϵ)
        stepv!(s, dt)
    end
end