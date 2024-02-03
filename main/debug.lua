
G.PE_DEBUG = true

if PE_DEBUG then
	G.dprint = function(...)
		print(...)
	end
else
	G.dprint = function(...)end
end