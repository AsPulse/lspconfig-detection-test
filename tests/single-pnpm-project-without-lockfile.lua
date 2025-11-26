--- @type TestCase
return {
  name = "single pnpm project without lockfile",
  fixture_source = "single-pnpm-project-without-lockfile",
  current_dir = "",
  target = "main.ts",
  prepare = function(_, ready) ready() end,
  desired = {
    kind = "node",
    root_dir = "./",
  },
}
