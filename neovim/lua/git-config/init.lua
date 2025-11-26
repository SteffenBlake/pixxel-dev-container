local gitConflict = require("git-config.git-conflict-config")
local gitSigns = require("git-config.git-signs-config")

local M = {}

function M.setup(ctx)
    gitConflict.setup(ctx)
    gitSigns.setup(ctx)
end

function M.run()
    gitConflict.run()
    gitSigns.run()
end

return M
