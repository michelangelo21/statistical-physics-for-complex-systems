using Random
using Plots

K = 1000
normal = randn(K)

histogram(normal)

u = rand(K)
v = rand(K)

σ = 10
μ = 7

z₁ = @. μ + σ * √(-2 * log(u)) * cos(2 * π * v)
z₂ = @. μ + σ * √(-2 * log(u)) * sin(2 * π * v)

histogram(z₁)
histogram(z₂)