local convert, revert, mountTable
do
  local _obj_0 = require("harbor")
  convert, revert, mountTable = _obj_0.convert, _obj_0.revert, _obj_0.mountTable
end
local make_chroot
make_chroot = function(path)
  if not (fs.isDir(path)) then
    fs.makeDir(path)
  end
  local hvfs = mountTable(convert(path))
  local env = setmetatable({
    fs = hvfs
  }, {
    __index = _G
  })
  return function(file)
    if file == nil then
      file = "/rom/programs/advanced/multishell.lua"
    end
    local fn, err = loadfile(file, env)
    if not (fn) then
      return false, "paunify-chroot $ could not load file"
    end
    fn()
    if env.fs == hvfs then
      if not (revert(env.fs, path)) then
        return false, "paunify-chroot $ could not revert hvfs"
      end
    else
      return false, "paunify-chroot $ corrupted root - fs API is not hvfs"
    end
  end
end
return {
  make_chroot = make_chroot
}
