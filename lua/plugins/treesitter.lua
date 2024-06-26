-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "astro",
      "bash",
      "cpp",
      "css",
      "dockerfile",
      "elixir",
      "erlang",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "gotmpl",
      "gowork",
      "haskell",
      "html",
      "http",
      "java",
      "javascript",
      "jsdoc",
      "json",
      "json5",
      "just",
      "kotlin",
      "latex",
      "lua",
      "markdown",
      "nim",
      "nix",
      "php",
      "regex",
      "roc",
      "ruby",
      "rust",
      "scss",
      "sql",
      "ssh_config",
      "svelte",
      "swift",
      "templ",
      "todotxt",
      "toml",
      "tsx",
      "typescript",
      "v",
      "vim",
      "vhs",
      "yaml",
      "zig",
      -- add more arguments for adding more treesitter parsers
    })
  end,
}
