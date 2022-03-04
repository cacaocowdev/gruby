module ApplicationHelper

    def markdown (text)
        options = %i[
            hard_wrap autolink no_intra_emphasis tables fenced_code_blocks
            disable_indented_code_blocks strikethrough lax_spacing space_after_headers
            quote footnotes highlight underline escape_html
        ]

        $redcarpet_markdown.render(text)
    end
end
