local current_colorscheme = "default"
local keymapping = "<leader>cs"
local default_colorscheme_keymapping = "<leader>CD"
local colorscheme_file = vim.fn.expand("~/.config/nvim/colorscheme")

local colorscheme = {}

colorscheme.set_default_colorscheme = function()
  local file = io.open(colorscheme_file, "r")
  if file then
    current_colorscheme = file:read()
    file:close()
  end
  vim.cmd("colorscheme " .. current_colorscheme)
end


colorscheme.setup = function(opts)
  if opts.default_colorscheme then
    current_colorscheme = opts.default_colorscheme
  end
  if opts.nvim_config then
    colorscheme_file = opts.nvim_config .. "/colorscheme"
  end
  if opts.keymapping then
    keymapping = opts.keymapping
  end
  local builtin_loaded, builtin = pcall(require, "telescope.builtin")
  if builtin_loaded then
    vim.keymap.set("n", keymapping, builtin.colorscheme, { desc = "[C]olor[S]cheme" })
    vim.keymap.set("n", default_colorscheme_keymapping, colorscheme.set_default_colorscheme, { desc = "Set Default Colorscheme" })
  end
end


colorscheme.change = function(selected_colorscheme)
  vim.cmd("colorscheme " .. selected_colorscheme)
  if vim.g.neovide then
    local normal_highlight = vim.api.nvim_get_hl_by_name("Normal", true)
    if normal_highlight and normal_highlight.background then
      vim.g.neovide_background_color = string.format("%06x", normal_highlight.background)
      .. string.format("%x", (255 * vim.g.transparency))
    end
  end
end

colorscheme.save = function(selected_colorscheme)
  local file, err = io.open(colorscheme_file, "w")
  if file then
    file:write(tostring(selected_colorscheme))
    file:close()
    print(selected_colorscheme .. " saved as the default colorscheme")
  else
    print("Could not save colorschema: ", err)
  end
end

colorscheme.toggle_background = function()
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
  if vim.g.neovide then
    local normal_highlight = vim.api.nvim_get_hl_by_name("Normal", true)
    if normal_highlight and normal_highlight.background then
      vim.g.neovide_background_color = string.format("%06x", normal_highlight.background)
      .. string.format("%x", (255 * vim.g.transparency))
    end
  end
end

local telescope_loaded, telescope = pcall(require, "telescope.config")

if telescope_loaded then
	local actions_ok, actions = pcall(require, "telescope.actions")
	if not actions_ok then
		return
	end

	local action_state_ok, action_state = pcall(require, "telescope.actions.state")
	if not action_state_ok then
		return
	end

	telescope.set_pickers({
		colorscheme = {
			theme = "dropdown",
			prompt_prefix = "  > ",
			previewer = false,
			winblend = 10,
			mappings = {
				n = {
					["a"] = function()
						local entry = action_state.get_selected_entry()
						if entry then
							colorscheme.change(entry[1])
						end
					end,
					["<tab>"] = function(prompt_bufnr, _)
						actions.move_selection_next(prompt_bufnr)
						local entry = action_state.get_selected_entry()
						if entry then
							colorscheme.change(entry[1])
						end
					end,
					["<s-tab>"] = function(prompt_bufnr)
						actions.move_selection_previous(prompt_bufnr)
						local entry = action_state.get_selected_entry()
						if entry then
							colorscheme.change(entry[1])
						end
					end,
					["t"] = function()
						if vim.g.transparency then
							vim.g.transparency = vim.g.transparency + 0.02
							if vim.g.transparency > 1 then
								vim.g.transparency = 1
							end
						end
						if vim.g.neovide_transparency then
							vim.g.neovide_transparency = vim.g.neovide_transparency + 0.02
							if vim.g.neovide_transparency > 1 then
								vim.g.neovide_transparency = 1
							end
						end
						local entry = action_state.get_selected_entry()
						if entry then
							colorscheme.change(entry[1])
						end
					end,
					["<S-t>"] = function()
						if vim.g.transparency then
							vim.g.transparency = vim.g.transparency - 0.02
							if vim.g.transparency < 0 then
								vim.g.transparency = 0
							end
						end
						if vim.g.neovide_transparency then
							vim.g.neovide_transparency = vim.g.neovide_transparency - 0.02
							if vim.g.neovide_transparency < 0 then
								vim.g.neovide_transparency = 0
							end
						end
						local entry = action_state.get_selected_entry()
						if entry then
							colorscheme.change(entry[1])
						end
					end,
					["b"] = function()
						colorscheme.toggle_background()
					end,
					["S"] = function()
						local entry = action_state.get_selected_entry()
						if entry then
							colorscheme.save(entry[1])
						end
					end,
          ["D"] = function ()
            colorscheme.set_default_colorscheme()
          end
				},
				i = {
					["<C-a>"] = function()
						local entry = action_state.get_selected_entry()
						if entry then
							colorscheme.change(entry[1])
						end
					end,
					["<tab>"] = function(prompt_bufnr)
						actions.move_selection_next(prompt_bufnr)
						local entry = action_state.get_selected_entry()
						if entry then
							colorscheme.change(entry[1])
						end
					end,
					["<s-tab>"] = function(prompt_bufnr)
						actions.move_selection_previous(prompt_bufnr)
						local entry = action_state.get_selected_entry()
						if entry then
							colorscheme.change(entry[1])
						end
					end,
					["<C-b>"] = function()
						colorscheme.toggle_background()
					end,
					["<C-s>"] = function()
						local entry = action_state.get_selected_entry()
						if entry then
							colorscheme.save(entry[1])
						end
					end,
				},
			},
		},
	})
end

return colorscheme
