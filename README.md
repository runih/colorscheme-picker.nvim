# colorscheme-picker.nvim

Colorscheme Picker For NeoVim

![colorscheme-picker](https://github.com/runih/colorscheme-picker.nvim/assets/17590245/2a9a251a-0448-45a2-9ec2-d28b471e93ff)

## Requirements

This plugin is dependent on [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Installation

### Lazy

```lua
return {
  "runih/colorscheme-picker.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local ok, colorscheme = pcall(require, "colorscheme-picker")
    if not ok then
      print("Color Picker is not loaded")
      return
    end
    colorscheme.setup({
      default_colorscheme = "bamboo",
      keymapping = "<leader>cs",
    })
    colorscheme.set_default_colorscheme()
  end,
}
```

## Default Mappings

Default keymapping for open up the _colorscheme picker_ is with `<leader> cs`. This can be change by adding the settings propperty `keymapping`

### Insert Mode

| Mappings      | Action                                         |
| ------------- | ---------------------------------------------- |
| `<C-j>/<C-k>` | Next/previous                                  |
| `<C-a>`       | Apply colorscheme                              |
| `<Tab>`       | Next colorscheme and apply the colorscheme     |
| `<S-Tab>`     | Previous colorscheme and apply the colorscheme |
| `<C-b>`       | Toggle background between light and dark       |

### Normal Mode

| Mappings  | Action                                         |
| --------- | ---------------------------------------------- |
| `j/k`     | Next/previous                                  |
| `H/M/L`   | Select High/Middle/Low                         |
| `gg/G`    | Select the first/last item                     |
| `<CR>`    | Confirm selection                              |
| `a`       | Apply colorscheme                              |
| `t`       | Increase transparency (NeoVide)                |
| `T`       | Decrease transparency (NeoVide)                |
| `<Tab>`   | Next colorscheme and apply the colorscheme     |
| `<S-Tab>` | Previous colorscheme and apply the colorscheme |
| `b`       | Toggle background between light and dark       |
| `S`       | Save Default colorscheme                       |

## Default colorscheme file

Saved colorscheme will be stored in the file `~/.config/nvim/colorscheme`.
