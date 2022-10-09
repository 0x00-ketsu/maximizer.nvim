local api = vim.api
local fn = vim.fn

local utils = require('maximizer.utils')

local function is_valid()
  if vim.t.mx_win_settings and vim.tbl_count(vim.t.mx_win_settings) > 0 then
    return true
  else
    return false
  end
end

local function maximize_on()
  -- Reset option(s) for not maximized window(s)
  -- Except current window
  local win_options = {signcolumn = 'no'}
  for winnr, _ in pairs(vim.t.mx_win_settings) do
    local winnr = tonumber(winnr, 10)
    if fn.win_getid() ~= winnr then
      for name, value in pairs(win_options) do
        api.nvim_win_set_option(winnr, name, value)
      end
    end
  end
end

local function maximize_off()
  -- Revert option(s) for restored window(s)
  -- Except current window
  for winnr, options in pairs(vim.t.mx_win_settings) do
    local winnr = tonumber(winnr, 10)
    if fn.win_getid() ~= winnr then
      if api.nvim_win_is_valid(winnr) then
        for name, value in pairs(options) do
          api.nvim_win_set_option(winnr, name, value)
        end
      else
        vim.t.mx_win_settings = utils.tbl_remove_key(vim.t.mx_win_settings, tostring(winnr))
      end
    end
  end

  -- Restore signcolumn to `yes`
  for key, _ in pairs(vim.t.mx_win_settings) do
    local winnr = tonumber(key, 10)
    api.nvim_win_set_option(winnr, 'signcolumn', 'yes')
  end
end

local M = {}

M.toggle = function()
  if vim.t.is_maximized then
    M.restore()
  else
    M.maximize()
  end
end

M.maximize = function()
  -- Do nothing if only one window
  if fn.winnr('$') == 1 then
    return
  end

  vim.t.mx_sizes = vim.fn.winrestcmd()
  vim.cmd('vert resize | resize')

  local win_settings = {}
  for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
    win_settings[tostring(win)] = {signcolumn = api.nvim_win_get_option(win, 'signcolumn')}
  end

  vim.t.mx_win_settings = win_settings
  if is_valid() then
    maximize_on()
  end

  vim.t.is_maximized = true
end

M.restore = function()
  if vim.t.is_maximized then
    vim.cmd(vim.t.mx_sizes)
  end

  if is_valid() then
    maximize_off()
  end

  vim.t.mx_common_settings = nil
  vim.t.mx_win_settings = nil
  vim.t.is_maximized = false
end

return M
