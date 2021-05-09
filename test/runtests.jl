using Test, simgym
import simgym: leapfrog!

@test 1==1

testpos = [0.,0.]
testvel = [.0001,.0001]

cell = Cell[Cell(copy(testpos),copy(testvel),40,30)]
s = Simulation(cell,len_jones)

dt = .1
nsteps = 1

# this is what leapfrog SHOULD be doing
@. testpos += dt*testvel

leapfrog!(s,dt)

@test testpos == s.cells[1].p