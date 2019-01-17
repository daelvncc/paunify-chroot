--> # pantheon/paunify
--> CC+Pantheon compatibility library
--> ## paunify-chroot
--> Filesystem prefixing
import convert, revert, mountTable from require "paunify.harbor"

--> # make_chroot
--> Creates a chroot function which can take a file to enter the chroot.
make_chroot = (path) ->
  --> Make directory if it doesn't exist
  unless fs.isDir path
    fs.makeDir path
  --> Create hvfs
  hvfs = mountTable convert path
  --> Setup environment
  env = setmetatable {
    fs: hvfs
  }, {__index: _G}
  --> chroot function - takes the file
  (file="/rom/programs/advanced/multishell.lua") ->
    fn, err = loadfile file, env
    unless fn
      return false, "paunify-chroot $ could not load file"
    fn!
    --> Check that it's the same env. If it's not, then no saves will be changed
    if env.fs == hvfs
      unless revert env.fs, path
        return false, "paunify-chroot $ could not revert hvfs"
    else
      return false, "paunify-chroot $ corrupted root - fs API is not hvfs"
  --

{ :make_chroot }
