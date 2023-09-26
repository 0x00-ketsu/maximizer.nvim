local api = vim.api

local config = require('maximizer.config')
local window = require('maximizer.window')

local function load_autocmd()
  api.nvim_create_autocmd(
      {'QuitPre'}, {
        pattern = {'*'},
        callback = function()
          -- Restore when only one window in tabpage
          local curwins = api.nvim_tabpage_list_wins(0)
          if vim.t.is_maximized and #curwins == 2 then
            window.restore()
          end
        end
      }
  )
end

local M = {}

M.setup = function(opts)
  config.setup(opts)

  load_autocmd()
end

---Toggle (maximize/restore) for current window
---
M.toggle = function()
  window.toggle()
end

---Maximize current window
---
M.maximize = function()
  window.maximize()
end

---Restore current window if has maximized
---
M.restore = function()
  window.restore()
end

return M
