--- @type TestCase
return {
  name = "single deno project without lockfile",
  fixture_source = "single-deno-projects-without-lockfile",
  current_dir = "",
  target = "main.ts",
  prepare = function(_, ready) ready() end,
  desired = {
    kind = "deno",
    root_dir = "./",
  },
}
