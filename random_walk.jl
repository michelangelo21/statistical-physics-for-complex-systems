using Random
using Plots
using Statistics
using LsqFit
using Measurements

Random.seed!(42)
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
    for i in 2:N
        currpos = step(currpos)
    end
    return currpos
end

Ns_history = (100, 1000, 10_000)
histories = [random_walk_history(n) for n in Ns_history]

plts = map(1:length(Ns_history)) do i
    n = Ns_history[i]
    history = histories[i]
    plt = plot(history[1, :], history[2, :], label=:none, aspect_ratio=:equal, linewidth=0.5)
    title!("N=$(n) steps")
    return plt
end

plot(plts..., layout=(1, length(Ns_history)), size=(1200, 400), dpi=600)
savefig("random_walk_histories.png")

function last_distance(N)
    x, y = random_walk(N)
    return √(x^2 + y^2)
end

K = 10_000
R̄(N, K) = mean(last_distance(N) for _ in 1:K)

Ns = vcat([100:100:900, 1000:1000:9000, 10_000:10_000:90_000, 100_000:100_000:1_000_000]...)
@time Rs = [R̄(n, K) for n in Ns]

@. model(x, p) = p[1] * x + p[2]
p0 = [1.0, 1.0]
fit = curve_fit(model, Ns, Rs .^ 2, p0)
a, b = coef(fit) .± stderror(fit)

scatter(Ns, Rs .^ 2, label="Squared mean over K=10 000 repetitions", markersize=2, dpi=600)
plot!(Ns, model(Ns, fit.param), label="Fit: a=$a,  b=$b", linewidth=2, legend=:topleft)
xlabel!("N")
ylabel!("<R>²")
title!("Squared mean distance from origin after N steps")
savefig("random_walk_squared_mean_distance.png")
