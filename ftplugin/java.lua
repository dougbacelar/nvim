-- JDTLS (Java LSP) configuration
local jdtls = require 'jdtls'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.env.HOME .. '/jdtls-workspace/' .. project_name

-- Needed for debugging
local bundles = {
  vim.fn.glob(vim.env.HOME .. '/dev/java-debug/extension/server/com.microsoft.java.debug.plugin-0.53.1.jar'),
}

-- Needed for running/debugging unit tests
vim.list_extend(bundles, vim.split(vim.fn.glob(vim.env.HOME .. '/dev/java-test/extension/server/*.jar', 1), '\n'))

local jdtls_prefix = vim.fn.trim(vim.fn.system 'brew --prefix jdtls')
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  -- if failing to run LSP, try to run it manually e.g.
  -- java \
  -- -Declipse.application=org.eclipse.jdt.ls.core.id1 \
  -- -Dosgi.bundles.defaultStartLevel=4 \
  -- -Declipse.product=org.eclipse.jdt.ls.core.product \
  -- -Dlog.protocol=true \
  -- -Dlog.level=ALL \
  -- -Xmx4g \
  -- --add-modules=ALL-SYSTEM \
  -- --add-opens java.base/java.util=ALL-UNNAMED \
  -- --add-opens java.base/java.lang=ALL-UNNAMED \
  -- -jar /opt/homebrew/opt/jdtls/libexec/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar \
  -- -configuration /opt/homebrew/opt/jdtls/libexec/config_mac \
  -- -data ~/jdtls-workspace/test-files
  cmd = {
    -- use specific full path for reliability
    -- do not change JAVA_HOME to avoid conflicts with work environment
    -- make sure the version below is enough for running JDTLS!
    '/opt/homebrew/opt/openjdk@23/bin/java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    -- download lombok from https://projectlombok.org/downloads/lombok.jar if needed and uncomment below
    -- '-javaagent:' .. vim.env.HOME .. '/.local/share/nvim/mason/share/jdtls/lombok.jar',
    '-Xmx4g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    -- Eclipse jdtls location
    '-jar',
    jdtls_prefix .. '/libexec/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
    -- TODO Update this to point to the correct jdtls subdirectory for your OS (config_linux, config_mac, config_win, etc)
    '-configuration',
    jdtls_prefix .. '/libexec/config_mac',
    '-data',
    workspace_dir,
  },

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  settings = {
    java = {
      -- TODO Replace this with the absolute path to your main java version (JDK 17 or higher)
      -- output of echo $JAVA_HOME
      home = vim.fn.trim(vim.fn.system '/usr/libexec/java_home -v 17'),
      -- home = '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home',
      -- home = '/Library/Java/JavaVirtualMachines/jdk17.0.8.jdk/Contents/Home',
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        -- TODO Update this by adding any runtimes that you need to support your Java projects and removing any that you don't have installed
        -- The runtime name parameters need to match specific Java execution environments.  See https://github.com/tamago324/nlsp-settings.nvim/blob/2a52e793d4f293c0e1d61ee5794e3ff62bfbbb5d/schemas/_generated/jdtls.json#L317-L334
        runtimes = {
          -- {
          --   name = 'JavaSE-11',
          --   path = '/usr/lib/jvm/java-11-openjdk-amd64',
          -- },
          -- {
          --   name = 'JavaSE-17',
          --   path = '/usr/lib/jvm/java-17-openjdk-amd64',
          -- },
          -- {
          --   name = 'JavaSE-19',
          --   path = '/usr/lib/jvm/java-19-openjdk-amd64',
          -- },
          -- output of /usr/libexec/java_home -V
          --
          { name = 'JavaSE-17', path = vim.fn.trim(vim.fn.system '/usr/libexec/java_home -v 17') },
          -- { name = 'JavaSE-17', path = '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home' },
          -- { name = 'JavaSE-17', path = '/Library/Java/JavaVirtualMachines/jdk17.0.8.jdk/Contents/Home' },
        },
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      signatureHelp = { enabled = true },
      format = {
        enabled = true,
        -- Formatting works by default, but you can refer to a specific file/URL if you choose
        -- settings = {
        --   url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
        --   profile = "GoogleStyle",
        -- },
      },
    },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
      importOrder = {
        'java',
        'javax',
        'com',
        'org',
      },
    },
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
  },
  -- Needed for auto-completion with method signatures and placeholders
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    -- References the bundles defined above to support Debugging and Unit Testing
    bundles = bundles,
  },
}

-- Needed for debugging
config['on_attach'] = function(client, bufnr)
  jdtls.setup_dap { hotcodereplace = 'auto' }
  require('jdtls.dap').setup_dap_main_class_configs()
end

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
jdtls.start_or_attach(config)
