local M = {};

--- @class TsProject
--- @field kind '"node"' | '"deno"' | '"bun"'
--- @field root_dir string 

--- @param a TsProject?
--- @param b TsProject?
--- @return boolean
function M.eq(a, b)
  if a == nil and b == nil then
    return true
  end
  if a == nil or b == nil then
    return false
  end
  return a.kind == b.kind and a.root_dir == b.root_dir
end

--- @param tp TsProject?
--- @return string
function M.debug(tp)
  if tp == nil then
    return 'nil'
  end
  return '{ kind = ' .. tp.kind .. ', root_dir = ' .. tp.root_dir .. ' }'
end

return M;
