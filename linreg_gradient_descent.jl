# May 29, 2022
using Zygote
using Plots

# Define a linear model with random weights
W = randn(3, 2)
b = randn(2)
ŷ(X, W, b) = X * W .+ b'  # Prediction function

# Make random datax
n = 100  # Number of samples
X = randn(n, 3)
y = randn(n, 2)

loss(X, y, W, b) = y - ŷ(X, W, b) .|> abs2 |> sum  # Loss function

# Syntax for computing the gradient wrt to model parameters
val, ∇ = withgradient(Params([W, b])) do
    loss(X, y, W, b)
end

# Run a gradient descent loop
α = 3e-4  # Learning rate
n_iter = 75  # Number of iterations
losses = Float64[]  # Hold loss values

for i in 1:n_iter
    # Compute the gradient
    val, ∇ = withgradient(Params([W, b])) do
        loss(X, y, W, b)
    end
    push!(losses, val)

    # Update the model parameters
    W -= α .* ∇[W]
    b -= α .* ∇[b]
end

# Compute the loss for the optimal least-squares solution
X = hcat(ones(n), X)
W̃ = inv(X' * X) * X' * y
min_loss = loss(X, y, W̃, zeros(2))

# Plot the loss curve
plot(1:n_iter, [losses, min_loss * ones(n_iter)],
    label=["Gradient Descent" "Optimal Loss (Least-Squares)"],
    xlabel="Number of Iterations", ylabel="Loss",
    yaxis=:log, dpi=300)