local buflog = require('runner/buflog').log
local testcase = require('runner/testcase')

require('runner/buflog').init()

buflog('[lsp-config-detection-test] v0.1.0')
buflog('')
buflog('Loading the implementation...')

local logic = require('implements/main')

buflog('Loading testcases...')

--- @type TestCase[]
local testcases = (function()
  local list = {}
  local files = vim.fn.glob('tests/*.lua', false, true) ---@type string[]

  table.sort(files)

  for _, f in ipairs(files) do
    local ok, res = pcall(dofile, f)
    if not ok then
      buflog(('  Skipped %s: %s'):format(f, tostring(res)))
    else
      if type(res) == 'table' then
        if #res > 0 then
          for _, tc in ipairs(res) do table.insert(list, tc) end
        else
          table.insert(list, res)
        end
      else
        buflog(('  Skipped %s: unexpected return type'):format(f))
      end
    end
  end

  return list
end)()

local num_testcases = #testcases
local num_passed = 0

buflog(('Loaded %d testcases.'):format(num_testcases))
buflog('')

if num_testcases == 0 then
  buflog('No testcases found under tests/. Nothing to run.')
  return
end

local uv = vim.uv

-- if dst_root exists, remove it first
if uv.fs_stat('dist/') then
  uv.fs_rmdir('dist/')
end

uv.fs_mkdir('dist/', tonumber('755', 8))

buflog('Running testcases...')
buflog('')


local function run_next(i)
  if i > num_testcases then
    buflog(('Run %d testcases, %d passed, %d failed.'):format(
      num_testcases,
      num_passed,
      num_testcases - num_passed
    ))
    return
  end
  local case = testcases[i]
  testcase.run(logic, case, function(passed)
    if passed then num_passed = num_passed + 1 end
    run_next(i + 1)
  end)
end

run_next(1)
