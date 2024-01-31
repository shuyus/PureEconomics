if PE_DEBUG then
	GLOBAL.dprint = function(...)
		print("===dprint===", ...)
	end
else
	GLOBAL.dprint = function(...)end
end