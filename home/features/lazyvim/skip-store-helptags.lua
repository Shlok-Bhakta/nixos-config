-- lazy.nvim treats Nix `dev = true` plugins as local and runs :helptags
-- in their store paths. Skip writes into read-only directories.
local function writable_doc_dir(dir)
  return type(dir) == "string" and vim.fn.filewritable(dir) == 2
end

local orig_cmd = vim.api.nvim_cmd
vim.api.nvim_cmd = function(cmd, opts)
  if type(cmd) == "table" and cmd.cmd == "helptags" then
    local dir = cmd.args and cmd.args[1]
    if not writable_doc_dir(dir) then
      return ""
    end
  end
  return orig_cmd(cmd, opts)
end

local orig_command = vim.api.nvim_command
vim.api.nvim_command = function(command)
  local dir = type(command) == "string" and command:match("^helptags%s+(.+)$")
  if dir and not writable_doc_dir(dir) then
    return
  end
  return orig_command(command)
end
