### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 580dee74-b0f8-11eb-110f-9bf8b21d33fe
using simgym, Plots

# ╔═╡ 522f6955-4c71-41dc-92d7-8d01ea720664
function plot_em(s::Simulation, sparse_level)
	livingcellIDs = []
	totalsteps = s.steptotal[1]
	for i in 1:length(s.cells)
		if s.cells[i].d < totalsteps
			nothing
		else
			push!(livingcellIDs,i)
		end
	end
	coords = zeros(length(livingcellIDs),2)
	for i in 1:length(livingcellIDs)
		coords[i,1] = s.cells[livingcellIDs[i]].p[1]
		coords[i,2] = s.cells[livingcellIDs[i]].p[2]
	end
	myboy = scatter(coords[:,1],coords[:,2],legend=false, markersize=5, xlims=(-6*sparse_level,6*sparse_level), ylims=(-6*sparse_level,6*sparse_level))
	return myboy
end

# ╔═╡ 64aa8486-5367-4356-b973-16fb280f24cd
function giftime(s,nsteps,dim,sparsity_level,μ,ϵ)#dt
	anim = @animate for i=1:nsteps
		# timestep
		dt = .1

		integrate!(s,dt,10,ϵ,μ)

		l = layout = @layout([A{0.01h}; [B C]])
		ax1 = plot_em(s,sparsity_level)
		mask = pixelate(s,dim,sparsity_level,0.)
		ax2 = heatmap(mask, color=:grays, aspect_ratio=1, legend=false, xticks=false, yticks=false)
		header = string("nsteps=",nsteps,", dt=",dt,", ϵ=",ϵ,", μ=",μ)
		title = plot(title=header,grid=false,showaxis=false,bottom_margin=-50Plots.px)
		figure = plot(title,ax1,ax2,layout=l)
	end
	gif(anim,"example.gif",fps=10)
end

# ╔═╡ f78a6bf8-9b95-481c-8ceb-5b2de6e43b32
begin
	n_cells = 20
	sparsity = 1.5
	repro = 4000
	# dispersion energy constant
	ϵ = 0.001
	cellarray = makeCellArray(n_cells,sparsity,repro)
	s = Simulation(cellarray,len_jones)
end

# ╔═╡ bd234560-07a2-4e14-a75a-a8eee870ca91
begin
	nsteps=40
	anim = @animate for i=1:nsteps
		# timestep
		dt = .1

		integrate!(s,dt,10,ϵ,repro)

		plot_em(s,sparsity)
	end
	gif(anim, fps = 10)
end

# ╔═╡ b0506c7e-df79-4333-aeee-b9c469ca66e1
giftime(s,120,255,sparsity,repro,ϵ)

# ╔═╡ Cell order:
# ╠═580dee74-b0f8-11eb-110f-9bf8b21d33fe
# ╠═522f6955-4c71-41dc-92d7-8d01ea720664
# ╠═64aa8486-5367-4356-b973-16fb280f24cd
# ╠═f78a6bf8-9b95-481c-8ceb-5b2de6e43b32
# ╠═bd234560-07a2-4e14-a75a-a8eee870ca91
# ╠═b0506c7e-df79-4333-aeee-b9c469ca66e1
