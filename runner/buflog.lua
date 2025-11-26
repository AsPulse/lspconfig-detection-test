local M = {};

local api = vim.api
local buf


function M.init()
  buf = api.nvim_create_buf(false, true)
  api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  api.nvim_set_option_value('swapfile', false, { buf = buf })

  api.nvim_set_current_buf(buf)
end

--- @param text string
M.log = vim.schedule_wrap(function(text)
  api.nvim_set_option_value('modifiable', true, { buf = buf })
  api.nvim_buf_set_lines(buf, -2, -1, false, { text })
  api.nvim_buf_set_lines(buf, -1, -1, false, { '' })
  api.nvim_win_set_cursor(0, { api.nvim_buf_line_count(buf), 0 })
  api.nvim_set_option_value('modifiable', false, { buf = buf })
end)

return M;
