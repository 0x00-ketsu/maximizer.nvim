local config = require("maximizer.config")
local window = require("maximizer.window")

local function load_autocmd()
  vim.api.nvim_create_autocmd({ "QuitPre", "WinClosed" }, {
    pattern = { "*" },
    callback = function()
      if vim.t.is_maximized then
        window.restore()
      end
    end,
  })
end

return {
  setup = function(opts)
    config.setup(opts)
    load_autocmd()
  end,

  ---Toggle (maximize/restore) for current window
  toggle = window.toggle,

  ---Maximize current window
  maximize = window.maximize,

  ---Restore current window if has maximized
  restore = window.restore,
}
