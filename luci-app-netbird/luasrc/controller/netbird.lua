module("luci.controller.netbird", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/netbird") then
		return
	end

	entry({"admin", "services", "netbird"}, cbi("netbird"), _("Netbird"), 30).dependent = true
	entry({"admin", "services", "netbird", "status"}, call("act_status")).leaf = true
end

function act_status()
	local sys = require "luci.sys"
	local status = sys.exec("/usr/bin/netbird status 2>/dev/null")
	if status == "" then
		status = "Netbird is not running or not installed."
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({status = status})
end
