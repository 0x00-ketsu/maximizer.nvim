local M = {plugin_name = 'Maximizer'}
M.namespace = vim.api.nvim_create_namespace('Maximizer')

local defaults = {
}

---Assign default options
---
---@param opts any
M.setup = function(opts)
  M.opts = vim.tbl_deep_extend('force', {}, defaults, opts or {})
end

M.setup {}

return M
