--- @type TestCase[]
return {
  {
    name = "outer file in deno workspace",
    fixture_source = "deno-workspace",
    current_dir = "",
    target = "main.ts",
    prepare = function(_, ready) ready() end,
    desired = {
      kind = "deno",
      root_dir = "./",
    },
  },
  {
    name = "file of package in deno workspace",
    fixture_source = "deno-workspace",
    current_dir = "",
    target = "add/main.ts",
    prepare = function(_, ready) ready() end,
    desired = {
      kind = "deno",
      root_dir = "./",
    },
  },
}
