using DocstringTranslationOllamaBackend
using DocstringTranslationOllamaBackend: translate_with_ollama, default_lang, default_model
@switchlang! :Japanese

using Documenter, Example4DocstringTranslation
using Documenter: Markdown

function promptfn(
    m::Union{Markdown.MD, AbstractString},
    language::String = default_lang(),
)
    prompt = """
You are an expert in the Julia programming language.
Please provide a faithful translation of the following Documenter.jl flavor Markdown in $(language).

\"\"\"
$(m)
\"\"\"

Keep in mind the following items:

- The translation should faithfully preserve the formatting of the original Markdown. 
- Do not translate quoted word. 
- Do not translateThe headings, where headings means text begin with #
- Do not add or remove unnecessary text. 
- Only return a faithful translation.
- Never stop until the translation is complete.:

Please start. Only return the result.
"""
    return prompt
end

# Overrides Page constructor to hack Documenter to translate docstrings
function Documenter.Page(source::AbstractString, build::AbstractString, workdir::AbstractString)
    # The Markdown standard library parser is sensitive to line endings:
    #   https://github.com/JuliaLang/julia/issues/29344
    # This can lead to different AST and therefore differently rendered docs, depending on
    # what platform the docs are being built (e.g. when Git checks out LF files with
    # CRFL line endings on Windows). To make sure that the docs are always built consistently,
    # we'll normalize the line endings when parsing Markdown files by removing all CR characters.
    mdsrc = replace(read(source, String), '\r' => "")
    mdpage = Markdown.parse(mdsrc)

    # begin DocstringTranslationOllamaBackend
    mdpage = translate_with_ollama(mdpage, default_lang(), default_model(), promptfn)
    @info "mdpage" mdpage
    # end DocstringTranslationOllamaBackend
    mdast = try
        convert(Documenter.MarkdownAST.Node, mdpage)
    catch err
        @error """
        MarkdownAST conversion error on $(source).
        This is a bug — please report this on the Documenter issue tracker
        """
        rethrow(err)
    end
    return Documenter.Page(source, build, workdir, mdpage.content, Documenter.Globals(), mdast)
end

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
