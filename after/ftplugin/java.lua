local lombok_jar = vim.fn.expand '$MASON/share/jdtls/lombok.jar'
local lombok_arg = string.format('--jvm-arg=-javaagent:%s', lombok_jar)

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = '/home/kdepayso/projects/jdtls-data/' .. project_name

local bundles = {
  vim.fn.glob('/home/kdepayso/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', 1),
}

local java_test_bundles = vim.split(vim.fn.glob('/home/kdepayso/.local/share/nvim/mason/packages/java-test/extension/server/*.jar', 1), '\n')
local excluded = {
  'com.microsoft.java.test.runner-jar-with-dependencies.jar',
  'jacocoagent.jar',
}
for _, java_test_jar in ipairs(java_test_bundles) do
  local fname = vim.fn.fnamemodify(java_test_jar, ':t')
  if not vim.tbl_contains(excluded, fname) then
    table.insert(bundles, java_test_jar)
  end
end

local config = {
  cmd = {
    'jdtls',
    '-data',
    workspace_dir,
    lombok_arg,
  },

  root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-21',
            path = '/usr/lib/jvm/java-21-openjdk/',
          },
          {
            name = 'JavaSE-17',
            path = '/usr/lib/jvm/java-17-openjdk/',
          },
        },
      },
    },
  },

  init_options = {
    bundles = bundles,
  },
}

require('jdtls').start_or_attach(config)
