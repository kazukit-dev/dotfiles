local map = vim.keymap.set

-- Exit insert mode
map("i", "jj", "<Esc>")

-- Enter command mode with ;
map("n", ";", ":")

-- Save file
map({ "n", "i" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Window split
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split horizontal" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split vertical" })
map("n", "<leader>wq", "<cmd>close<cr>", { desc = "Close window" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize window sizes" })
map("n", "<leader>wm", "<cmd>only<cr>", { desc = "Maximize window (close others)" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>")
map("n", "<S-l>", "<cmd>bnext<cr>")
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Exit terminal mode
map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
