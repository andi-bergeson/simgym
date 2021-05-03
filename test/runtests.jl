using Test, simgym

@test 1==1
@test keys(x^2 for x in -1:0.5:1) == 1:5

#s = Simulation()

@test