local M = { plugin_name = 'maximizer.nvim' }

-- Default configuration options
local defaults = {}

---Assign default options
---@param opts table|nil User-provided options
M.setup = function(opts)
  M.opts = vim.tbl_deep_extend('force', defaults, opts or {})
end

return M
