local config = require('maximizer.config')
local window = require('maximizer.window')

local function load_autocmd()
  vim.api.nvim_create_autocmd({ 'QuitPre', 'WinClosed' }, {
    pattern = { '*' },
    callback = function()
      -- Restore when only one window in tabpage
      local curwins = vim.api.nvim_tabpage_list_wins(0)
      if vim.t.is_maximized and #curwins == 2 then
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
