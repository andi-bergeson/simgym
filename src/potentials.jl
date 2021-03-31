function len_jones(c1,c2,ϵ)
    """
	Models interactions on scales in which electrically neutral soft-matter
    is not hindered by the medium in its soft attraction and strong repulsion against itself
	"""
    if c1==c2; return c1.a; end

    σ = 1.
    A = 4*ϵ*(σ^12)
    B = 4*ϵ*(σ^6)
    r = norm(c1.p .- c2.p)
    r_unit = (c1.p .- c2.p) ./ r
    mass = 1. #gotta fiddle

    U = (A/r^12) - (B/r^6)
    F = U .* r_unit
    a = F ./ mass
    return a
end

#k = 10/s
#t = -log(rand)/k