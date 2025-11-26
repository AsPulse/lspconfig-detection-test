--- @type TestCase
return {
  name = "single deno project with lockfile",
  fixture_source = "single-deno-project-with-lockfile",
  current_dir = "",
  target = "main.ts",
  prepare = function(_, ready) ready() end,
  desired = {
    kind = "deno",
    root_dir = "./",
  },
}
