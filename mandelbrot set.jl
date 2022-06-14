using PlotlyJS

function create_grid(dims, width, height)
    # Returns a grid of complex number of width and height in the
    # given domain.
    xmin, xmax, ymin, ymax = dims
    x = range(xmin, xmax, width)
    y = range(ymin, ymax, height)
    return (x' .* ones(height)) .+ reverse(y .* ones(width)' .* 1im)
end

function julia_set(cp, max_abs, N)
    # Consumes the complex grid and ruuns every number through the recusive
    # function. Generates a new matrix of just real numbers that represents how fast
    # each point divverges. That is what is graphed. 
    n = zeros(Float64, size(cp))
    z = zeros(ComplexF64, size(cp))
    for i in 1:N
        b = abs.(z) .<= max_abs
        z[b] .= (z[b].^2) .+ cp[b]
        n[b] .= n[b] .+ 1
        println("$i/$N")
    end

    function data(n)
        return 1 .- sqrt.(n ./ N)
    end

    return data(n)
end

const maximum_magnitude = 5
const number_of_iterations = 500
height, width = 5000, 5000
domain = xmin, xmax, ymin, ymax = (-2.25, 1, -1.3, 1.3)

C = create_grid(domain, width, height)
data = julia_set(C, maximum_magnitude, number_of_iterations)

plot(
    heatmap(z=data, colorscale="Jet", reversescale=false, 
    zsmooth = false)
)