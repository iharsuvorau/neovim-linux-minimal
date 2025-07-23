vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- mini.nvim setup
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    -- '--branch', 'stable',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package }})
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Other

now(function()
  vim.o.termguicolors = true
  vim.cmd('colorscheme miniwinter')
end)

now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)

now(function() require('mini.icons').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.statusline').setup() end)

later(function() require('mini.ai').setup() end)
later(function() require('mini.jump').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.pick').setup() end)

now(function()
  add({
    source = 'neovim/nvim-lspconfig',
    depends = {'williamboman/mason.nvim'},
  })
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  -- Possible to immediately execute code which depends on the added plugin
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc' },
    highlight = { enable = true },
  })
end)

later(function() 
  add({
    source = 'stevearc/oil.nvim'
  })

  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  require('oil').setup({
    default_file_explorer=true,
    delete_to_trash=true,
    keymaps={
      ['gd']=function() 
        require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime'}
      end,
      ['<C-r>'] = 'refresh',
    }
  })
end)


later(function() 
  add({
    source = 'nvim-telescope/telescope.nvim',
    depends = { 'nvim-lua/plenary.nvim' }
  })

  require('telescope').setup()
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  -- Slightly advanced example of overriding default behavior and theme
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })
  -- It's also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = '[S]earch [/] in Open Files' })
  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
  end, { desc = '[S]earch [N]eovim files' })
end)

later(function() 
  add({
    source = 'nvim-neo-tree/neo-tree.nvim',
    depends = { 'MunifTanjim/nui.nvim' }
  })

  require('neo-tree').setup({
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window'
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        }
      }
    }
  })
  vim.keymap.set('n', '\\', ':Neotree reveal<cr>', {desc = 'NeoTree reveal', silent=true})
end)

later(function()
  add({
    source = 'kdheepak/lazygit.nvim',
    depends = { 'nvim-lua/plenary.nvim' }
  })

  vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
end)
