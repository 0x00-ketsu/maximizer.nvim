local config = require('maximizer.config')
local window = require('maximizer.window')

local M = {}

M.setup = function(opts)
  config.setup(opts)
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
