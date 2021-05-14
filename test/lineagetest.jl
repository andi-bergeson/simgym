using Test, simgym
import simgym: reproduce!

testpos = [0.,0.]
testvel = [.0001,.0001]
testdeath = 2

cell = Cell[Cell(copy(testpos),copy(testvel),testdeath,30)]
s = Simulation(cell,len_jones)
s.steptotal .= 2
reproduce!(s,200)

@test length(s.cells) == 3