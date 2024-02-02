if PE_DEBUG then
	GLOBAL.dprint = function(...)
		print(...)
	end
else
	GLOBAL.dprint = function(...)end
end