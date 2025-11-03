<div align="center">

# lastplace.nvim

A forked rewrite for [`ethanholz/nvim-lastplace`](https://github.com/ethanholz/nvim-lastplace), which in of
itself is a Lua rewrite of [`farmergreg/vim-lastplace`](https://github.com/farmergreg/vim-lastplace).

</div>

> [!IMPORTANT]
> I plan to maintain this in the forseeable future, since the original has been archived.
>
> Any feedback is welcome!

---

## Installation

### Requirements

- Neovim `>=v0.8`

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'DrKJeff16/lastplace.nvim',
  lazy = false, -- WARNING: Lazy-loading is not supported currently!
  version = false,
  config = function()
    require('lastplace').setup()
  end
}
```

### [paq-nvim](https://github.com/savq/paq-nvim)

```lua
paq('DrKJeff16/lastplace.nvim')
```

---

## Configuration

To setup the function you may simply run the `setup()` function:

```lua
require('lastplace').setup()
```

The default setup options are:

```lua
{
  ignore = {
    bt = { 'quickfix', 'nofile', 'help' },
    ft = {
      'NvimTree',
      'TelescopePrompt',
      'TelescopeResults',
      'fzf',
      'gitcommit',
      'gitrebase',
      'hgcommit',
      'neo-tree',
      'snacks_picker_input',
      'svn',
      'ministarter',
    },
  },
  open_folds = true,
}
```

---

## Credits

- [@ethanholz](https://github.com/ethanholz) - For the original project this was forked from.
- [@farmergreg](https://github.com/farmergreg) - For the project the original was inspired from.
- [@vladdoster](https://github.com/vladdoster) - For [`vladdoster/remember.nvim`](https://github.com/vladdoster/remember.nvim).

---

## License

[MIT](./LICENSE)
