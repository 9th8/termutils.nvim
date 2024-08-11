local M = {}

local temp_file

local function on_exit()
  M.closeCmd()

  if temp_file then
    local f = io.open(temp_file, "r")
    if f then
      for line in f:lines() do
        vim.cmd("edit " .. vim.fn.fnameescape(line))
      end
      f:close()
      os.remove(temp_file)
    end
  end

  vim.cmd("checktime")
end

local function createWin(bufname, cmd)
  M.buf = vim.api.nvim_create_buf(false, true)
  local win_height = math.ceil(vim.fn.winheight(0) * 0.9 - 2)
  local win_width = math.ceil(vim.fn.winwidth(0) * 0.9)
  local opts = {
    style = "minimal",
    relative = "editor",
    border = "rounded",
    width = win_width,
    height = win_height,
    row = math.ceil((vim.fn.winheight(0) - win_height) * 0.5),
    col = math.ceil((vim.fn.winwidth(0) - win_width) * 0.5)
  }

  M.win = vim.api.nvim_open_win(M.buf, true, opts)
  vim.bo[M.buf].filetype = vim.fn.tolower(bufname)

  vim.fn.termopen(cmd, { on_exit = function() on_exit() end })

  vim.api.nvim_command("startinsert")
  vim.wo[M.win].winhl = "Normal:TermutilsFloat,FloatBorder:TermutilsBorder"
  vim.wo[M.win].winblend = 0

  M.closeCmd = function()
    vim.api.nvim_win_close(M.win, true)
    vim.api.nvim_buf_delete(M.buf, { force = true })
  end
end

function M.Terminal()
  createWin("terminal", "/usr/bin/env fish")
end

function M.Lf(dir)
  temp_file = vim.fn.tempname()
  createWin("lf", "lf -command 'set hidden' -selection-path " .. vim.fn.shellescape(temp_file) .. ' ' .. (dir or vim.fn.expand('%:p:h')))
end

function M.Lazygit()
  createWin("lazygit", "lazygit")
end

return M
