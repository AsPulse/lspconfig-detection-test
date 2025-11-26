--- @type TestCase
return {
  name = "single pnpm project with lockfile",
  fixture_source = "single-pnpm-project-with-lockfile",
  current_dir = "",
  target = "main.ts",
  prepare = function(_, ready) ready() end,
  desired = {
    kind = "node",
    root_dir = "./",
  },
}
