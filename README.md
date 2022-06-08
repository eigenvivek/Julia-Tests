# Julia-Tests

Short scripts for testing different functionalities in Julia.

## Topics

### Auto-Differentiability

- Linear Regression by gradient descent with Zygote ([`linreg_gradient_descent.jl`](linreg_gradient_descent.jl))
- Defining a custom gradient rule with ChainRulesCore ([`chainrules_custom_gradient.jl`](chainrules_custom_gradient.jl))

## Tips

- Use latex symbols in code with [usual latex commands](https://docs.julialang.org/en/v1/manual/unicode-input/) (e.g., `\varepsilon`, `\Chi`, etc.). Some are functional (e.g., `\subseteq`, `\in`, etc.).
- To get a jupyter notebook with a specific Julia kernel, launch Jupyter within an environment folder to get packages from that `.toml` (IJulia [documentation here](https://github.com/JuliaLang/IJulia.jl/blob/6de52233dc60e0decac25cc3afd805d24c6b719a/README.md#julia-projects)).
- Follow [this guide](https://julialang.org/contribute/developing_package/) to build Julia packages.
