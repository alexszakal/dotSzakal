return {
  -- Core DAP plugin
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- Mason integration
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      
      -- UI for debugging
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      
      -- Virtual text support
      'theHamsta/nvim-dap-virtual-text',
      
      -- Telescope integration (optional)
      'nvim-telescope/telescope-dap.nvim',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      
      -- Helper function for Python path detection
      local function get_python_path()
        -- Check VIRTUAL_ENV environment variable
        local venv_path = os.getenv('VIRTUAL_ENV')
        if venv_path then
          return venv_path .. '/bin/python'
        end
        
        -- Check for poetry environment
        local handle = io.popen('poetry env info --path 2>/dev/null')
        if handle then
          local poetry_path = handle:read('*a'):gsub('\n$', '')
          handle:close()
          if poetry_path and poetry_path ~= '' then
            return poetry_path .. '/bin/python'
          end
        end
        
        -- Check for pipenv environment
        handle = io.popen('pipenv --venv 2>/dev/null')
        if handle then
          local pipenv_path = handle:read('*a'):gsub('\n$', '')
          handle:close()
          if pipenv_path and pipenv_path ~= '' then
            return pipenv_path .. '/bin/python'
          end
        end
        
        -- Look for common venv directories
        local cwd = vim.fn.getcwd()
        local common_venvs = { 'venv', '.venv', 'env', '.env' }
        for _, venv in ipairs(common_venvs) do
          local python_path = cwd .. '/' .. venv .. '/bin/python'
          if vim.fn.executable(python_path) == 1 then
            return python_path
          end
        end
        
        -- Fallback to system python
        return vim.fn.executable('python3') == 1 and 'python3' or 'python'
      end
      
      -- Setup mason-dap
      require('mason').setup()
      require('mason-nvim-dap').setup({
        ensure_installed = { 'debugpy' }, -- Add more debuggers as needed
        automatic_setup = true,
        handlers = {
          function(config)
            require('mason-nvim-dap').default_setup(config)
          end,
          
          python = function(config)
            config.configurations = {
              {
                type = 'python',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                pythonPath = get_python_path,
                console = 'integratedTerminal',
                cwd = '${workspaceFolder}',
              },
              {
                type = 'python',
                request = 'launch',
                name = 'Launch with args',
                program = '${file}',
                args = function()
                  local args_string = vim.fn.input('Arguments: ')
                  return vim.split(args_string, " +")
                end,
                pythonPath = get_python_path,
                console = 'integratedTerminal',
              },
              {
                type = 'python',
                request = 'launch',
                name = 'Test: Current file',
                module = 'pytest',
                args = { '${file}', '-v' },
                pythonPath = get_python_path,
                console = 'integratedTerminal',
              },
              {
                type = 'python',
                request = 'launch',
                name = 'Test: All tests',
                module = 'pytest',
                args = { '-v' },
                pythonPath = get_python_path,
                console = 'integratedTerminal',
              },
            }
            require('mason-nvim-dap').default_setup(config)
          end,
        }
      })
      
      -- Setup dap-ui
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10
          }
        }
      })
      
      -- Setup virtual text
      require('nvim-dap-virtual-text').setup()
      
      -- Auto-open/close dap-ui
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
      
      -- Keybindings
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, { desc = 'Debug: Set Conditional Breakpoint' })
      
      -- DAP UI keybindings
      vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })
      vim.keymap.set('n', '<leader>dr', dap.run_last, { desc = 'Debug: Run Last' })
      vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, { desc = 'Debug: Run to Cursor' })
      
      -- Python-specific shortcuts
      vim.keymap.set('n', '<leader>dt', function()
        dap.run({
          type = 'python',
          request = 'launch',
          module = 'pytest',
          args = { vim.fn.expand('%'), '-v' },
          pythonPath = get_python_path(),
          console = 'integratedTerminal',
        })
      end, { desc = 'Debug: Test current file' })
    end,
  },
  
  -- Optional: Telescope integration for DAP
  {
    'nvim-telescope/telescope.nvim',
    optional = true,
    config = function()
      pcall(require('telescope').load_extension, 'dap')
    end,
    keys = {
      { '<leader>dB', '<cmd>Telescope dap list_breakpoints<cr>', desc = 'Debug: List Breakpoints' },
      { '<leader>dC', '<cmd>Telescope dap commands<cr>', desc = 'Debug: Commands' },
      { '<leader>dV', '<cmd>Telescope dap variables<cr>', desc = 'Debug: Variables' },
      { '<leader>dF', '<cmd>Telescope dap frames<cr>', desc = 'Debug: Frames' },
    },
  },
}
