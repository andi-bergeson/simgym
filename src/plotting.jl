function plot_em()
	myboy = scatter([cellarray[1].p[1]],[cellarray[1].p[2]], xlims=(-5,5), ylims=(-5,5), legend=false, markersize=5)
	for i in 2:length(cellarray)
		scatter!([cellarray[i].p[1]],[cellarray[i].p[2]],markersize=5)
	end
	return myboy
end

function plot_em(min,max)
	myboy = scatter([cellarray[1].p[1]],[cellarray[1].p[2]], legend=false, markersize=5, xlims=(min,max), ylims=(min,max), xticks=false, yticks=false)
	for i in 2:length(cellarray)
		scatter!([cellarray[i].p[1]],[cellarray[i].p[2]],markersize=5)
	end
	return myboy
end

function giftime(s::Simulation, t)
	anim = @animate for i=1:t
		l = @layout [ a  b ]
		ax1 = plot_em(minpos,maxpos)
		im = pixelate(s, 255, minpos, maxpos, .8)
		ax2 = heatmap(im, color=:grays, aspect_ratio=1, legend=false, xticks=false, yticks=false)
		figure = plot(ax1,ax2,layout=l)
	end
	gif(anim,"example.gif")
end