using Random
using Plots

N = 100
MC_STEPS = 200
p = 0.1 # probability of change

fleas = trues(N)
trajectories = [copy(fleas)]
for j in 1:MC_STEPS
    for i in 1:N
        if rand() < p
            flee_idx = rand(1:N) # speedup, cause only rand if rand() < p
            # fleas[flee_idx] *= -1
            fleas[flee_idx] = !fleas[flee_idx]
        end
    end
    push!(trajectories, copy(fleas))
end

fleas
trajectories
trajectories_M = hcat(trajectories...)

plot(0:MC_STEPS, getindex.(trajectories, 1), label=:none)
xlabel!("time [MCS]")
ylabel!("dog")
title!("flea, p=$(p)")

trajectories_M[1, :]
n_fleas = sum(trajectories_M, dims=1)
plot(0:MC_STEPS, n_fleas', label="dog_A")
plot!(0:MC_STEPS, N .- n_fleas', label="dog_B")
xlabel!("time [MCS]")
ylabel!("number of fleas")
title!("N=$(N) fleas, p=$(p)")
