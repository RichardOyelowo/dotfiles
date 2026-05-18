return {
    "RichardOyelowo/chatforge.nvim",

    cmd = {
        "Chat",
        "ChatSend",
        "ChatSetModel",
        "ChatReset",
        "ChatActivate",
        "ChatApply",
        "ChatAccept",
        "ChatDiff",
        "ChatYank",
        "ChatPreview",
        "ChatReject",
    },

    config = function()
        require("chatforge").setup({
            default_model = "qwen3-coder:480b-cloud",
            ollama_url = "http://localhost:11434",
        })
    end,
}
