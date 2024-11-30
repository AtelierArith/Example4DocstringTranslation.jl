# Example4DocstringTranslation.jl

Can we translate documentation managed in `docs` in your preferred natural language? Let's find out. This repository is copied from https://github.com/JuliaLang/Example.jl which is licensed under MIT LICENSE.

## Usage

```
git clone https://github.com/AtelierArith/Example4DocstringTranslation.jl.git
cd Example4DocstringTranslation.jl
julia --project -e 'using Pkg; Pkg.instantiate()'
julia -e 'using Pkg; Pkg.activate(); Pkg.add(["Documenter", "LiveServer"])'
bash servedocs.sh
```
