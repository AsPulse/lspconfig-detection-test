--- @type TestCase
return {
  name = "deno project with package.json",
  fixture_source = "deno-package-json",
  current_dir = "",
  target = "main.ts",
  prepare = function(_, ready) ready() end,
  desired = {
    kind = "deno",
    root_dir = "./",
  },
}
