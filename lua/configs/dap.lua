
require("dapui").setup()
require("nvim-dap-virtual-text").setup()

local dap, dapui = require("dap"), require("dapui")

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local codelldb = mason_bin .. "/codelldb"

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = codelldb,
    args = { "--port", "${port}" },
    detached = false,
  },
}

local function build_cpp_debug_binary()
  if vim.fn.executable(codelldb) == 0 then
    vim.notify("CodeLLDB is not installed. Run :MasonInstall codelldb", vim.log.levels.ERROR)
    return dap.ABORT
  end

  local compiler = vim.fn.exepath("g++")
  if compiler == "" then
    vim.notify("g++ is required to build the current C++ file", vim.log.levels.ERROR)
    return dap.ABORT
  end

  local source = vim.fn.expand("%:p")
  if source == "" or vim.fn.filereadable(source) == 0 then
    vim.notify("Save the C++ file before starting the debugger", vim.log.levels.ERROR)
    return dap.ABORT
  end

  vim.cmd.write()

  local output_dir = vim.fn.stdpath("cache") .. "/nvim-dap"
  vim.fn.mkdir(output_dir, "p")

  local filename = vim.fn.fnamemodify(source, ":t:r")
  local source_hash = vim.fn.sha256(source):sub(1, 12)
  local executable = string.format("%s/%s-%s", output_dir, filename, source_hash)

  local result = vim.system({
    compiler,
    "-std=gnu++17",
    "-g3",
    "-O0",
    "-fno-omit-frame-pointer",
    "-Wall",
    "-Wextra",
    "-DLOCAL",
    source,
    "-o",
    executable,
  }, { text = true }):wait()

  if result.code ~= 0 then
    local output = vim.trim((result.stdout or "") .. "\n" .. (result.stderr or ""))
    vim.notify("C++ debug build failed:\n" .. output, vim.log.levels.ERROR)
    return dap.ABORT
  end

  local warnings = vim.trim(result.stderr or "")
  if warnings ~= "" then
    vim.notify("C++ debug build warnings:\n" .. warnings, vim.log.levels.WARN)
  end

  return executable
end

dap.configurations.cpp = {
  {
    name = "Build and debug current file",
    type = "codelldb",
    request = "launch",
    program = build_cpp_debug_binary,
    cwd = "${fileDirname}",
    stopOnEntry = false,
    terminal = "integrated",
    sourceLanguages = { "c++" },
  },
}

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
