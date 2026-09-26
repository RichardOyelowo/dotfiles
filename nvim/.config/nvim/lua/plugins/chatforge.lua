return {
    "RichardOyelowo/chatforge.nvim",
    -- No external plugin dependencies. Only `curl` on $PATH is required at runtime.
    cmd = {
        "Chat",
        "ChatSend",
        "ChatEdit",
        "ChatModel",
        "ChatForgeSelectModel",
        "ChatForgeSetModel",
        "ChatReset",
        "ChatApply",
        "ChatAccept",
        "ChatDiff",
        "ChatReviewDiff",
        "ChatPreview",
        "ChatReject",
        "ChatNextChange",
        "ChatPrevChange",
        "ChatBackend",
        "ChatStop",
    },
    opts = {
        -- default_provider has no built-in value. Pick one, or leave it unset
        -- and run :ChatBackend switch <provider> the first time you open a buffer.
        default_provider = "groq",
        providers = {
            anthropic = { base_url = "https://api.anthropic.com", model = "claude-3-5-sonnet-20241022" },
            openai_compatible = { base_url = "https://api.openai.com/v1", model = "gpt-4o" },
            deepseek = { base_url = "https://api.deepseek.com", model = "deepseek-chat" },
            openrouter = { base_url = "https://openrouter.ai/api/v1", model = "nvidia/nemotron-3-ultra-550b-a55b:free" },
            groq = { base_url = "https://api.groq.com/openai/v1", model = "openai/gpt-oss-120b" },
            google = { base_url = "https://generativelanguage.googleapis.com/v1beta", model = "gemini-2.5-flash" },
            ollama = { url = "http://localhost:11434" },
        },
    },
}
