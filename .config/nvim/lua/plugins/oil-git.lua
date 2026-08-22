return {
  "malewicz1337/oil-git.nvim",
  dependencies = { "stevearc/oil.nvim" },
  opts = {
    show_file_symbols = false,
    show_directory_symbols = false,
    highlights = {
      OilGitAdded = { fg = "#9ece6a" },
      OilGitModified = { fg = "#e0af68" },
      OilGitRenamed = { fg = "#bb9af7" },
      OilGitCopied = { fg = "#bb9af7" },
      OilGitDeleted = { fg = "#f7768e" },
      OilGitConflict = { fg = "#ff9e64" },
      OilGitUntracked = { fg = "#9ece6a" },
      OilGitIgnored = { fg = "#565f89" },
    },
  },
}
