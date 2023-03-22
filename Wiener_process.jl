using Random
using Plots



function Wiener_process(N, T=1.0)
    dt = T / N

    # Brownian motion
    dW = √(dt) * randn(N)

    W = zeros(N + 1)
    for i in 1:N
        W[i+1] = W[i] + dW[i]
    end
    return W
end

N = 10_000
T = 1.0
Ws = [Wiener_process(N, T) for i in 1:4]
Xs = [0:N] .* T ./ N

plot(Xs, Ws, legend=:none)
title!("Realizations of a Wiener process")
xlabel!("t")
ylabel!("W(t)")