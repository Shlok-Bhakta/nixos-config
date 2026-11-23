return {
  {
    dir = vim.fn.stdpath("config"),
    name = "tabcomplete-trajectory",
    lazy = false,
    config = function()
      require("tabcomplete_trajectory").setup({
        server_url = vim.env.TABCOMPLETE_COLLECTOR_URL or "http://100.100.163.102:8787",
      })
    end,
  },
}
