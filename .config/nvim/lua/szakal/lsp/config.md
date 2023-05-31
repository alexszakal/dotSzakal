## This is to remember the config steps for future reference

- The init.lua is called first which requires mason.lua and handlers.lua->setup() 

- The setting of the language servers is done by mason.lua
    - The settings for the individual language servers is stored in lsp/settings and it is read by mason.lua
    - The handlers.on_attach() and handlers.capabilities() functions are called from mason.lua. These functions hold general info.
    - handlers.lua functionalities:
        - The on_attach function sets LSP keybindings and DocumentHighlighting if there is such capability in the language server
        - 

- The specific configurations for the language servers are stored in lsp/settings directory. The available settings for the servers are listed in https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

