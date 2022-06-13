using PlotlyJS

function create_grid(dims, width, height)
    # Returns a grid of complex number of width and height in the
    # given domain.
    xmin, xmax, ymin, ymax = dims
    x = range(xmin, xmax, width)
    y = range(ymin, ymax, height)
    return (x' .* ones(height)) .+ reverse(y .* ones(width)' .* 1im)
end

function julia_set(cp, number::ComplexF64, max_abs, N)
    # Consumes the complex grid and ruuns every number through the recusive
    # function. Generates a new matrix of just real numbers that represents how fast
    # every point divverges. That is what is graphed. 
    
    n = zeros(Float64, size(cp))
    for i in 1:N
        b = abs.(cp) .<= max_abs
        cp[b] .= (cp[b].^2) .+ number
        n[b] .= n[b] .+ 1
        println("$i/$N")
    end

    function data(n)
        return 1 .- sqrt.(n ./ N)
    end

    return data(n)
end

c =  -0.1  - 0.65im
const maximum_magnitude = 10
const number_of_iterations = 500
height, width = 500, 500
domain = (-2,2,-2,2)

C = create_grid(domain, width, height)
data = julia_set(C, c, maximum_magnitude, number_of_iterations)

plot(heatmap(z=data, colorscale="Jet"))