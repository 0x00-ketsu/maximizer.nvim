---@param state boolean
local function set_maximized(state)
  vim.t.is_maximized = state
end

---@param win integer
local function disable_sidebar_features(win)
  vim.api.nvim_win_set_option(win, 'number', false)
  vim.api.nvim_win_set_option(win, 'relativenumber', false)
  vim.api.nvim_win_set_option(win, 'signcolumn', 'no')
end

---@return table
local function get_window_settings()
  local win_settings = {}
  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, win in ipairs(wins) do
    win_settings[tostring(win)] = {
      signcolumn = vim.api.nvim_win_get_option(win, 'signcolumn'),
      number = vim.api.nvim_win_get_option(win, 'number'),
      relativenumber = vim.api.nvim_win_get_option(win, 'relativenumber'),
    }
  end
  return win_settings
end

local function maximize_on()
  local cur_win = vim.fn.win_getid()
  for win, _ in pairs(vim.t.mx_win_settings) do
    local winnr = tonumber(win, 10)
    if cur_win ~= winnr then
      disable_sidebar_features(winnr)
    end
  end
end

local function maximize_off()
  -- Restore window(buffer) options before maximize
  for winnr, options in pairs(vim.t.mx_win_settings) do
    local winnr = tonumber(winnr, 10)
    if vim.api.nvim_win_is_valid(winnr) then
      for name, value in pairs(options) do
        vim.api.nvim_win_set_option(winnr, name, value)
      end
    end
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
  if vim.fn.winnr('$') == 1 then
    set_maximized(false)
    return
  end

  vim.t.mx_sizes = vim.fn.winrestcmd()
  vim.cmd('vert resize | resize')

  local win_settings = get_window_settings()
  vim.t.mx_win_settings = win_settings

  if next(win_settings) then
    maximize_on()
    set_maximized(true)
  else
    set_maximized(false)
  end
end

M.restore = function()
  if vim.t.is_maximized then
    vim.cmd(vim.t.mx_sizes)
  end

  if next(vim.t.mx_win_settings) then
    maximize_off()
  end

  set_maximized(false)
  vim.t.mx_win_settings = nil
end

return M
