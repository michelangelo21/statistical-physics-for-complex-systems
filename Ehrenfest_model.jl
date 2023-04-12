using Random
using Plots

function ehrenfest_trajectories(n; p=0.4, mc_steps=10_000)
    fleas = trues(n)
    trajectories = [copy(fleas)]
    for j in 1:mc_steps
        for i in 1:n
            if rand() < p
                flee_idx = rand(1:n) # speedup, cause only rand if rand() < p
                # fleas[flee_idx] *= -1
                fleas[flee_idx] = !fleas[flee_idx]
            end
        end
        push!(trajectories, copy(fleas))
    end
    return trajectories
end

function ehrenfest(n; p=0.4, mc_steps=10_000)
    fleas = trues(n)
    N_As = map(1:mc_steps) do _
        for i in 1:n
            if rand() < p
                flee_idx = rand(1:n) # speedup, cause only rand if rand() < p
                # fleas[flee_idx] *= -1
                fleas[flee_idx] = !fleas[flee_idx]
            end
        end
        return sum(fleas)
    end
    return [n; N_As]
end

N = 500
mc_steps = 10_000
# trajectories = ehrenfest_trajectories(10, mc_steps=mc_steps)
# trajectories_M = hcat(trajectories...)
N_As = ehrenfest(N, mc_steps=mc_steps)

# plot(0:MC_STEPS, getindex.(trajectories, 1), label=:none)
# xlabel!("time [MCS]")
# ylabel!("dog")
# title!("flea, p=$(p)")

# N_As = sum(trajectories_M, dims=1)'

plot(0:mc_steps, N_As, label="N_A")
plot!(0:mc_steps, N .- N_As, label="N_B")
xlabel!("time [MCS]")
ylabel!("number of fleas")
title!("N=$(N) fleas, p=$(p)")

# histogram(N_As, xlims=(0, n), normalize=:pdf)
histogram(N_As, normalize=:pdf)
scatterhist(N_As, normalize=:pdf)

analytical(n, N) = binomial(BigInt(N), BigInt(n)) / (BigInt(1) << 500)
plot!(0:N, analytical.(0:N, N), label="analytical")

map(n -> analytical(n, N), 0:N)

