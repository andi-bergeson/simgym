### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 580dee74-b0f8-11eb-110f-9bf8b21d33fe
using simgym, Plots

# ╔═╡ 522f6955-4c71-41dc-92d7-8d01ea720664
function plot_em(s::Simulation, sparse_level)
	myboy = scatter([s.cells[1].p[1]],[s.cells[1].p[2]], legend=false, markersize=5, xlims=(-6*sparse_level,6*sparse_level), ylims=(-6*sparse_level,6*sparse_level))
	for i in 2:length(s.cells)
		scatter!([s.cells[i].p[1]],[s.cells[i].p[2]],markersize=5)
	end
	return myboy
end

# ╔═╡ 64aa8486-5367-4356-b973-16fb280f24cd
function giftime(s,nsteps,dim,sparsity_level,μ,ϵ)#dt
	anim = @animate for i=1:nsteps
		# timestep
		dt = .1

		integrate!(s,dt,20,ϵ,μ)

		l = layout = @layout([A{0.01h}; [B C]])
		ax1 = plot_em(s,sparsity_level)
		mask = pixelate(s,dim,sparsity_level,0)
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
	ϵ = 0.000001
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
giftime(s,80,255,sparsity,repro,ϵ)

# ╔═╡ 184f45ea-134b-47a0-b613-844f32eedea9


# ╔═╡ 6009aed0-4fac-47e0-aee1-3769b68ff7be


# ╔═╡ bf10f26f-fab0-42d2-931e-4428d2003305


# ╔═╡ Cell order:
# ╠═580dee74-b0f8-11eb-110f-9bf8b21d33fe
# ╠═522f6955-4c71-41dc-92d7-8d01ea720664
# ╠═64aa8486-5367-4356-b973-16fb280f24cd
# ╠═f78a6bf8-9b95-481c-8ceb-5b2de6e43b32
# ╠═bd234560-07a2-4e14-a75a-a8eee870ca91
# ╠═b0506c7e-df79-4333-aeee-b9c469ca66e1
# ╠═184f45ea-134b-47a0-b613-844f32eedea9
# ╠═6009aed0-4fac-47e0-aee1-3769b68ff7be
# ╠═bf10f26f-fab0-42d2-931e-4428d2003305
