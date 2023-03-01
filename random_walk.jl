using Random
using Plots

K = 10_000

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

function random_walk(K)
    K += 1
    currpos = (0,0)
    history = zeros(Int, 2, K)
    history

    for i in 2:K
        currpos = step(currpos)
        history[1, i] = currpos[1]
        history[2, i] = currpos[2]
    end
    return history
end

history = random_walk(K)
plot(history[1, :], history[2, :], label=:none)
plot!([0], [0], seriestype=:scatter, markersize=3, markerstrokewidth=0, color=:red, label="Start")
title!("Random Walk for K=$(K) steps")
