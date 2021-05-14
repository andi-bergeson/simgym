function len_jones(c1::Cell,c2::Cell,ϵ::Float64;maxdist=1.3)
    """
	Models interactions on scales in which electrically neutral soft-matter
    is not hindered by the medium in its soft attraction and strong repulsion against itself
	"""
    if c1==c2; return zeros(2); end

    r = norm(c1.p .- c2.p)
    if r > maxdist
        return zeros(2)
    end
    r_unit = (c1.p .- c2.p) ./ r

    # sigma is the distance at which cell-cell potential is zero
    σ = 1.
    mass = 1.
    A = 4*ϵ*(σ^12)
    B = 4*ϵ*(σ^6)
    U = (A/r^12) - (B/r^6)
    F = U .* r_unit
    a = F ./ mass
    return a
end

#k = 10/s
#t = -log(rand)/k