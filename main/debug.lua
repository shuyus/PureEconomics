-- debug.lua
-- Author: 勿言
-- LastEdit: 2024.1.31
-- Using: DEBUG相关

G.PE_DEBUG = true

if PE_DEBUG then
	G.dprint = function(...)
		print(...)
	end
else
	G.dprint = function(...)end
end