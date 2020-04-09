--
-- Lib: xmlManager (for Farming Simulator 19)
--
-- Author: Hummel2211
-- email: 
-- @Date: 30.07.2019
-- @Version: 1.0.0.0

-- #############################################################################

local modName = "xmlManager"

	xmlManager = {}
	xmlManager.__index = xmlManager
	
	setmetatable(xmlManager, {
		__call = function (cls, ...)
			local self = setmetatable({}, cls)

			debug = 0
			self:new(...)
	
			return self
		end,
	})

--[[#####################################################################################################################################################################
###########################################################Erstelle Tabelle START							 ############################################################
#######################################################################################################################################################################]]

function xmlManager:new(modName)

	self.modName = modName;
	self.KonfigurationsdateiNeu 	= 1;
	self.KonfigurationsdateiAlt 	= 0;
	
	-- Pfad von Mod so wie zur XML
	self.modDirectory      = g_currentModDirectory;
	self.settingsDirectory = getUserProfileAppPath() .. "modsSettings/";
	self.confDirectory     = self.settingsDirectory .. self.modName .. "/";
	
	-- Speichert alle XML Einträge
	self.xmlEintraegeStandard = {};
	self.xmlEintraegeAktuell = {};
end;

--[[#####################################################################################################################################################################
###########################################################Erstelle Tabelle ENDE							 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################Löscht Tabelle Inhalte START						 ############################################################
#######################################################################################################################################################################]]

function xmlManager:clearConfig()
	self.xmlEintraegeStandard = {};
	self.xmlEintraegeAktuell = {};
end;

--[[#####################################################################################################################################################################
###########################################################Löscht Tabelle Inhalte ENDE						 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################Tabelle Erstellen START							 ############################################################
#######################################################################################################################################################################]]

function xmlManager:addConfigValue(section, name, typ, value, newLine)

	-- Erstellen einen leere Tabelle
	local newData = {};
	newData.section = section;
	newData.typ     = typ;
	newData.name    = name;
	newData.value   = value;
	newData.newLine = newLine or false;
	
	-- insert into our data storage
	table.insert(self.xmlEintraegeStandard, newData);
	table.insert(self.xmlEintraegeAktuell, newData);

end;

--[[#####################################################################################################################################################################
###########################################################Tabelle Erstellen ENDE							 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################Lese XML Datei aus START							 ############################################################
#######################################################################################################################################################################]]

function xmlManager:readConfig()

	-- Wen dedizierten Servern dann überspringen
	if g_dedicatedServerInfo ~= nil then
		return;
	end;
	
	self.xmlDatei = self.confDirectory .. self.modName .. "_v"..self.KonfigurationsdateiAlt..".xml";
	if debug > 0 then print("--> xmlDatei: "..self.xmlDatei) end;
	if not fileExists(self.xmlDatei) then
		if debug > 0 then print("---> Keine ältere Version") end;
		self.xmlDatei = self.confDirectory .. self.modName .. "_v"..self.KonfigurationsdateiNeu..".xml";
		if debug > 0 then print("--> xmlDatei: "..self.xmlDatei) end;
		if not fileExists(self.xmlDatei) then
		if debug > 0 then print("---> keine Konfigurationsdatei") end;
		return;
		end;
	end;

  local xml = loadXMLFile(self.modName, self.xmlDatei, self.modName)
	local pos = {};
	-- sortiere Daten nach Abschnitten
	local sortedKeys = self:getKeysSortedByValue(self.xmlEintraegeAktuell, function(a, b) return a.section < b.section end);
	
	for idx, key in ipairs(sortedKeys) do
		local data = self.xmlEintraegeAktuell[key];
		local group = data.section;
		if pos[group] ==  nil then
			pos[group] = 0;
		end;
    local groupNameTag = string.format("%s.%s(%d)", self.modName, group, pos[group]);
		if data.newLine then
			pos[group] = pos[group] + 1;
		end;
		if data.typ == "float" then
			self.xmlEintraegeAktuell[key].value = Utils.getNoNil(getXMLFloat(xml, groupNameTag .. "#" .. data.name), self.xmlEintraegeAktuell[key].value);
		end;
		if data.typ == "bool" then
			self.xmlEintraegeAktuell[key].value = Utils.getNoNil(getXMLBool(xml, groupNameTag .. "#" .. data.name), self.xmlEintraegeAktuell[key].value);
		end;
		if data.typ == "table" then
			self.xmlEintraegeAktuell[key].value = Utils.getNoNil(StringUtil.splitString(",", getXMLString(xml, groupNameTag .. "#" .. data.name)), self.xmlEintraegeAktuell[key].value);
		end;
	end;
end;

--[[#####################################################################################################################################################################
###########################################################Lese XML Datei aus Ende							 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################Erhalte  Konfigurationswert START				 ############################################################
#######################################################################################################################################################################]]

function xmlManager:getConfigValue(section, name)
	for idx, data in pairs(self.xmlEintraegeAktuell) do
		if data.section == section and data.name == name then
			if debug > 1 then print("---> typ: "..data.typ..", value: "..tostring(data.value)) end;
			return(data.value);
		end;
	end;
	
	return(nil);
end;

--[[#####################################################################################################################################################################
###########################################################Erhalte Konfigurationswert ENDE					 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################Gebe  Konfigurationswert START					 ############################################################
#######################################################################################################################################################################]]

function xmlManager:setConfigValue(section, name, value)

	-- Daten durchsuchen und Wert ändern
	for idx, data in pairs(self.xmlEintraegeAktuell) do
		if data.section == section and data.name == name then
			data.value = value;
		end;
	end;
	
	-- Starte XML schreib Funktion
	self:writeConfig();
	
	if debug > 0 then print(DebugUtil.printTableRecursively(self.xmlEintraegeAktuell, 0, 0, 3)) end;
end;

--[[#####################################################################################################################################################################
###########################################################Gebe  Konfigurationswert Ende					 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################Schreibe XML Datei START							 ############################################################
#######################################################################################################################################################################]]

function xmlManager:writeConfig()
  if debug > 0 then print("-> "..modName.." ("..self.modName..") writeConfig()") end
	
	-- Wen dedizierten Servern dann überspringen
	if g_dedicatedServerInfo ~= nil then
		return;
	end;
	
	-- Alte version Gefunden gelöscht
	self.xmlDatei = self.confDirectory .. self.modName .. "_v"..self.KonfigurationsdateiAlt..".xml";
	if debug > 0 then print("--> xmlDatei: "..self.xmlDatei) end;
	if fileExists(self.xmlDatei) then
		if debug > 0 then print("--->  Alte version Gefunden. Viert gelöscht") end;
	end;
	
	-- Neue xmlDatei erstellen
	self.xmlDatei = self.confDirectory .. self.modName .. "_v"..self.KonfigurationsdateiNeu..".xml";
	if debug > 0 then print("--> xmlDatei: "..self.xmlDatei) end;
	
	-- erstelle Ordner
	createFolder(self.settingsDirectory);
	createFolder(self.confDirectory);
	
	local xml = createXMLFile(self.modName, self.xmlDatei, self.modName);
	local pos = {};
	-- sortiere Daten nach Abschnitten
	local sortedKeys = self:getKeysSortedByValue(self.xmlEintraegeAktuell, function(a, b) return a.section..a.name < b.section..b.name end);
	
	for idx, key in ipairs(sortedKeys) do
		local data = self.xmlEintraegeAktuell[key];
		local group = data.section;
		if pos[group] ==  nil then
			pos[group] = 0;
		end;
		local groupNameTag = string.format("%s.%s(%d)", self.modName, group, pos[group]);
		if data.newLine then
			pos[group] = pos[group] + 1;
		end;
		if data.typ == "float" then
			setXMLFloat(xml, groupNameTag .. "#" .. data.name, tonumber(data.value));
		end;
		if data.typ == "bool" then
			setXMLBool(xml, groupNameTag .. "#" .. data.name, data.value);
		end;
		if data.typ == "table" then
			setXMLString(xml, groupNameTag .. "#" .. data.name, table.concat(data.value, ","));
		end;
	end;
	
	-- xml Datei Speichern
	saveXMLFile(xml);
	
	if debug > 0 then print(DebugUtil.printTableRecursively(self.xmlEintraegeAktuell, 0, 0, 3)) end;
end;

--[[#####################################################################################################################################################################
###########################################################Schreibe XML Datei ENDE							 ############################################################
#######################################################################################################################################################################]]






function xmlManager:getKeysSortedByValue(tbl, sortFunction)
  local keys = {};
	for key in pairs(tbl) do
		table.insert(keys, key);
	end;
	
	table.sort(keys, function(a, b)
		return sortFunction(tbl[a], tbl[b])
	end);
	
	return keys;
end;
