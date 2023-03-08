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

history = random_walk_history(K)
plot(history[1, :], history[2, :], label=:none)
plot!([0], [0], seriestype=:scatter, markersize=3, markerstrokewidth=0, color=:red, label="Start")
title!("Random Walk for K=$(K) steps")

function last_distance(N)
    x, y = random_walk(N)
    return √(x^2 + y^2)
end

K = 10_000
R̄(N, K) = mean(last_distance(N) for _ in 1:K)

Ns = 10:10:1000
Rs = [R̄(n, K) for n in Ns]


# @. model(x, p) = p[1] * x
@. model(x, p) = p[1] * x + p[2]
p0 = [1.0, 1.0]
fit = curve_fit(model, Ns, Rs .^ 2, p0)
a, b = coef(fit)

scatter(Ns, Rs .^ 2, label=:none, markersize=2)
plot!(Ns, model(Ns, fit.param), label="Fit: a=$a, b=$b", linewidth=2)
xlabel!("N")
ylabel!("<R²>")


