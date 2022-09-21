# maximizer.nvim

Maximize and restore the current window in Neovim.

## Installation

[Packer](https://github.com/wbthomason/packer.nvim)

```lua
-- Lua
use {
  "0x00-ketsu/maximizer.nvim",
  config = function()
    require("maximizer").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
}
```

## Setup

No settings yet!

## Keymaps

```lua
vim.api.nvim_set_keymap('n', 'mt', '<cmd>lua require("maximizer").toggle()<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', 'mm', '<cmd>lua require("maximizer").maximize()<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', 'mr', '<cmd>lua require("maximizer").restore()<CR>', {silent = true, noremap = true})
```

## API

- Check if current is maximized

  `vim.t.is_maximized`

  Example

  ```lua
  local maximizer_status = vim.t.is_maximized and '   ' or ''
  ```

## Inspiration by

[vim-maximizer](https://github.com/szw/vim-maximizer) by Szymon Wrozynski

## License

MIT
