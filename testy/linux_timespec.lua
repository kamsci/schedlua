--linux.lua
--[[
	ffi routines for Linux.  
	To get full *nix support, we should use ljsyscall as that 
	has already worked out all the cross platform details.
	For now, we just want to get a minimum ste of routines
	that will work with x86_64 Linux

	As soon as this file becomes a few hundred lines, it's time
	to abandon it and switch to ljsyscall
--]]
local ffi = require("ffi")

local exports = {}
local C = {}	-- C interop, or syscall


local timespec = ffi.typeof("struct timespec")
local timespec_mt = {
	__add = function(lhs, rhs)
		local newspec = timespec();
		newspec:setFromSeconds(lhs:seconds()+rhs:seconds())

		return newspec;
	end;

	__sub = function(lhs, rhs)
		local newspec = timespec();
		newspec:setFromSeconds(lhs:seconds()-rhs:seconds())

		return newspec;
	end;	

	__tostring = function(self)
		return string.format("%d.%d", tonumber(self.tv_sec), tonumber(self.tv_nsec));
	end;

	__index = {
		gettime = function(self, clockid)
			clockid = clockid or ffi.C.CLOCK_REALTIME;
			local res = ffi.C.clock_gettime(clockid, self)
			return res;
		end;
		
		getresolution = function(self, clockid)
			clockid = clockid or ffi.C.CLOCK_REALTIME;
			local res = ffi.C.clock_getres(clockid, self);
			return res;
		end;

		setFromSeconds = function(self, seconds)
			-- the seconds without fraction can become tv_sec
			local secs, frac = math.modf(seconds)
			local nsecs = frac * 1000000000;
			self.tv_sec = secs;
			self.tv_nsec = nsecs;

			return true;
		end;

		seconds = function(self)
			return tonumber(self.tv_sec) + (tonumber(self.tv_nsec) / 1000000000);	-- one billion'th of a second
		end;

	};
}
ffi.metatype(timespec, timespec_mt)
exports.timespec = timespec;

function exports.sleep(seconds, clockid, flags)
	clockid = clockid or ffi.C.CLOCK_REALTIME;
	flags = flags or 0
	local request = timespec();
	local remain = timespec();

	request:setFromSeconds(seconds);
	local res = ffi.C.clock_nanosleep(clockid, flags, request, remain);

	return remain:seconds();
end



exports.C = C;

setmetatable(exports, {
	__call = function(self)
		for k,v in pairs(exports) do
			_G[k] = v;
		end
	end;
})

return exports
