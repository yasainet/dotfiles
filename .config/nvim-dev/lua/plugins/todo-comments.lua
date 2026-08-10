-- Usage: write the keyword in a comment, followed by a colon
--   FIX:   this is broken and must be fixed
--   TODO:  this should be done later
--   HACK: this works, but it is not clean
--   WARN:  read this before you touch it
--   PERF:  this is slow and can be faster
--   NOTE:  this explains why the code is like this
--   TEST:  this is about a test
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
  },
}
