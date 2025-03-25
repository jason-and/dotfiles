# Data Science Keybindings in Neovim

## Core Keybindings Philosophy

This setup follows an RStudio-like approach to code execution:

- **Ctrl+Enter (or Alt+Enter)**: Send the current line to the terminal
- **Shift+Enter**: Send the entire code block/cell/chunk

This is consistent across all supported file types (Python, R, Quarto, Markdown).

## Key Mappings

### Line/Selection Execution

| Keybinding | Mode | Action |
|------------|------|--------|
| `<C-Enter>` | Normal | Send current line to terminal |
| `<M-Enter>` | Normal | Send current line to terminal (alternative) |
| `<C-Enter>` | Insert | Send current line to terminal and stay in insert mode |
| `<M-Enter>` | Insert | Send current line to terminal and stay in insert mode |
| `<M-Enter>` | Visual | Send selected text to terminal |
| `<leader>sl` | Normal | Send current line to terminal |
| `<leader>sl` | Visual | Send selected text to terminal |

### Cell/Chunk Execution

| Keybinding | Mode | Action |
|------------|------|--------|
| `<S-Enter>` | Normal | Send code cell or chunk |
| `<S-Enter>` | Insert | Send code cell or chunk and stay in insert mode |
| `<leader><cr>` | Normal | Send code cell or chunk |
| `<leader>sc` | Normal | Send code cell (Python with `# %%` delimiter) |

### Terminal Management

| Keybinding | Mode | Action |
|------------|------|--------|
| `<leader>cm` | Normal | Mark terminal for code execution |
| `<leader>ct` | Normal | Configure terminal |
| `<leader>cp` | Normal | Open Python terminal |
| `<leader>ci` | Normal | Open IPython terminal |
| `<leader>cr` | Normal | Open R terminal |
| `<leader>cj` | Normal | Open Julia terminal |
| `<leader>cn` | Normal | Open shell terminal |

### Quarto/Markdown-specific

| Keybinding | Mode | Action |
|------------|------|--------|
| `<leader>op` | Normal | Insert Python code chunk |
| `<leader>or` | Normal | Insert R code chunk |
| `<leader>ol` | Normal | Insert Lua code chunk |
| `<leader>oj` | Normal | Insert Julia code chunk |
| `<leader>ob` | Normal | Insert Bash code chunk |
| `<leader>oo` | Normal | Insert Observable JS code chunk |
| `<leader>qR` | Normal | Toggle R mode for mixed Python/R workflows |

## Language-specific Features

### Python

| Keybinding | Mode | Action |
|------------|------|--------|
| `<leader>pr` | Normal | Run entire Python file |
| `<leader>pc` | Normal | Clear IPython terminal |
| `<leader>pd` | Normal | Add breakpoint at cursor |

### R

| Keybinding | Mode | Action |
|------------|------|--------|
| `<leader>rv` | Normal | View structure of object under cursor |
| `<leader>rh` | Normal | Get help for function under cursor |
| `<leader>rp` | Normal | Print object under cursor |
| `<leader>rs` | Normal | Summarize object under cursor |
| `<leader>rt` | Normal | View data.frame as HTML table |
| `<leader>rl` | Normal | List all objects in environment |
