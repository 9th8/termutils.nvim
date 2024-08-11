vim.cmd("command! Terminal :lua require('termutils').Terminal()")

if vim.fn.executable("lf") == 1 then
  vim.cmd("command! -nargs=? -complete=dir Lf :lua require('termutils').Lf(<f-args>)")
end

if vim.fn.executable("lazygit") == 1 then
  vim.cmd("command! Lazygit :lua require('termutils').Lazygit(<f-args>)")
end
