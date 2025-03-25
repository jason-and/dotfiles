-- ~/.config/nvim/lua/core/utils.lua

local M = {}

-- Simple debugging utilities
M.debug = {
	-- Create a temporary scratchpad buffer for debugging
	scratch = function()
		vim.cmd("enew")
		vim.bo.buftype = "nofile"
		vim.bo.bufhidden = "hide"
		vim.bo.swapfile = false
		return vim.api.nvim_get_current_buf()
	end,

	-- Dump a variable to a scratch buffer
	dump_var = function(var, name)
		local buf = M.debug.scratch()
		name = name or "variable"

		local lines = {}
		table.insert(lines, "-- Debug dump of " .. name .. " at " .. os.date())
		table.insert(lines, "-- Type: " .. type(var))

		if type(var) == "table" then
			table.insert(lines, vim.inspect(var))
		else
			table.insert(lines, tostring(var))
		end

		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	end,

	-- Trace function calls (basic)
	trace = function(module_name, function_name)
		local original_module = require(module_name)
		local original_func = original_module[function_name]

		if not original_func then
			vim.notify("Function " .. function_name .. " not found in module " .. module_name, vim.log.levels.ERROR)
			return
		end

		original_module[function_name] = function(...)
			local args = { ... }
			vim.notify("Calling " .. module_name .. "." .. function_name, vim.log.levels.INFO)

			-- Print arguments if not too many
			if #args <= 3 then
				for i, arg in ipairs(args) do
					if type(arg) ~= "function" and type(arg) ~= "userdata" then
						vim.notify("  Arg " .. i .. ": " .. vim.inspect(arg):sub(1, 50))
					end
				end
			end

			-- Call original function
			return original_func(...)
		end

		vim.notify("Tracing enabled for " .. module_name .. "." .. function_name, vim.log.levels.INFO)
	end,
}

-- Add simple vim commands for debugging
vim.api.nvim_create_user_command("DumpVar", function(opts)
	local var_name = opts.args
	if var_name == "" then
		vim.notify("Please provide a variable name", vim.log.levels.ERROR)
		return
	end

	-- Try to get the variable from _G
	local var = _G[var_name]
	if var == nil then
		vim.notify("Variable " .. var_name .. " not found", vim.log.levels.ERROR)
		return
	end

	M.debug.dump_var(var, var_name)
end, {
	nargs = "?",
	complete = function()
		local vars = {}
		for k, _ in pairs(_G) do
			table.insert(vars, k)
		end
		return vars
	end,
})

-- Debug command to check vim-slime configuration
vim.api.nvim_create_user_command("CheckSlime", function()
	local lines = {}

	-- Check global settings
	table.insert(lines, "--- vim-slime Configuration ---")
	table.insert(lines, "")
	table.insert(lines, "Global settings:")
	table.insert(lines, "  slime_target = " .. tostring(vim.g.slime_target))
	table.insert(lines, "  slime_cell_delimiter = " .. tostring(vim.g.slime_cell_delimiter))
	table.insert(lines, "  slime_python_ipython = " .. tostring(vim.g.slime_python_ipython))
	table.insert(lines, "")

	-- Check buffer-local settings
	table.insert(lines, "Buffer settings:")
	table.insert(lines, "  filetype = " .. vim.bo.filetype)
	table.insert(lines, "  quarto_is_python_chunk = " .. tostring(vim.b.quarto_is_python_chunk))
	table.insert(lines, "  quarto_is_r_mode = " .. tostring(vim.b.quarto_is_r_mode))
	table.insert(lines, "  buffer slime_cell_delimiter = " .. tostring(vim.b.slime_cell_delimiter))

	-- Create a scratch buffer with the information
	local buf = M.debug.scratch()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end, {})

return M

