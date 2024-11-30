using DocstringTranslationOllamaBackend
@switchlang! :Japanese

using Documenter, Example4DocstringTranslation

makedocs(modules = [Example4DocstringTranslation],
         sitename = "Example4DocstringTranslation.jl",
         format = Documenter.HTML()
         )

deploydocs(
    repo = "github.com/AtelierArith/Example4DocstringTranslation.jl.git",
    target = "build",
    deps   = nothing,
    make   = nothing,
    push_preview = true,
)
