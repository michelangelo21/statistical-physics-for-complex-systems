using Random
using Plots

k = 10_000
randnums = [rand() for _ in 1:k]

histogram(randnums)