local tsproject = require('runner/tsproject')
local buflog = require('runner/buflog').log

local M = {};

--- @class TestCase
--- @field name string
--- @field fixture_source string - Which source file from `fixtures/` should be used 
--- @field target string - File actually opened in Vim (path from fixture root)
--- @field current_dir string - Current directory in Vim (path from fixture root)
--- @field prepare fun(root_path: string, ready: fun())
--- @field desired TsProject? 

--- @param logic fun(source: integer | string): TsProject?
--- @param case TestCase
--- @param done fun(passed: boolean)
function M.run(logic, case, done)
  -- Copying `fixtures/{fixture_source}/` to `dist/` asynchronously
  local uv = vim.uv or vim.loop
  local src = 'fixtures/' .. case.fixture_source
  local dst_root = 'dist/' .. case.fixture_source

  local copy_handle

  --- @type fun()
  local ready

  --- @type fun(passed: boolean)
  local finalizer

  --- @diagnostic disable-next-line: missing-fields
  copy_handle = uv.spawn('cp', {
    args = { '-R', src, 'dist/' },
    stdio = { nil, nil, nil },
  }, function(code, signal)
    if code == 0 then
      case.prepare(dst_root, ready)
    else
      buflog(('[FAILED] %s'):format(case.name))
      buflog(('  cannot copy the fixture from source. (code=%s)'):format(tostring(code)))
      finalizer(false)
    end
    if copy_handle and not copy_handle:is_closing() then copy_handle:close() end
  end)

  ready = vim.schedule_wrap(function()

    -- Change working directory
    local old_cwd = vim.fn.getcwd()
    vim.api.nvim_set_current_dir(dst_root)

    -- Create a new buffer for the target file
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(bufnr, dst_root .. case.target)

    -- Run the implementation
    local result = logic(bufnr)
    if not (result == nil) then
      if vim.fn.getcwd() == result.root_dir then
        result.root_dir = './'
      else
        result.root_dir = vim.fn.fnamemodify(result.root_dir, ':.')
      end
    end

    -- Delete the buffer and restore cwd
    vim.api.nvim_buf_delete(bufnr, { force = true })
    vim.api.nvim_set_current_dir(old_cwd)

    -- Check the result

    if tsproject.eq(result, case.desired) then
      buflog(('[PASSED] %s'):format(case.name))
      finalizer(true)
    else
      buflog(('[FAILED] %s'):format(case.name))
      buflog(('  Expected: %s'):format(tsproject.debug(case.desired)))
      buflog(('  Actual  : %s'):format(tsproject.debug(result)))
      finalizer(false)
    end
  end)

  finalizer = function(passed)
    uv.fs_rmdir(dst_root, function()
      done(passed)
    end)
    buflog('')
  end

end

return M;
