local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Window split
map("n", "s-", "<cmd>split<cr>", { desc = "Split horizontal" })
map("n", "s|", "<cmd>vsplit<cr>", { desc = "Split vertical" })
map("n", "sq", "<cmd>close<cr>", { desc = "Close window" })

-- Window navigation
map("n", "sh", "<C-w>h", { desc = "Move to left window" })
map("n", "sj", "<C-w>j", { desc = "Move to below window" })
map("n", "sk", "<C-w>k", { desc = "Move to above window" })
map("n", "sl", "<C-w>l", { desc = "Move to right window" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>")
map("n", "<S-l>", "<cmd>bnext<cr>")
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })
