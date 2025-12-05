local m, s, o

m = Map("netbird", translate("Netbird"), translate("Configure Netbird VPN"))

-- Status Section
s = m:section(NamedSection, "general", "netbird", translate("Status"))
s.template = "netbird/status"

-- Settings Section
s = m:section(NamedSection, "general", "netbird", translate("Settings"))
s.anonymous = true
s.addremove = false

o = s:option(Flag, "enabled", translate("Enabled"))
o.rmempty = false

o = s:option(Value, "management_url", translate("Management URL"))
o.placeholder = "https://api.netbird.io"
o.rmempty = false

o = s:option(Value, "setup_key", translate("Setup Key"))
o.password = true
o.rmempty = false

o = s:option(Flag, "allow_server_ssh", translate("Allow Server SSH"), translate("Allow SSH access from the Netbird server"))
o.rmempty = false

o = s:option(Flag, "enable_ssh_root", translate("Enable SSH Root"), translate("Enable SSH access for root user"))
o.rmempty = false

return m
