--- @type TestCase[]
return {
  {
    name = "outer file in pnpm workspace",
    fixture_source = "pnpm-workspace",
    current_dir = "",
    target = "main.ts",
    prepare = function(_, ready) ready() end,
    desired = {
      kind = "node",
      root_dir = "./",
    },
  },
  {
    name = "file of package in pnpm workspace",
    fixture_source = "pnpm-workspace",
    current_dir = "",
    target = "add/main.ts",
    prepare = function(_, ready) ready() end,
    desired = {
      kind = "node",
      root_dir = "./",
    },
  },
}

