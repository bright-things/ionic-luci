-- ToDo: Translate, Add descriptions and help texts
m = Map("wireless", "Netze", [[Pro WLAN-Gerät können mehrere Netze bereitgestellt werden.
Es sollte beachtet werden, dass es hardware- / treiberspezifische Einschränkungen gibt.
So kann pro WLAN-Gerät in der Regel entweder 1 Ad-Hoc-Zugang ODER bis zu 3 Access-Point und 1 Client-Zugang
gleichzeitig erstellt werden.]])

s = m:section(TypedSection, "wifi-iface")
s.addremove = true
s.anonymous = true

s:option(Value, "ssid", "Netzkennung (ESSID)").maxlength = 32

device = s:option(ListValue, "device", "Gerät")
local d = ffluci.model.uci.show("wireless").wireless
if d then
	for k, v in pairs(d) do
		if v[".type"] == "wifi-device" then
			device:value(k)
		end
	end
end

network = s:option(ListValue, "network", "Netzwerk", "WLAN-Netz zu Netzwerk hinzufügen")
network:value("")
for k, v in pairs(ffluci.model.uci.show("network").network) do
	if v[".type"] == "interface" and k ~= "loopback" then
		network:value(k)
	end
end

mode = s:option(ListValue, "mode", "Modus")
mode:value("ap", "Access Point")
mode:value("adhoc", "Ad-Hoc")
mode:value("sta", "Client")
mode:value("wds", "WDS")

s:option(Value, "bssid", "BSSID").optional = true

s:option(Value, "txpower", "Sendeleistung", "dbm").rmempty = true

s:option(Flag, "frameburst", "Broadcom-Frameburst").optional = true
s:option(Flag, "bursting", "Atheros-Frameburst").optional = true


encr = s:option(ListValue, "encryption", "Verschlüsselung")
encr:value("none", "keine")
encr:value("wep", "WEP")
encr:value("psk", "WPA-PSK")
encr:value("wpa", "WPA-Radius")
encr:value("psk2", "WPA2-PSK")
encr:value("wpa2", "WPA2-Radius")

key = s:option(Value, "key", "Schlüssel")
key:depends("encryption", "wep")
key:depends("encryption", "psk")
key:depends("encryption", "wpa")
key:depends("encryption", "psk2")
key:depends("encryption", "wpa2")
key.rmempty = true

server = s:option(Value, "server", "Radius-Server")
server:depends("encryption", "wpa")
server:depends("encryption", "wpa2")
server.rmempty = true

port = s:option(Value, "port", "Radius-Port")
port:depends("encryption", "wpa")
port:depends("encryption", "wpa2")
port.rmempty = true

s:option(Flag, "isolate", "AP-Isolation", "Unterbindet Client-Client-Verkehr").optional = true

s:option(Flag, "hidden", "ESSID verstecken").optional = true



return m