-- Homebrew's keg-only JDK and dotnet wrapper are not always visible to apphosts.
if vim.fn.has 'macunix' == 1 then
  if not vim.env.JAVA_HOME or vim.fn.isdirectory(vim.env.JAVA_HOME) == 0 then
    for _, prefix in ipairs { '/opt/homebrew', '/usr/local' } do
      local java_home = prefix .. '/opt/openjdk/libexec/openjdk.jdk/Contents/Home'
      if vim.fn.executable(java_home .. '/bin/java') == 1 then
        vim.env.JAVA_HOME = java_home
        break
      end
    end
  end
  if vim.env.JAVA_HOME and vim.fn.executable(vim.env.JAVA_HOME .. '/bin/java') == 1 then
    vim.env.PATH = vim.env.JAVA_HOME .. '/bin:' .. vim.env.PATH
  end
end

if vim.fn.executable 'dotnet' == 1 and (not vim.env.DOTNET_ROOT or vim.fn.isdirectory(vim.env.DOTNET_ROOT .. '/shared') == 0) then
  local runtimes = vim.system({ 'dotnet', '--list-runtimes' }, { text = true }):wait(3000)
  local shared = runtimes.code == 0 and (runtimes.stdout or ''):match '%[([^\r\n]+/shared)/Microsoft%.NETCore%.App%]'
  if shared then
    vim.env.DOTNET_ROOT = vim.fs.dirname(shared)
  end
end
