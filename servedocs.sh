rm -rf docs/build

julia --project=docs/ -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd()));
                                               Pkg.instantiate()'
julia --project=docs/ docs/make.jl
julia -e 'using LiveServer; serve(dir=joinpath("docs", "build"))'