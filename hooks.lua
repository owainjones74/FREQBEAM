-- Master hook table
hook = {}
hook.cache = {}


-- Name | Add
-- Args | string event, string name, function func
-- Desc | Register a hook to be ran on provided event
function hook.Add(event, name, func)
	-- Complete validation
	if not func then return end
	if not name then return end
	if not event then return end
	if not hook.cache[event] then hook.cache[event] = {} end
	if hook.cache[event][name] then return end

	-- Register the hook under the provided event
	hook.cache[event][name] = func
end


-- Name | Remove
-- Args | string event, string name
-- Desc | Remove the identified hook from provided event
function hook.Remove(event, name)
	-- Complete validation
	if not event then return end
	if not name then return end
	if not hook.cache[event] then return end
	if not hook.cache[event][name] then return end
	
	-- Register the hook under the provided event
	hook.cache[event][name] = nil
end


-- Name | Call
-- Args | string event, vararg args
-- Desc | Calls the provided event and passes the given varargs
function hook.Call(event, ...)
	-- Complete validation
	if not event then return end
	if not hook.cache[event] then hook.cache[event] = {} end

	for k, v in pairs(hook.cache[event]) do
		v(...)
	end
end

