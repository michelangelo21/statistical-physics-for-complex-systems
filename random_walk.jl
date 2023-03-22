using Random
using Plots
using Statistics
using LsqFit

N = 10_000

function step(pos)
    r = rand()
    if r < 0.25
        (pos[1] + 1, pos[2])
    elseif r < 0.5
        (pos[1] - 1, pos[2])
    elseif r < 0.75
        (pos[1], pos[2] + 1)
    else
        (pos[1], pos[2] - 1)
    end
end

function random_walk_history(N)
    N += 1
    currpos = (0, 0)
    history = zeros(Int, 2, N)

    for i in 2:N
        currpos = step(currpos)
        history[1, i] = currpos[1]
        history[2, i] = currpos[2]
    end
    return history
end

function random_walk(N)
    N += 1
    currpos = (0, 0)
    # history = zeros(Int, 2, N)

    for i in 2:N
        currpos = step(currpos)
        # history[1, i] = currpos[1]
        # history[2, i] = currpos[2]
    end
    return currpos
end

# histories = [random_walk_history(n) for n in Ns_history]
# plot!([0], [0], seriestype=:scatter, markersize=3, markerstrokewidth=0, color=:green, label="Start (0, 0)")
# plot!([history[1, end]], [history[2, end]], seriestype=:scatter, markersize=3, markerstrokewidth=0, color=:red, label="End")


Ns_history = (100, 1000, 10_000)
plts = []
histories = [random_walk_history(n) for n in Ns_history]

for i in 1:length(Ns_history)
    n = Ns_history[i]
    history = histories[i]
    plt = plot(history[1, :], history[2, :], label=:none, aspect_ratio=:equal, linewidth=0.5)
    title!("N=$(n) steps")
    push!(plts, plt)
end

plot(plts..., layout=(1, length(Ns_history)), size=(1200, 400))
lim = maximum(abs, histories[end]) + 5
xlims!(-lim, lim)
ylims!(-lim, lim)
# savefig("random_walk_histories_samelim.png")


function last_distance(N)
    x, y = random_walk(N)
    return √(x^2 + y^2)
end

K = 10_000
R̄(N, K) = mean(last_distance(N) for _ in 1:K)

Ns = range(1, 10000, length=100)
Ns = 1000:100:10_000
@time Rs = [R̄(n, K) for n in Ns]
@time last_distance(100_000)
@time R̄(100_000, K)



# @. model(x, p) = p[1] * x
@. model(x, p) = p[1] * x + p[2]
p0 = [1.0, 1.0]
fit = curve_fit(model, Ns, Rs .^ 2, p0)
a, b = coef(fit)

scatter(Ns, Rs .^ 2, label=:none, markersize=2)
plot!(Ns, model(Ns, fit.param), label="Fit: a=$a, b=$b", linewidth=2, legend=:topleft)
xlabel!("N")
ylabel!("<R²>")
title!("Mean square distance from origin after N steps")



