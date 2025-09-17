---@param state boolean
local function set_maximized(state)
  vim.t.is_maximized = state
end

---@param win integer
local function disable_sidebar_features(win)
  vim.api.nvim_set_option_value("number", false, { win = win })
  vim.api.nvim_set_option_value("relativenumber", false, { win = win })
  vim.api.nvim_set_option_value("signcolumn", "no", { win = win })
  vim.api.nvim_set_option_value("colorcolumn", "", { win = win })
  vim.api.nvim_set_option_value("foldcolumn", "0", { win = win })

  if pcall(vim.api.nvim_get_option_value, "winbar", { win = win }) then
    vim.api.nvim_set_option_value("winbar", "", { win = win })
  end

  if vim.fn.has("nvim-0.9") == 1 then
    vim.api.nvim_set_option_value("statuscolumn", "", { win = win })
  end
end

---@param win integer
local function get_sidebar_settings(win)
  return {
    signcolumn = vim.api.nvim_get_option_value("signcolumn", { win = win }),
    number = vim.api.nvim_get_option_value("number", { win = win }),
    relativenumber = vim.api.nvim_get_option_value("relativenumber", { win = win }),
    foldcolumn = vim.api.nvim_get_option_value("foldcolumn", { win = win }),
    colorcolumn = vim.api.nvim_get_option_value("colorcolumn", { win = win }),
    winbar = pcall(vim.api.nvim_get_option_value, "winbar", { win = win })
        and vim.api.nvim_get_option_value("winbar", { win = win })
      or nil,
    statuscolumn = vim.fn.has("nvim-0.9") == 1
        and vim.api.nvim_get_option_value("statuscolumn", { win = win })
      or nil,
  }
end

---@return table
local function get_window_settings()
  local win_settings = {}
  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, win in ipairs(wins) do
    win_settings[tostring(win)] = get_sidebar_settings(win)
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
        vim.api.nvim_set_option_value(name, value, { win = winnr })
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
  if vim.fn.winnr("$") == 1 then
    set_maximized(false)
    return
  end

  vim.t.mx_sizes = vim.fn.winrestcmd()

  -- Resize current window to maximum
  local cur_win = vim.fn.win_getid()
  local max_height = vim.o.lines - vim.o.cmdheight - 2 -- 2 for tabline/statusline
  local max_width = vim.o.columns
  vim.api.nvim_win_set_height(cur_win, max_height)
  vim.api.nvim_win_set_width(cur_win, max_width)

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
