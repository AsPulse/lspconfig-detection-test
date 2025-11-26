# lspconfig-detection-test


## Motivation

Currently, TypeScript projects are aimed at running on Node.js or Bun (hereinafter referred to as non-Deno projects) and those aimed at running on Deno.  
Therefore, simply detecting filetypes such as `typescript` or `typescriptreact` is not sufficient to set up the appropriate LSP.

Furthermore, LSP requires a root directory to be specified when it launches, which also needs to be correctly determined.

Due to these circumstances, the LSP launch logic has become complex, and this repository serves as a collection of test cases for it.

This is mainly to address issues occurring in [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), but this collection of test cases might be useful for any text editor.

## Run tests
1. Make sure you are in the root directory of this repository.
2. Launch nvim.
3. Run `:luafile runner/main.lua`.
