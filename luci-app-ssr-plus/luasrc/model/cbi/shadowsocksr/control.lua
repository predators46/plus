require "luci.ip"
require "nixio.fs"
local m, s, o

m = Map("shadowsocksr")

s = m:section(TypedSection, "access_control")
s.anonymous = true

-- Interface control
s:tab("Interface", translate("Interface control"))
o = s:taboption("Interface", DynamicList, "Interface", translate("Interface"))
o.template = "cbi/network_netlist"
o.widget = "checkbox"
o.nocreate = true
o.unspecified = true
o.description = translate("Listen only on the given interface or, if unspecified, on all")

-- Part of WAN
s:tab("wan_ac", translate("WAN IP AC"))

o = s:taboption("wan_ac", DynamicList, "wan_bp_ips", translate("WAN White List IP"))
o.datatype = "ip4addr"

o = s:taboption("wan_ac", DynamicList, "wan_fw_ips", translate("WAN Force Proxy IP"))
o.datatype = "ip4addr"

-- Part of LAN
s:tab("lan_ac", translate("LAN IP AC"))

o = s:taboption("lan_ac", ListValue, "lan_ac_mode", translate("LAN Access Control"))
o:value("0", translate("Disable"))
o:value("w", translate("Allow listed only"))
o:value("b", translate("Allow all except listed"))
o.rmempty = false

o = s:taboption("lan_ac", DynamicList, "lan_ac_ips", translate("LAN Host List"))
o.datatype = "ipaddr"
luci.ip.neighbors({family = 4}, function(entry)
	if entry.reachable then
		o:value(entry.dest:string())
	end
end)
o:depends("lan_ac_mode", "w")
o:depends("lan_ac_mode", "b")

o = s:taboption("lan_ac", DynamicList, "lan_bp_ips", translate("LAN Bypassed Host List"))
o.datatype = "ipaddr"
luci.ip.neighbors({family = 4}, function(entry)
	if entry.reachable then
		o:value(entry.dest:string())
	end
end)

o = s:taboption("lan_ac", DynamicList, "lan_fp_ips", translate("LAN Force Proxy Host List"))
o.datatype = "ipaddr"
luci.ip.neighbors({family = 4}, function(entry)
	if entry.reachable then
		o:value(entry.dest:string())
	end
end)

o = s:taboption("lan_ac", DynamicList, "lan_gm_ips", translate("Game Mode Host List"))
o.datatype = "ipaddr"
luci.ip.neighbors({family = 4}, function(entry)
	if entry.reachable then
		o:value(entry.dest:string())
	end
end)

-- Part of Self
-- s:tab("self_ac", translate("Router Self AC"))
-- o = s:taboption("self_ac",ListValue, "router_proxy", translate("Router Self Proxy"))
-- o:value("1", translatef("Normal Proxy"))
-- o:value("0", translatef("Bypassed Proxy"))
-- o:value("2", translatef("Forwarded Proxy"))
-- o.rmempty = false

return m
