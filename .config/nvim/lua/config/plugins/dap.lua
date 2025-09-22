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

      -- Helper function to find C++ executables
      local function find_executables()
        local build_dirs = { 'build', 'Build', 'cmake-build-debug', 'cmake-build-release', 'out' }
        local executables = {}
        
        for _, build_dir in ipairs(build_dirs) do
          local full_path = vim.fn.getcwd() .. '/' .. build_dir
          if vim.fn.isdirectory(full_path) == 1 then
            local handle = io.popen('find ' .. full_path .. ' -type f -executable 2>/dev/null')
            if handle then
              for file in handle:lines() do
                -- Skip shared libraries and object files
                if not file:match('%.so') and not file:match('%.a$') and not file:match('%.o$') and
                   not file:match('CMakeFiles') and not file:match('%.cmake$') then
                  table.insert(executables, file)
                end
              end
              handle:close()
            end
          end
        end
        
        return executables
      end 

      -- Setup mason-dap
      require('mason').setup()
      require('mason-nvim-dap').setup({
        ensure_installed = { 'debugpy', 'codelldb' }, -- Add more debuggers as needed
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

-- C++ handler
          codelldb = function(config)
            config.configurations = {
              {
                name = 'Launch (select executable)',
                type = 'codelldb',
                request = 'launch',
                program = function()
                  local executables = find_executables()
                  if #executables == 0 then
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                  elseif #executables == 1 then
                    return executables[1]
                  else
                    -- Use vim.ui.select for multiple executables
                    local selected = nil
                    vim.ui.select(executables, {
                      prompt = 'Select executable to debug:',
                      format_item = function(item)
                        return vim.fn.fnamemodify(item, ':t') .. ' (' .. vim.fn.fnamemodify(item, ':h') .. ')'
                      end,
                    }, function(choice)
                      selected = choice
                    end)
                    
                    -- Fallback if selection fails
                    return selected or vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                  end
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = function()
                  local args_string = vim.fn.input('Arguments: ')
                  if args_string == '' then
                    return {}
                  end
                  return vim.split(args_string, " +")
                end,
              },
              {
                name = 'Launch with input',
                type = 'codelldb',
                request = 'launch',
                program = function()
                  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = function()
                  local args_string = vim.fn.input('Arguments: ')
                  if args_string == '' then
                    return {}
                  end
                  return vim.split(args_string, " +")
                end,
              },
              {
                name = 'Launch tests',
                type = 'codelldb',
                request = 'launch',
                program = function()
                  local executables = find_executables()
                  local test_executables = {}
                  
                  -- Filter for test executables
                  for _, exe in ipairs(executables) do
                    local name = vim.fn.fnamemodify(exe, ':t'):lower()
                    if name:match('test') or name:match('gtest') or name:match('catch') then
                      table.insert(test_executables, exe)
                    end
                  end
                  
                  if #test_executables == 0 then
                    return vim.fn.input('Path to test executable: ', vim.fn.getcwd() .. '/', 'file')
                  elseif #test_executables == 1 then
                    return test_executables[1]
                  else
                    local selected = nil
                    vim.ui.select(test_executables, {
                      prompt = 'Select test executable:',
                      format_item = function(item)
                        return vim.fn.fnamemodify(item, ':t')
                      end,
                    }, function(choice)
                      selected = choice
                    end)
                    return selected or test_executables[1]
                  end
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = function()
                  local filter = vim.fn.input('Test filter (optional): ')
                  if filter ~= '' then
                    return { '--gtest_filter=' .. filter }
                  end
                  return {}
                end,
              },
              {
                name = 'Attach to process',
                type = 'codelldb',
                request = 'attach',
                pid = function()
                  local handle = io.popen('ps -eo pid,comm --no-headers')
                  if not handle then
                    return tonumber(vim.fn.input('PID: '))
                  end
                  
                  local processes = {}
                  for line in handle:lines() do
                    local pid, name = line:match('%s*(%d+)%s+(.+)')
                    if pid and name then
                      table.insert(processes, { pid = pid, name = name, display = pid .. ': ' .. name })
                    end
                  end
                  handle:close()
                  
                  local selected = nil
                  vim.ui.select(processes, {
                    prompt = 'Select process to attach to:',
                    format_item = function(item)
                      return item.display
                    end,
                  }, function(choice)
                    selected = choice and tonumber(choice.pid)
                  end)
                  
                  return selected or tonumber(vim.fn.input('PID: '))
                end,
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
