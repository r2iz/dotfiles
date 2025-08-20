if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "vim",
      "go",
      "rust",
      "c",
      "cpp",
      "dockerfile",
      "fish",
      "typescript",
      "tsx",
      "javascript",
      "json",
      "lua",
      "gitignore",
      "bash",
      "astro",
      "markdown",
      "css",
      "scss",
      "yaml",
      "toml",
      "vue",
      "html",
    },
  },
}
