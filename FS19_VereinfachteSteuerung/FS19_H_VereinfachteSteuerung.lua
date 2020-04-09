--
-- Mod: FS19_H_VereinfachteSteuerung
--
-- Author: Hummel2211
-- email: 
-- @Date: 11.06.2019
-- @Version: 1.3.0.6



debug = 0 -- 0=0ff, 1=some, 2=everything, 3=madness
local modName = "FS19_H_VereinfachteSteuerung"

-- #############################################################################

FS19_H_VereinfachteSteuerung = {}
FS19_H_VereinfachteSteuerung.modDirectory  = g_currentModDirectory
FS19_H_VereinfachteSteuerung.confDirectory = getUserProfileAppPath().. "modsSettings/FS19_H_VereinfachteSteuerung/"

-- for debugging purpose
H_dbg = false
H_dbg1 = 0
H_dbg2 = 0
H_dbg3 = 0

--[[#####################################################################################################################################################################
###########################################################Tasten Belegung									 ############################################################
#######################################################################################################################################################################]]

FS19_H_VereinfachteSteuerung.sections = { 'fuel', 'dmg', 'misc', 'rpm', 'temp', 'diff', 'shuttle' }
FS19_H_VereinfachteSteuerung.actions = {}

FS19_H_VereinfachteSteuerung.actions.global =    {}
													
FS19_H_VereinfachteSteuerung.actions.hydraulic = 			{ 	'FS19_H_VereinfachteSteuerung_AJ_hinten_vorne_HochRunter'	}
FS19_H_VereinfachteSteuerung.actions.hydraulicSeparat = 	{ 	'FS19_H_VereinfachteSteuerung_AJ_vorne_HochRunter',			
																'FS19_H_VereinfachteSteuerung_AJ_hinten_HochRunter'			} --,			
															--	'FS19_H_TESTEN'												}

FS19_H_VereinfachteSteuerung.actions.faltbar = 				{	'FS19_H_VereinfachteSteuerung_AJ_hinten_vorne_AufZU'		}
FS19_H_VereinfachteSteuerung.actions.faltbarSeparat = 		{	'FS19_H_VereinfachteSteuerung_AJ_vorne_AufZU',		
																'FS19_H_VereinfachteSteuerung_AJ_hinten_AufZU'				}												
													
FS19_H_VereinfachteSteuerung.actions.einschalten = 			{	'FS19_H_VereinfachteSteuerung_AJ_hinten_vorne_AnAus'		}
FS19_H_VereinfachteSteuerung.actions.einschaltenSeparat = 	{	'FS19_H_VereinfachteSteuerung_AJ_vorne_AnAus',		
																'FS19_H_VereinfachteSteuerung_AJ_hinten_AnAus'				}											
													
FS19_H_VereinfachteSteuerung.actions.abkoppeln = 			{	'FS19_H_VereinfachteSteuerung_AJ_vorne_abkoppeln',
																'FS19_H_VereinfachteSteuerung_AJ_hinten_abkoppeln'  		}
																
FS19_H_VereinfachteSteuerung.actions.kamera =				{	'FS19_H_VereinfachteSteuerung_CA_kamera'					}

												




if H_dbg then
  for _, v in pairs({ 'H_DBG1_UP', 'H_DBG1_DOWN', 'H_DBG2_UP', 'H_DBG2_DOWN', 'H_DBG3_UP', 'H_DBG3_DOWN' }) do
    table.insert(FS19_H_VereinfachteSteuerung.actions, v)
  end
end



-- Suchen Sie nach KeyboardSteer oder VehicleControlAddon
mogli_loaded = false
if g_modIsLoaded.FS19_KeyboardSteer ~= nil or g_modIsLoaded.FS19_VehicleControlAddon ~= nil then
  mogli_loaded = true
end

--[[#####################################################################################################################################################################
###########################################################specializations									 ############################################################
#######################################################################################################################################################################]]	

function FS19_H_VereinfachteSteuerung.prerequisitesPresent(specializations)
  if debug > 1 then print("-> " .. modName .. ": prerequisites ") end

  return true
end

--[[#####################################################################################################################################################################
###########################################################vehicleType										 ############################################################
#######################################################################################################################################################################]]

function FS19_H_VereinfachteSteuerung.registerEventListeners(vehicleType)
  if debug > 1 then print("-> " .. modName .. ": registerEventListeners ") end
 for _,n in pairs( { "onLoad", "onPostLoad", "saveToXMLFile", "onUpdate", "onDraw", "onReadStream", "onWriteStream", "onRegisterActionEvents", "onEnterVehicle", "onReverseDirectionChanged" } ) do
    SpecializationUtil.registerEventListener(vehicleType, n, FS19_H_VereinfachteSteuerung)
  end
end

--[[#####################################################################################################################################################################
###########################################################funktion_1 für andere Mods zum Aktivieren / Deaktivieren von EnhancedVehicle-Funktionen#########################
###########################################################Name: Hydraulik									 ############################################################
###########################################################state: true oder false							 ############################################################
#######################################################################################################################################################################]]

function FS19_H_VereinfachteSteuerung:functionEnable(name, state)
	if name == "hydraulic" then
		xmlM:setConfigValue("global.functions", "hydraulicIsEnabled", state)
		FS19_H_VereinfachteSteuerung.functionHydraulicIsEnabled = state
	end
  
	if name == "hydraulicSeparat" then
		xmlM:setConfigValue("global.functions", "hydraulicIsEnabledSeparat", state)
		FS19_H_VereinfachteSteuerung.functionHydraulicIsEnabledSeparat = state
	end
  
	if name == "faltbar" then
		xmlM:setConfigValue("global.functions", "faltbarEnabled", state)
		FS19_H_VereinfachteSteuerung.functionabFaltbarEnabled = state
	end
  
    if name == "faltbarSeparat" then
		xmlM:setConfigValue("global.functions", "faltbarEnabledSeparat", state)
		FS19_H_VereinfachteSteuerung.functionabFaltbarEnabledSeparat = state
	end
  
	if name == "einschalten" then
		xmlM:setConfigValue("global.functions", "einschaltenEnabled", state)
		FS19_H_VereinfachteSteuerung.functionabEinschaltenEnabled = state
	end
	
	if name == "einschaltenSeparat" then
		xmlM:setConfigValue("global.functions", "einschaltenEnabledSeparat", state)
		FS19_H_VereinfachteSteuerung.functionabEinschaltenEnabledSeparat = state
	end
  
	if name == "abkoppeln" then
		xmlM:setConfigValue("global.functions", "abkoppelnEnabled", state)
		FS19_H_VereinfachteSteuerung.functionabKoppelnEnabled = state
	end
	
		if name == "kamera" then
		xmlM:setConfigValue("global.functions", "kameraEnabled", state)
		FS19_H_VereinfachteSteuerung.functionabKameraEnabled = state
	end

end

--[[#####################################################################################################################################################################
###########################################################funktion_1 für andere Mods, um den Status der EnhancedVehicle Funktionen zu erhalten############################
###########################################################Name: Hydraulik									 ############################################################
###########################################################gibt true oder false zurück					     ############################################################
#######################################################################################################################################################################]]

function FS19_H_VereinfachteSteuerung:functionStatus(name)
	if debug > 1 then print("-> " .. modName .. ": functionStatus " .. "name" .. tostring(name)) end
	if name == "hydraulic" then
		return(xmlM:getConfigValue("global.functions", "hydraulicIsEnabled"))
	end

	if name == "hydraulic1Separat" then
		return(xmlM:getConfigValue("global.functions", "hydraulicIsEnabledSeparat"))
	end
	
	if name == "faltbar" then
		return(xmlM:getConfigValue("global.functions", "faltbarEnabled"))
	end
	
	if name == "faltbarSeparat" then
		return(xmlM:getConfigValue("global.functions", "faltbarEnabledSeparat"))
	end
	
	if name == "einschalten" then
		return(xmlM:getConfigValue("global.functions", "einschaltenEnabled"))
	end
	
	if name == "einschaltenSeparat" then
		return(xmlM:getConfigValue("global.functions", "einschaltenEnabledSeparat"))
	end
	
	if name == "abkoppeln" then
		return(xmlM:getConfigValue("global.functions", "abkoppelnEnabled"))
	end
	
	if name == "kamera" then
		return(xmlM:getConfigValue("global.functions", "kameraEnabled"))
	end

	return(nil)
end

--[[#####################################################################################################################################################################
###########################################################Hier "verschieben" wir unsere Konfiguration aus	 ############################################################
###########################################################dem internen libConfig-Speicher in die tatsächlich############################################################
###########################################################verwendeten Variablen							 ############################################################
#######################################################################################################################################################################]]

function FS19_H_VereinfachteSteuerung:activateConfig()
	if debug > 1 then print("-> " .. modName .. ": functionStatus " .. "activateConfig" .. tostring(activateConfig)) end
	-- funktionen
	FS19_H_VereinfachteSteuerung.functionHydraulicIsEnabled    			= xmlM:getConfigValue("global.functions", "hydraulicIsEnabled")
	FS19_H_VereinfachteSteuerung.functionHydraulicIsEnabledSeparat    	= xmlM:getConfigValue("global.functions", "hydraulicIsEnabledSeparat")
	FS19_H_VereinfachteSteuerung.functionabFaltbarEnabled    			= xmlM:getConfigValue("global.functions", "faltbarEnabled")
	FS19_H_VereinfachteSteuerung.functionabFaltbarEnabledSeparat    	= xmlM:getConfigValue("global.functions", "faltbarEnabledSeparat")
	FS19_H_VereinfachteSteuerung.functionabEinschaltenEnabled   		= xmlM:getConfigValue("global.functions", "einschaltenEnabled")
	FS19_H_VereinfachteSteuerung.functionabEinschaltenEnabledSeparat   	= xmlM:getConfigValue("global.functions", "einschaltenEnabledSeparat")
	FS19_H_VereinfachteSteuerung.functionabKoppelnEnabled    			= xmlM:getConfigValue("global.functions", "abkoppelnEnabled")
	FS19_H_VereinfachteSteuerung.functionabKameraEnabled    			= xmlM:getConfigValue("global.functions", "kameraEnabled")
	-- globals
	FS19_H_VereinfachteSteuerung.showKeysInHelpMenu  					= xmlM:getConfigValue("global.misc", "showKeysInHelpMenu")
	FS19_H_VereinfachteSteuerung.kameraZoom  							= xmlM:getConfigValue("global.misc", "kameraZoom")
	FS19_H_VereinfachteSteuerung.kameraRotX  							= xmlM:getConfigValue("global.misc", "kameraRotX")
	
				if debug > 2 then print(DebugUtil.printTableRecursively(FS19_H_VereinfachteSteuerung, 0, 0, 3)) end
				if debug > 2 then print("--> FS19_H_VereinfachteSteuerung" ..tostring(FS19_H_VereinfachteSteuerung)) end
				if debug > 2 then print(DebugUtil.printTableRecursively(functionHydraulicIsEnabled, 0, 0, 3)) end
				if debug > 2 then print("--> functionHydraulicIsEnabled" ..tostring(functionHydraulicIsEnabled)) end
end

--[[#####################################################################################################################################################################
###########################################################Konfig zurücksetzen								 ############################################################
#######################################################################################################################################################################]]

function FS19_H_VereinfachteSteuerung:resetConfig(disable)
--  -- to make life easier
  local baseX = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterX
  local baseY = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterY

	-- frisch starten
	xmlM:clearConfig()

	-- funktionen
		xmlM:addConfigValue("global.functions", 	"hydraulicIsEnabled",    			"bool", 	true)
		xmlM:addConfigValue("global.functions", 	"hydraulicIsEnabledSeparat",    	"bool", 	true)
		xmlM:addConfigValue("global.functions", 	"faltbarEnabled",    				"bool", 	true)
		xmlM:addConfigValue("global.functions", 	"faltbarEnabledSeparat",    		"bool", 	true)
		xmlM:addConfigValue("global.functions", 	"einschaltenEnabled",    			"bool", 	true)
		xmlM:addConfigValue("global.functions", 	"einschaltenEnabledSeparat",   		"bool", 	true)
		xmlM:addConfigValue("global.functions", 	"abkoppelnEnabled",    				"bool", 	true)
		xmlM:addConfigValue("global.functions", 	"kameraEnabled",    				"bool", 	true)
		xmlM:addConfigValue("global.misc", 		"showKeysInHelpMenu", 				"bool", 	true)
		xmlM:addConfigValue("global.misc", 		"kameraZoom", 						"float",	1.5)
		xmlM:addConfigValue("global.misc", 		"kameraRotX", 						"float",	1.5)
	
				if debug > 1 then print("-> " .. modName .. ": functionStatus " .. "resetConfig" .. tostring(disable)) end
end

--[[#####################################################################################################################################################################
###########################################################Exportfunktionen für andere Mods 				 ############################################################
#######################################################################################################################################################################]]

function FS19_H_VereinfachteSteuerung:onLoad(savegame)
  if debug > 1 then print("-> " .. modName .. ": onLoad" .. mySelf(self)) end

  -- Exportfunktionen für andere Mods
  self.functionEnable = FS19_H_VereinfachteSteuerung.functionEnable
  self.functionStatus = FS19_H_VereinfachteSteuerung.functionStatus
end

-- #############################################################################

function FS19_H_VereinfachteSteuerung:onPostLoad(savegame)
--  if debug > 1 then print("-> " .. modName .. ": onPostLoad" .. mySelf(self)) end

end

-- #############################################################################

function FS19_H_VereinfachteSteuerung:saveToXMLFile(xmlFile, key)
--  if debug > 1 then print("-> " .. modName .. ": saveToXMLFile" .. mySelf(self)) end

end

-- #############################################################################

function FS19_H_VereinfachteSteuerung:onUpdate(dt)

end

-- #############################################################################

function FS19_H_VereinfachteSteuerung:onDraw()
end

-- #############################################################################

function FS19_H_VereinfachteSteuerung:onReadStream(streamId, connection)
--  if debug > 1 then print("-> " .. modName .. ": onReadStream - " .. streamId .. mySelf(self)) end

end

-- #############################################################################

function FS19_H_VereinfachteSteuerung:onWriteStream(streamId, connection)
--  if debug > 1 then print("-> " .. modName .. ": onWriteStream - " .. streamId .. mySelf(self)) end

end

-- #############################################################################

function FS19_H_VereinfachteSteuerung:onEnterVehicle()
--  if debug > 1 then print("-> " .. modName .. ": onEnterVehicle" .. mySelf(self)) end

end

-- #############################################################################

function FS19_H_VereinfachteSteuerung:onReverseDirectionChanged()
--  if debug > 1 then print("-> " .. modName .. ": onReverseDirectionChanged" .. mySelf(self)) end

end

--[[#####################################################################################################################################################################
###########################################################on Register Action Events						 ############################################################
#######################################################################################################################################################################]]	
kameraNeuerWert = {}
function FS19_H_VereinfachteSteuerung:onRegisterActionEvents(isSelected, isOnActiveVehicle)
  if debug > 1 then print("-> " .. modName .. ": onRegisterActionEvents " .. tostring(isSelected) .. ", " .. tostring(isOnActiveVehicle) .. ", S: " .. tostring(self.isServer) .. ", C: " .. tostring(self.isClient) .. mySelf(self)) end

--	#######################################################nur auf der Clientseite#######################################################################################
  if not self.isClient then
    return
  end
		
		
		if mySelf(self) ~= mySelf_1	then
			mySelf_1 = mySelf(self);
			if kameraNeuerWert[mySelf_1] ~= true then
				kameraNeuerWert[mySelf_1] = true;
				if FS19_H_VereinfachteSteuerung.functionabKameraEnabled then
					FS19_H_VereinfachteSteuerung:enumerateAttachments(self);
					for idx, kamera in pairs (kamera_winkel) do
						if kamera[1].isInside == false then																	--Neu V1.3.0.6
							if FS19_H_VereinfachteSteuerung.kameraRotX > 1 then
								kamera[1].origRotX = -0.20 * FS19_H_VereinfachteSteuerung.kameraRotX;
							end;
							if FS19_H_VereinfachteSteuerung.kameraZoom > 1 then
								kamera[1].origTransZ = kamera[1].origTransZ * FS19_H_VereinfachteSteuerung.kameraZoom;
							end;
							kamera[1].rotX = kamera[1].origRotX;
							kamera[1].zoomTarget = kamera[1].origTransZ;
						end;	
					end;
				end;
			end;
		end;
			
	
  


  -- Nur im aktiven Fahrzeug und wenn wir es kontrollieren
  if isOnActiveVehicle and self:getIsControlled() then
    -- Wenn das Fahrzeug rückwärts fährt, ertönt ein Piepton
    if self.reverseSample == nil then
      if self.spec_motorized ~= nil and self.spec_motorized.samples ~= nil and self.spec_motorized.samples.reverseDrive ~= nil then
        self.reverseSample = self.spec_motorized.samples.reverseDrive
        self.spec_motorized.samples.reverseDrive = nil
      end
    end

    -- Liste der anzuhängenden Aktionen zusammenstellen
    local actionList = FS19_H_VereinfachteSteuerung.actions.global
    if FS19_H_VereinfachteSteuerung.functionHydraulicIsEnabled then
		for _, v in ipairs(FS19_H_VereinfachteSteuerung.actions.hydraulic) do
			table.insert(actionList, v)
		end
    end
	
	local actionList = FS19_H_VereinfachteSteuerung.actions.global
    if FS19_H_VereinfachteSteuerung.functionHydraulicIsEnabledSeparat then
		for _, v in ipairs(FS19_H_VereinfachteSteuerung.actions.hydraulicSeparat) do
			table.insert(actionList, v)
		end
    end
	
	local actionList = FS19_H_VereinfachteSteuerung.actions.global
    if FS19_H_VereinfachteSteuerung.functionabFaltbarEnabled then
		for _, v in ipairs(FS19_H_VereinfachteSteuerung.actions.faltbar) do
			table.insert(actionList, v)
		end
    end
	
	local actionList = FS19_H_VereinfachteSteuerung.actions.global
    if FS19_H_VereinfachteSteuerung.functionabFaltbarEnabledSeparat then
		for _, v in ipairs(FS19_H_VereinfachteSteuerung.actions.faltbarSeparat) do
			table.insert(actionList, v)
		end
    end
	
	local actionList = FS19_H_VereinfachteSteuerung.actions.global
    if FS19_H_VereinfachteSteuerung.functionabEinschaltenEnabled then
		for _, v in ipairs(FS19_H_VereinfachteSteuerung.actions.einschalten) do
			table.insert(actionList, v)
		end
    end
	
	local actionList = FS19_H_VereinfachteSteuerung.actions.global
    if FS19_H_VereinfachteSteuerung.functionabEinschaltenEnabledSeparat then
		for _, v in ipairs(FS19_H_VereinfachteSteuerung.actions.einschaltenSeparat) do
			table.insert(actionList, v)
		end
    end
	
	local actionList = FS19_H_VereinfachteSteuerung.actions.global
    if FS19_H_VereinfachteSteuerung.functionabKoppelnEnabled then
		for _, v in ipairs(FS19_H_VereinfachteSteuerung.actions.abkoppeln) do
			table.insert(actionList, v)
		end
    end
	
	local actionList = FS19_H_VereinfachteSteuerung.actions.global
    if FS19_H_VereinfachteSteuerung.functionabKameraEnabled then
		for _, v in ipairs(FS19_H_VereinfachteSteuerung.actions.kamera) do
			table.insert(actionList, v)
		end
    end

    -- attach our actions
    for _ ,actionName in pairs(actionList) do
      local _, eventName = InputBinding.registerActionEvent(g_inputBinding, actionName, self, FS19_H_VereinfachteSteuerung.onActionCall, false, true, false, true)
      -- help menu priorization
      if g_inputBinding ~= nil and g_inputBinding.events ~= nil and g_inputBinding.events[eventName] ~= nil then
        g_inputBinding.events[eventName].displayPriority = 98
        -- don't show certain/all keys in help menu
        if actionName == "FS19_H_VereinfachteSteuerung_RESET" or actionName == "FS19_H_VereinfachteSteuerung_RELOAD" or not FS19_H_VereinfachteSteuerung.showKeysInHelpMenu then
          g_inputBinding.events[eventName].displayIsVisible = false
        end
      end
    end
  end
end

--[[#####################################################################################################################################################################
###########################################################auf Action Call									 ############################################################
#######################################################################################################################################################################]]







function FS19_H_VereinfachteSteuerung:onActionCall(actionName, keyStatus, arg4, arg5, arg6)
  if debug > 1 then print("-> " .. modName .. ": onActionCall " .. actionName .. ", keyStatus: " .. keyStatus .. mySelf(self)) end

  

  
  
--[[#####################################################################################################################################################################
###########################################################	TESTZEN		ENDE				       			 ############################################################
#######################################################################################################################################################################]]

	if FS19_H_VereinfachteSteuerung.functionHydraulicIsEnabled and actionName == "FS19_H_TESTEN" then
--		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)
		actionName = "FS19_H_VereinfachteSteuerung_RELOAD"
					

	end
--[[#####################################################################################################################################################################
###########################################################	TESTZEN		ENDE				       			 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################	kamera		ENDE				       			 ############################################################
#######################################################################################################################################################################]]

	if FS19_H_VereinfachteSteuerung.functionabKameraEnabled and actionName == "FS19_H_VereinfachteSteuerung_CA_kamera" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)

			for idx, kamera in pairs (kamera_winkel) do	
				if kamera[1].isInside == false and kamera[1].zoomTarget == kamera[1].origTransZ and kamera[1].rotX == kamera[1].origRotX and kamera[1].rotZ == kamera[1].origRotZ and kamera[1].rotY == kamera[1].origRotY then
--					print("kamera[1].rotX:: " .. tostring(kamera[1].rotX) .. ", kamera[1].rotZ:: " .. tostring(kamera[1].rotZ) .. ", kamera[1].rotY:: " .. tostring(kamera[1].rotY))
--					kamera[1].rotY = 96
--					print("kamera[1].rotX:: " .. tostring(kamera[1].rotX) .. ", kamera[1].rotZ:: " .. tostring(kamera[1].rotZ) .. ", kamera[1].rotY:: " .. tostring(kamera[1].rotY))
				else
					if kamera[1].isInside == false and kamera[1].origTransZ > -0 then
						if debug > 1 then DebugUtil.printTableRecursively(kamera[1], "-" , 0, 1) end
						kamera[1].zoomTarget = kamera[1].origTransZ;	
						kamera[1].rotX = kamera[1].origRotX;			
						kamera[1].rotZ = kamera[1].origRotZ;
						kamera[1].rotY = kamera[1].origRotY;
					elseif kamera[1].isInside == true then
					if debug > 1 then DebugUtil.printTableRecursively(kamera[1], "-" , 0, 1) end
						if debug > 1 then																	--Neu v1.3.0.6
							print("-->>   " .. "zoomTarget:: " .. tostring(kamera[1].zoomTarget) .. ", kamera[1].rotX:: " .. tostring(kamera[1].rotX) .. ", kamera[1].rotY:: " .. tostring(kamera[1].rotY) .. ", kamera[1].rotZ:: " ..tostring(kamera[1].rotZ)); --neu v1.3.0.6
						end;																				--Neu v1.3.0.6
						--kamera[1].zoomTarget = kamera[1].zoom;											--Neu v1.3.0.6
						kamera[1].rotX = kamera[1].origRotX;
						kamera[1].rotY = kamera[1].origRotY;
						kamera[1].rotZ = kamera[1].origRotZ;
					elseif kamera[1].isInside == false and kamera[1].origTransZ < -0 then
						kamera[1].zoomTarget = kamera[1].zoom;
						kamera[1].rotX = kamera[1].origRotX;
						kamera[1].rotY = kamera[1].origRotY;
						kamera[1].rotZ = kamera[1].origRotZ;				
					end;
					if debug > 1 then
						print("-->   " .. "idx:: " .. tostring(idx) .. ", kamera:: " .. tostring(kamera) )
						print ("-->   kamera[idx].rotZ   " .. tostring(kamera[idx].rotZ) .. "   kamera[idx].origRotZ   " .. tostring(kamera[idx].origRotZ) )
						print ("-->   kamera[idx].rotY   " .. tostring(kamera[idx].rotY) .. "   kamera[idx].origRotY   " .. tostring(kamera[idx].origRotY) )				
						if debug > 1 then DebugUtil.printTableRecursively(kamera[idx], "-" , 0, 0) end 
					end;
				end;	
			end;
	end;
--[[#####################################################################################################################################################################
###########################################################	Kamera		ENDE				       			 ############################################################
#######################################################################################################################################################################]]  
--[[#####################################################################################################################################################################
###########################################################vorne hinten heben/senken START         			 ############################################################
#######################################################################################################################################################################]]  
  
	if FS19_H_VereinfachteSteuerung.functionHydraulicIsEnabled and actionName == "FS19_H_VereinfachteSteuerung_AJ_hinten_vorne_HochRunter" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)
				
				local funktion_1 = true
				
				local hochrunter_vorne = nil
				local bewegeb_vorne
				local object_vorne
				
				local hochrunter_hinten = nil
				local bewegen_hinten
				local object_hinten
				
					for idx_vorne, obj_vorne in pairs(joints_front) do
						if obj_vorne ~= nil then
							if object_vorne == nil then object_vorne = obj_vorne end
							if object_vorne~= nil then object_vorne_2 = obj_vorne end
						end
					end
					
					for idx_hinten, obj_hinten in pairs(joints_back) do
						if obj_hinten ~= nil then
							if object_hinten == nil then object_hinten = obj_hinten end
							if object_hinten ~= nil then object_hinten_2 = obj_hinten end
						end
					end
						
						if object_vorne ~= nil then
							if hochrunter_vorne == nil then
								hochrunter_vorne = not object_vorne[1].spec_attacherJoints.attacherJoints[object_vorne[2]].moveDown
							end
							if debug > 1 then print("--> hochrunter_vorne: "..object_vorne[1].rootNode.."/"..object_vorne[2].."/"..tostring(hochrunter_vorne) ) end
							
						end
							
						if object_hinten ~= nil then
							if hochrunter_hinten == nil then
								hochrunter_hinten = not object_hinten[1].spec_attacherJoints.attacherJoints[object_hinten[2]].moveDown
							end
							if debug > 1 then print("--> hochrunter_hinten: "..object_hinten[1].rootNode.."/"..object_hinten[2].."/"..tostring(hochrunter_hinten) ) end
					
						end

					
				

				for i = 1, 1 do
					if hochrunter_vorne == true and hochrunter_hinten == true then
						bewegeb_vorne = true
						bewegen_hinten = true
						object_vorne[1].spec_attacherJoints.setJointMoveDown(object_vorne[1], object_vorne[2], hochrunter_vorne)
						object_hinten[1].spec_attacherJoints.setJointMoveDown(object_hinten[1], object_hinten[2], hochrunter_hinten)
							if debug > 1 then print("-->   hochrunter_vorne == true and hochrunter_hinten == true    ") end
							if debug > 1 then print("-->   hochrunter_vorne    " .. tostring(hochrunter_vorne) ) end
							if debug > 1 then print("-->   hochrunter_hinten   " .. tostring(hochrunter_hinten) ) end
							funktion_1 = false
							break
					elseif hochrunter_vorne == false and hochrunter_hinten == false then
						bewegeb_vorne = true
						bewegen_hinten = true
						object_vorne[1].spec_attacherJoints.setJointMoveDown(object_vorne[1], object_vorne[2], hochrunter_vorne)
						object_hinten[1].spec_attacherJoints.setJointMoveDown(object_hinten[1], object_hinten[2], hochrunter_hinten)
							if debug > 1 then print("-->   hochrunter_vorne == false and hochrunter_hinten == false    ") end
							if debug > 1 then print("-->   hochrunter_vorne    " .. tostring(hochrunter_vorne) ) end
							if debug > 1 then print("-->   hochrunter_hinten   " .. tostring(hochrunter_hinten) ) end
							funktion_1 = false
							break
					elseif hochrunter_vorne == true and hochrunter_hinten == false then
						bewegen_hinten = true
						object_hinten[1].spec_attacherJoints.setJointMoveDown(object_hinten[1], object_hinten[2], hochrunter_hinten)
							if debug > 1 then print("-->   hochrunter_vorne == true and hochrunter_hinten == false    ") end
							if debug > 1 then print("-->   hochrunter_vorne    " .. tostring(hochrunter_vorne) ) end
							if debug > 1 then print("-->   hochrunter_hinten   " .. tostring(hochrunter_hinten) ) end
							funktion_1 = false
							break
					elseif hochrunter_vorne == false and hochrunter_hinten == true then
						bewegeb_vorne = true
						object_vorne[1].spec_attacherJoints.setJointMoveDown(object_vorne[1], object_vorne[2], hochrunter_vorne)
							if debug > 1 then print("-->   hochrunter_vorne == false and hochrunter_hinten == true    ") end
							if debug > 1 then print("-->   hochrunter_vorne    " .. tostring(hochrunter_vorne) ) end
							if debug > 1 then print("-->   hochrunter_hinten   " .. tostring(hochrunter_hinten) ) end
							funktion_1 = false
							break
					elseif hochrunter_vorne ~= nil and hochrunter_hinten == nil then
						bewegeb_vorne = true
						object_vorne[1].spec_attacherJoints.setJointMoveDown(object_vorne[1], object_vorne[2], hochrunter_vorne)
							if debug > 1 then print("-->   hochrunter_vorne ~= nil and hochrunter_hinten == nil    ") end
							if debug > 1 then print("-->   hochrunter_vorne    " .. tostring(hochrunter_vorne) ) end
							if debug > 1 then print("-->   hochrunter_hinten   " .. tostring(hochrunter_hinten) ) end
							funktion_1 = false
							break
					elseif hochrunter_vorne == nil and hochrunter_hinten ~= nil then
						bewegen_hinten = true
						object_hinten[1].spec_attacherJoints.setJointMoveDown(object_hinten[1], object_hinten[2], hochrunter_hinten)
							if debug > 1 then print("-->   hochrunter_vorne == true and hochrunter_hinten == false    ") end
							if debug > 1 then print("-->   hochrunter_vorne    " .. tostring(hochrunter_vorne) ) end
							if debug > 1 then print("-->   hochrunter_hinten   " .. tostring(hochrunter_hinten) ) end
							funktion_1 = false
							break
					end
				end
					
					
					

					if debug > 1 then print("-->   bewegeb_vorne    " .. tostring(bewegeb_vorne) ) end
					if debug > 1 then print("-->   bewegen_hinten   " .. tostring(bewegen_hinten) ) end	
					if debug > 1 then 		DebugUtil.printTableRecursively(object_front, "-" , 0, 0) end
					if debug > 1 then 		DebugUtil.printTableRecursively(self.spec_attacherJoints.attacherJoints, "-" , 0, 1) end
				
					if bewegeb_vorne == true then
						for idx_vorne, object_vorne in pairs(implements_front) do
							if object_vorne.spec_attachable ~= nil then
								object_vorne.spec_attachable.setLoweredAll(object_vorne, hochrunter_vorne)
								if debug > 1 then print("--> front up/down: "..object_vorne.rootNode.."/"..tostring(hochrunter_vorne) ) end
							end
						end
					end
					if bewegen_hinten == true then
						for idx_hinten, object_hinten in pairs(implements_back) do
							if object_hinten.spec_attachable ~= nil then
								object_hinten.spec_attachable.setLoweredAll(object_hinten, hochrunter_hinten)
								if debug > 1 then print("--> rear up/down: "..object_hinten.rootNode.."/"..tostring(hochrunter_hinten) ) end
							end
						end
					end
					



					if funktion_1 == true then
						if debug > 1 then print("-->   funktion_1 (3) vorne/hinten heben/senken   ") end
						if hochrunter_vorne == nil and hochrunter_hinten == nil then
							if debug > 1 then print("-->   hochrunter_vorne == nil and hochrunter_hinten == nil") end
							if debug > 1 then print ("-->   bewegen_vorne_Separat   " .. tostring(bewegen_vorne_Separat) .."   bewegen_hinten_Separat   " .. tostring(bewegen_hinten_Separat) ) end
							if bewegen_vorne_Separat == bewegen_hinten_Separat then
								if debug > 1 then print ("-->   bewegen_vorne_Separat == bewegen_hinten_Separat") end
									for idx_vorne, object_vorne in pairs(implements_front) do
										if object_vorne.spec_attachable ~= nil then
											if debug > 1 then print("-->   Vorne(0)   " .. tostring(bewegen_vorne_Separat) ) end
											if bewegen_vorne_Separat == nil then
												object_vorne.spec_attachable.setLoweredAll(object_vorne, true)
												bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
												if debug > 1 then print("-->   Vorne(1)   " .. tostring(bewegen_vorne_Separat) ) end
											end
											if 	bewegen_vorne_Separat == false then
												object_vorne.spec_attachable.setLoweredAll(object_vorne, true)
												bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
												if debug > 1 then print("-->   Vorne(2)   " .. tostring(bewegen_vorne_Separat) ) end
											else
												object_vorne.spec_attachable.setLoweredAll(object_vorne, false)
												bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
												if debug > 1 then print("-->   Vorne(3)   " .. tostring(bewegen_vorne_Separat) ) end
											end
										end
									end
										
									for idx_hinten, object_hinten in pairs(implements_back) do
										if object_hinten.spec_attachable ~= nil then
											if debug > 1 then print("-->   Hinten(0)   " .. tostring(bewegen_hinten_Separat) ) end
											if bewegen_hinten_Separat == nil then
												object_hinten.spec_attachable.setLoweredAll(object_hinten, true)
												bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
												if debug > 1 then print("-->   Hinten(1)   " .. tostring(bewegen_hinten_Separat) ) end
											end
											if 	bewegen_hinten_Separat == false then
												object_hinten.spec_attachable.setLoweredAll(object_hinten, true)
												bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
												if debug > 1 then print("-->   Hinten(2)   " .. tostring(bewegen_hinten_Separat) ) end
											else
												object_hinten.spec_attachable.setLoweredAll(object_hinten, false)
												bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
												if debug > 1 then print("-->   Hinten(3)   " .. tostring(bewegen_hinten_Separat) ) end
											end
										end
									end
									return
							elseif bewegen_vorne_Separat == true and bewegen_hinten_Separat == false then
								if debug > 1 then print("-->   bewegen_vorne_Separat == true and hochrunter_hinten == false") end
								for idx_vorne, object_vorne in pairs(implements_front) do
									if object_vorne.spec_attachable ~= nil then
										if debug > 1 then print("-->   Vorne(0)   " .. tostring(bewegen_vorne_Separat) ) end
										if bewegen_vorne_Separat == nil then
											object_vorne.spec_attachable.setLoweredAll(object_vorne, true)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(1)   " .. tostring(bewegen_vorne_Separat) ) end
										end
										if 	bewegen_vorne_Separat == false then
											object_vorne.spec_attachable.setLoweredAll(object_vorne, true)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(2)   " .. tostring(bewegen_vorne_Separat) ) end
										else
											object_vorne.spec_attachable.setLoweredAll(object_vorne, false)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(3)   " .. tostring(bewegen_vorne_Separat) ) end
										end
									end	
								end
								return
							elseif bewegen_vorne_Separat == false and bewegen_hinten_Separat == true then
								if debug > 1 then print("-->   bewegen_vorne_Separat == false and hochrunter_hinten == true") end
								for idx_hinten, object_hinten in pairs(implements_back) do
									if object_hinten.spec_attachable ~= nil then
										if debug > 1 then print("-->   Hinten(0)   " .. tostring(bewegen_hinten_Separat) ) end
										if bewegen_hinten_Separat == nil then
											object_hinten.spec_attachable.setLoweredAll(object_hinten, true)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(1)   " .. tostring(bewegen_hinten_Separat) ) end
										end
										if 	bewegen_hinten_Separat == false then
											object_hinten.spec_attachable.setLoweredAll(object_hinten, true)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(2)   " .. tostring(bewegen_hinten_Separat) ) end
										else
											object_hinten.spec_attachable.setLoweredAll(object_hinten, false)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(3)   " .. tostring(bewegen_hinten_Separat) ) end
										end
									end
								end
								return
							elseif bewegen_vorne_Separat ~= nil and bewegen_hinten_Separat == nil then
								if debug > 1 then print("-->   bewegen_vorne_Separat ~= false and bewegen_vorne_Separat == nil") end
								for idx_vorne, object_vorne in pairs(implements_front) do
									if object_vorne.spec_attachable ~= nil then
										if debug > 1 then print("-->   Vorne(0)   " .. tostring(bewegen_vorne_Separat) ) end
										if bewegen_vorne_Separat == nil then
											object_vorne.spec_attachable.setLoweredAll(object_vorne, true)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(1)   " .. tostring(bewegen_vorne_Separat) ) end
										end
										if 	bewegen_vorne_Separat == false then
											object_vorne.spec_attachable.setLoweredAll(object_vorne, true)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(2)   " .. tostring(bewegen_vorne_Separat) ) end
										else
											object_vorne.spec_attachable.setLoweredAll(object_vorne, false)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(3)   " .. tostring(bewegen_vorne_Separat) ) end
										end
									end
								end
								return
							elseif bewegen_vorne_Separat == nil and bewegen_hinten_Separat ~= nil then
								if debug > 1 then print("-->   bewegen_vorne_Separat == nil and hochrunter_hinten ~= nil") end
								for idx_hinten, object_hinten in pairs(implements_back) do
									if object_hinten.spec_attachable ~= nil then
										if debug > 1 then print("-->   Hinten(0)   " .. tostring(bewegen_hinten_Separat) ) end
										if bewegen_hinten_Separat == nil then
											object_hinten.spec_attachable.setLoweredAll(object_hinten, true)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(1)   " .. tostring(bewegen_hinten_Separat) ) end
										end
										if 	bewegen_hinten_Separat == false then
											object_hinten.spec_attachable.setLoweredAll(object_hinten, true)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(2)   " .. tostring(bewegen_hinten_Separat) ) end
										else
											object_hinten.spec_attachable.setLoweredAll(object_hinten, false)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(3)   " .. tostring(bewegen_hinten_Separat) ) end
										end
									end
								end
							end
							return
						else
							if hochrunter_vorne == nil then
								if debug > 1 then print("-->   if hochrunter_vorne == nil") end
								for idx_vorne, object_vorne in pairs(implements_front) do
									if object_vorne.spec_attachable ~= nil then
										if debug > 1 then print("-->   Vorne(0)   " .. tostring(bewegen_vorne_Separat) ) end
										if bewegen_vorne_Separat == nil then
											object_vorne.spec_attachable.setLoweredAll(object_vorne, true)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(1)   " .. tostring(bewegen_vorne_Separat) ) end
										end
										if 	bewegen_vorne_Separat == false then
											object_vorne.spec_attachable.setLoweredAll(object_vorne, true)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(2)   " .. tostring(bewegen_vorne_Separat) ) end
										else
											object_vorne.spec_attachable.setLoweredAll(object_vorne, false)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(3)   " .. tostring(bewegen_vorne_Separat) ) end
										end
									end
								end
							end
							if hochrunter_hinten == nil then
								if debug > 1 then print("-->   hochrunter_hinten == nil") end
								for idx_hinten, object_hinten in pairs(implements_back) do
									if object_hinten.spec_attachable ~= nil then
										if debug > 1 then print("-->   Hinten(0)   " .. tostring(bewegen_hinten_Separat) ) end
										if bewegen_hinten_Separat == nil then
											object_hinten.spec_attachable.setLoweredAll(object_hinten, true)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(1)   " .. tostring(bewegen_hinten_Separat) ) end
										end
										if 	bewegen_hinten_Separat == false then
											object_hinten.spec_attachable.setLoweredAll(object_hinten, true)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(2)   " .. tostring(bewegen_hinten_Separat) ) end
										else
											object_hinten.spec_attachable.setLoweredAll(object_hinten, false)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(3)   " .. tostring(bewegen_hinten_Separat) ) end
										end
									end
								end
							end
						end
					end
--#######################################################################################################################################################################	
				local funktion_2 = true
				
				local hochrunter_vorne_2 = nil
				local bewegeb_vorne_2
				local object_vorne_2
				
				local hochrunter_hinten_2 = nil
				local bewegen_hinten_2
				local object_hinten_2
						
						
						
--						
--						if object_vorne_2 ~= nil then
--							if hochrunter_vorne_2 == nil then
--								hochrunter_vorne_2 = not object_vorne_2[1].spec_attacherJoints.attacherJoints[object_vorne_2[2]].moveDown
--							end
--							if debug > 1 then print("--> hochrunter_vorne_2: "..object_vorne_2[1].rootNode.."/"..object_vorne_2[2].."/"..tostring(hochrunter_vorne_2) ) end
--						end
--							
--						if object_hinten_2 ~= nil then
--							if hochrunter_hinten_2 == nil then
--								hochrunter_hinten_2 = not object_hinten_2[1].spec_attacherJoints.attacherJoints[object_hinten_2[2]].moveDown
--							end
--							if debug > 1 then print("--> hochrunter_hinten_2: "..object_hinten_2[1].rootNode.."/"..object_hinten_2[2].."/"..tostring(hochrunter_hinten_2) ) end
--						end
--
--					
--				
--
--				for i = 1, 1 do
--					if hochrunter_vorne_2 == true and hochrunter_hinten_2 == true then
--						bewegeb_vorne_2 = true
--						bewegen_hinten_2 = true
--						object_vorne_2[1].spec_attacherJoints.setJointMoveDown(object_vorne_2[1], object_vorne_2[2], hochrunter_vorne_2)
--						object_hinten_2[1].spec_attacherJoints.setJointMoveDown(object_hinten_2[1], object_hinten_2[2], hochrunter_hinten_2)
--							if debug > 1 then print("-->   hochrunter_vorne_2 == true and hochrunter_hinten_2 == true    ") end
--							if debug > 1 then print("-->   hochrunter_vorne_2    " .. tostring(hochrunter_vorne_2) ) end
--							if debug > 1 then print("-->   hochrunter_hinten_2   " .. tostring(hochrunter_hinten_2) ) end
--							funktion_2 = false
--							break
--					elseif hochrunter_vorne_2 == false and hochrunter_hinten_2 == false then
--						bewegeb_vorne_2 = true
--						bewegen_hinten_2 = true
--						object_vorne_2[1].spec_attacherJoints.setJointMoveDown(object_vorne_2[1], object_vorne_2[2], hochrunter_vorne_2)
--						object_hinten_2[1].spec_attacherJoints.setJointMoveDown(object_hinten_2[1], object_hinten_2[2], hochrunter_hinten_2)
--							if debug > 1 then print("-->   hochrunter_vorne_2 == false and hochrunter_hinten_2 == false    ") end
--							if debug > 1 then print("-->   hochrunter_vorne_2    " .. tostring(hochrunter_vorne_2) ) end
--							if debug > 1 then print("-->   hochrunter_hinten_2   " .. tostring(hochrunter_hinten_2) ) end
--							funktion_2 = false
--							break
--					elseif hochrunter_vorne_2 == true and hochrunter_hinten_2 == false then
--						bewegen_hinten_2 = true
--						object_hinten_2[1].spec_attacherJoints.setJointMoveDown(object_hinten_2[1], object_hinten_2[2], hochrunter_hinten_2)
--							if debug > 1 then print("-->   hochrunter_vorne_2 == true and hochrunter_hinten_2 == false    ") end
--							if debug > 1 then print("-->   hochrunter_vorne_2    " .. tostring(hochrunter_vorne_2) ) end
--							if debug > 1 then print("-->   hochrunter_hinten_2   " .. tostring(hochrunter_hinten_2) ) end
--							funktion_2 = false
--							break
--					elseif hochrunter_vorne_2 == false and hochrunter_hinten_2 == true then
--						bewegeb_vorne_2 = true
--						object_vorne_2[1].spec_attacherJoints.setJointMoveDown(object_vorne_2[1], object_vorne_2[2], hochrunter_vorne_2)
--							if debug > 1 then print("-->   hochrunter_vorne_2 == false and hochrunter_hinten_2 == true    ") end
--							if debug > 1 then print("-->   hochrunter_vorne_2    " .. tostring(hochrunter_vorne_2) ) end
--							if debug > 1 then print("-->   hochrunter_hinten_2   " .. tostring(hochrunter_hinten_2) ) end
--							funktion_2 = false
--							break
--					elseif hochrunter_vorne_2 ~= nil and hochrunter_hinten_2 == nil then
--						bewegeb_vorne_2 = true
--						object_vorne_2[1].spec_attacherJoints.setJointMoveDown(object_vorne_2[1], object_vorne_2[2], hochrunter_vorne_2)
--							if debug > 1 then print("-->   hochrunter_vorne_2 ~= nil and hochrunter_hinten_2 == nil    ") end
--							if debug > 1 then print("-->   hochrunter_vorne_2    " .. tostring(hochrunter_vorne_2) ) end
--							if debug > 1 then print("-->   hochrunter_hinten_2   " .. tostring(hochrunter_hinten_2) ) end
--							funktion_2 = false
--							break
--					elseif hochrunter_vorne_2 == nil and hochrunter_hinten_2 ~= nil then
--						bewegen_hinten_2 = true
--						object_hinten_2[1].spec_attacherJoints.setJointMoveDown(object_hinten_2[1], object_hinten_2[2], hochrunter_hinten_2)
--							if debug > 1 then print("-->   hochrunter_vorne_2 == true and hochrunter_hinten_2 == false    ") end
--							if debug > 1 then print("-->   hochrunter_vorne_2    " .. tostring(hochrunter_vorne_2) ) end
--							if debug > 1 then print("-->   hochrunter_hinten_2   " .. tostring(hochrunter_hinten_2) ) end
--							funktion_2 = false
--							break
--					end
--				end
--					
--					
--					
--
--					if debug > 1 then print("-->   bewegeb_vorne_2    " .. tostring(bewegeb_vorne_2) ) end
--					if debug > 1 then print("-->   bewegen_hinten_2   " .. tostring(bewegen_hinten_2) ) end
--					if debug > 1 then 		DebugUtil.printTableRecursively(object_front, "-" , 0, 0) end
--					if debug > 1 then 		DebugUtil.printTableRecursively(self.spec_attacherJoints.attacherJoints, "-" , 0, 1) end
--				
--					if bewegeb_vorne_2 == true then
--						for idx_vorne, object_vorne_2 in pairs(implements_front) do
--							if object_vorne_2.spec_attachable ~= nil then
--								object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, hochrunter_vorne_2)
--								if debug > 1 then print("--> front up/down: "..object_vorne_2.rootNode.."/"..tostring(hochrunter_vorne_2) ) end
--							end
--						end
--					end
--					if bewegen_hinten_2 == true then
--						for idx_hinten, object_hinten_2 in pairs(implements_back) do
--							if object_hinten_2.spec_attachable ~= nil then
--								object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, hochrunter_hinten_2)
--								if debug > 1 then print("--> rear up/down: "..object_hinten_2.rootNode.."/"..tostring(hochrunter_hinten_2) ) end
--							end
--						end
--					end
--					
--
--
--
--					if funktion_2 == true then
--						if debug > 1 then print("-->   funktion_2 (3) vorne/hinten heben/senken   ") end
--						if hochrunter_vorne_2 == nil and hochrunter_hinten_2 == nil then
--							if debug > 1 then print("-->   hochrunter_vorne_2 == nil and hochrunter_hinten_2 == nil") end
--							if debug > 1 then print ("-->   bewegen_vorne_Separat   " .. tostring(bewegen_vorne_Separat) .."   bewegen_hinten_2_Separat   " .. tostring(bewegen_hinten_2_Separat) ) end
--							if bewegen_vorne_Separat == bewegen_hinten_2_Separat then
--								if debug > 1 then print ("-->   bewegen_vorne_Separat == bewegen_hinten_2_Separat") end
--									for idx_vorne, object_vorne_2 in pairs(implements_front) do
--										if object_vorne_2.spec_attachable ~= nil then
--											if debug > 1 then print("-->   Vorne(0)   " .. tostring(bewegen_vorne_Separat) ) end
--											if bewegen_vorne_Separat == nil then
--												object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, true)
--												bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--												if debug > 1 then print("-->   Vorne(1)   " .. tostring(bewegen_vorne_Separat) ) end
--											end
--											if 	bewegen_vorne_Separat == false then
--												object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, true)
--												bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--												if debug > 1 then print("-->   Vorne(2)   " .. tostring(bewegen_vorne_Separat) ) end
--											else
--												object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, false)
--												bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--												if debug > 1 then print("-->   Vorne(3)   " .. tostring(bewegen_vorne_Separat) ) end
--											end
--										end
--									end
--										
--									for idx_hinten, object_hinten_2 in pairs(implements_back) do
--										if object_hinten_2.spec_attachable ~= nil then
--											if debug > 1 then print("-->   Hinten(0)   " .. tostring(bewegen_hinten_2_Separat) ) end
--											if bewegen_hinten_2_Separat == nil then
--												object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, true)
--												bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--												if debug > 1 then print("-->   Hinten(1)   " .. tostring(bewegen_hinten_2_Separat) ) end
--											end
--											if 	bewegen_hinten_2_Separat == false then
--												object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, true)
--												bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--												if debug > 1 then print("-->   Hinten(2)   " .. tostring(bewegen_hinten_2_Separat) ) end
--											else
--												object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, false)
--												bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--												if debug > 1 then print("-->   Hinten(3)   " .. tostring(bewegen_hinten_2_Separat) ) end
--											end
--										end
--									end
--									return
--							elseif bewegen_vorne_Separat == true and bewegen_hinten_2_Separat == false then
--								if debug > 1 then print("-->   bewegen_vorne_Separat == true and hochrunter_hinten_2 == false") end
--								for idx_vorne, object_vorne_2 in pairs(implements_front) do
--									if object_vorne_2.spec_attachable ~= nil then
--										if debug > 1 then print("-->   Vorne(0)   " .. tostring(bewegen_vorne_Separat) ) end
--										if bewegen_vorne_Separat == nil then
--											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, true)
--											bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--											if debug > 1 then print("-->   Vorne(1)   " .. tostring(bewegen_vorne_Separat) ) end
--										end
--										if 	bewegen_vorne_Separat == false then
--											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, true)
--											bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--											if debug > 1 then print("-->   Vorne(2)   " .. tostring(bewegen_vorne_Separat) ) end
--										else
--											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, false)
--											bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--											if debug > 1 then print("-->   Vorne(3)   " .. tostring(bewegen_vorne_Separat) ) end
--										end
--									end
--								end
--								return
--							elseif bewegen_vorne_Separat == false and bewegen_hinten_2_Separat == true then
--								if debug > 1 then print("-->   bewegen_vorne_Separat == false and hochrunter_hinten_2 == true") end
--								for idx_hinten, object_hinten_2 in pairs(implements_back) do
--									if object_hinten_2.spec_attachable ~= nil then
--										if debug > 1 then print("-->   Hinten(0)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										if bewegen_hinten_2_Separat == nil then
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, true)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten(1)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										end
--										if 	bewegen_hinten_2_Separat == false then
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, true)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten(2)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										else
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, false)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten(3)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										end
--									end
--								end
--								return
--							elseif bewegen_vorne_Separat ~= nil and bewegen_hinten_2_Separat == nil then
--								if debug > 1 then print("-->   bewegen_vorne_Separat ~= false and bewegen_vorne_Separat == nil") end
--								for idx_vorne, object_vorne_2 in pairs(implements_front) do
--									if object_vorne_2.spec_attachable ~= nil then
--										if debug > 1 then print("-->   Vorne(0)   " .. tostring(bewegen_vorne_Separat) ) end
--										if bewegen_vorne_Separat == nil then
--											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, true)
--											bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--											if debug > 1 then print("-->   Vorne(1)   " .. tostring(bewegen_vorne_Separat) ) end
--										end
--										if 	bewegen_vorne_Separat == false then
--											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, true)
--											bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--											if debug > 1 then print("-->   Vorne(2)   " .. tostring(bewegen_vorne_Separat) ) end
--										else
--											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, false)
--											bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--											if debug > 1 then print("-->   Vorne(3)   " .. tostring(bewegen_vorne_Separat) ) end
--										end
--									end
--								end
--								return
--							elseif bewegen_vorne_Separat == nil and bewegen_hinten_2_Separat ~= nil then
--								if debug > 1 then print("-->   bewegen_vorne_Separat == nil and hochrunter_hinten_2 ~= nil") end
--								for idx_hinten, object_hinten_2 in pairs(implements_back) do
--									if object_hinten_2.spec_attachable ~= nil then
--										if debug > 1 then print("-->   Hinten(0)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										if bewegen_hinten_2_Separat == nil then
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, true)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten(1)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										end
--										if 	bewegen_hinten_2_Separat == false then
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, true)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten(2)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										else
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, false)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten(3)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										end
--									end
--								end
--							end
--							return
--						else
--							if hochrunter_vorne_2 == nil then
--								if debug > 1 then print("-->   if hochrunter_vorne_2 == nil") end
--								for idx_vorne, object_vorne_2 in pairs(implements_front) do
--									if object_vorne_2.spec_attachable ~= nil then
--										if debug > 1 then print("-->   Vorne(0)   " .. tostring(bewegen_vorne_Separat) ) end
--										if bewegen_vorne_Separat == nil then
--											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, true)
--											bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--											if debug > 1 then print("-->   Vorne(1)   " .. tostring(bewegen_vorne_Separat) ) end
--										end
--										if 	bewegen_vorne_Separat == false then
--											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, true)
--											bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--											if debug > 1 then print("-->   Vorne(2)   " .. tostring(bewegen_vorne_Separat) ) end
--										else
--											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, false)
--											bewegen_vorne_Separat = object_vorne_2.getIsLowered(object_vorne_2)
--											if debug > 1 then print("-->   Vorne(3)   " .. tostring(bewegen_vorne_Separat) ) end
--										end
--									end
--								end
--							end
--							if hochrunter_hinten_2 == nil then
--								if debug > 1 then print("-->   hochrunter_hinten_2 == nil") end
--								for idx_hinten, object_hinten_2 in pairs(implements_back) do
--									if object_hinten_2.spec_attachable ~= nil then
--										if debug > 1 then print("-->   Hinten(0)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										if bewegen_hinten_2_Separat == nil then
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, true)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten(1)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										end
--										if 	bewegen_hinten_2_Separat == false then
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, true)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten(2)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										else
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, false)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten(3)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										end
--									end
--								end
--							end
--						end
--					end
  end	
		
--[[#####################################################################################################################################################################
###########################################################Vorne Hinten heben/senken ENDE    			   	 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################vorne heben/senken START       					 ############################################################
#######################################################################################################################################################################]]

	if FS19_H_VereinfachteSteuerung.functionHydraulicIsEnabledSeparat and actionName == "FS19_H_VereinfachteSteuerung_AJ_vorne_HochRunter" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)
		
				local funktion_1 = true
		
				local hochrunter_vorne = nil
				local bewegeb_vorne 
				local object_vorne


					for idx_vorne, obj_vorne in pairs(joints_front) do
				
						if obj_vorne ~= nil then
							if object_vorne == nil then object_vorne = obj_vorne end
							if object_vorne ~= nil then object_vorne_2 = obj_vorne end							
							if debug > 1 then print("-->   vorne heben/senken START  (obj_vorne)   " .. tostring(obj_vorne) ) end
						end
					end
					
						if object_vorne ~= nil then
							if hochrunter_vorne == nil then
								hochrunter_vorne = not object_vorne[1].spec_attacherJoints.attacherJoints[object_vorne[2]].moveDown
							end
						end
			
						if object_vorne ~= nil then
							bewegeb_vorne = true
							if debug > 1 then print("-->   funktion_1 (1) vorne heben/senken   ") end
							object_vorne[1].spec_attacherJoints.setJointMoveDown(object_vorne[1], object_vorne[2], hochrunter_vorne)
							if debug > 1 then print("-->>   funktion_1:: " .. ", object_vorne[1]:: " .. tostring(object_vorne[1]) .. ", object_vorne[2]:: " .. tostring(object_vorne[2]) .. ", hochrunter_vorne:: " .. tostring(hochrunter_vorne))end;
							funktion_1 = false
							if debug > 1 then print("-->>   " .. "1:: " .. ", hochrunter_vorne:: " .. tostring(hochrunter_vorne)) end								
						end	
						
					
						if bewegeb_vorne == true then
							for idx_vorne, object_vorne in pairs(implements_front) do
								if debug > 1 then print("-->   funktion_1 (1) vorne heben/senken   ") end
								if object_vorne.spec_attachable ~= nil then
									object_vorne.spec_attachable.setLoweredAll(object_vorne, hochrunter_vorne) 
									if debug > 1 then print("-->>   " .. "2:: " .. ", hochrunter_vorne:: " .. tostring(hochrunter_vorne) .. ", object_vorne:: " ..tostring(object_vorne)) end									
								end
							end
						end
						


						if funktion_1 == true then
							if debug > 1 then print("-->   funktion_1 (2) vorne heben/senken   ") end
							if hochrunter_vorne == nil then							
								for idx_vorne, object_vorne in pairs(implements_front) do
									if object_vorne.spec_attachable ~= nil then
										if debug > 1 then print("-->   Vorne(0)   " .. tostring(bewegen_vorne_Separat) ) end
										if bewegen_vorne_Separat == nil then
											object_vorne.spec_attachable.setLoweredAll(object_vorne, true)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(1)   " .. tostring(bewegen_vorne_Separat) ) end
										end																			
										if 	bewegen_vorne_Separat == false then
											object_vorne.spec_attachable.setLoweredAll(object_vorne, true)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(2)   " .. tostring(bewegen_vorne_Separat) ) end
										else	
											object_vorne.spec_attachable.setLoweredAll(object_vorne, false)
											bewegen_vorne_Separat = object_vorne.getIsLowered(object_vorne)
											if debug > 1 then print("-->   Vorne(3)   " .. tostring(bewegen_vorne_Separat) ) end
										end
									end	
								end
							end						
						end
--#######################################################################################################################################################################						
				local funktion_2 = true
				
				local hochrunter_vorne_2 = nil
				local bewegeb_vorne_2 
				local object_vorne_2 	

						if object_vorne_2 ~= nil then
							if bewegeb_vorne_2 == nil then
								bewegeb_vorne_2 = not object_vorne_2[1].spec_attacherJoints.attacherJoints[object_vorne_2[2]].moveDown
							end
						end				
						
--						if debug > 1 then print("--> hochrunter_vorne_2: "..object_vorne_2[1].rootNode.."/"..object_vorne_2[2].."/"..tostring(hochrunter_vorne_2) ) end	
--						if object_vorne_2 ~= nil then
--							bewegeb_vorne_2 = true
--							if debug > 1 then print("-->   funktion_2 (1) vorne heben/senken   ") end
--							object_vorne_2[1].spec_attacherJoints.setJointMoveDown(object_vorne_2[1], object_vorne_2[2], hochrunter_vorne_2)
--							if debug > 1 then print("-->>   funktion_2:: " .. ", object_vorne[1]:: " .. tostring(object_vorne[1]) .. ", object_vorne[2]:: " .. tostring(object_vorne[2]) .. ", hochrunter_vorne:: " .. tostring(hochrunter_vorne))end;
--							funktion_1 = false								
--						end	
--[[					
						if bewegeb_vorne_2 == true then
							for idx_vorne, object_vorne_2 in pairs(implements_front) do
								if debug > 1 then print("-->   funktion_2 (1) vorne heben/senken   ") end
								if object_vorne_2.spec_attachable ~= nil then
									object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, hochrunter_vorne_2) 
									if debug > 1 then print("--> front up/down: "..object_vorne_2.rootNode.."/"..tostring(hochrunter_vorne_2) ) end
								end
							end
						end		
						]]		
--[[						
						if funktion_2 == true then
							if debug > 1 then print("-->   funktion_2 (2) vorne heben/senken   ") end
							if hochrunter_vorne_2 == nil then							
								for idx_vorne_2, object_vorne_2 in pairs(implements_front) do
									if object_vorne_2.spec_attachable ~= nil then
										if debug > 1 then print("-->   Vorne(0)   " .. tostring(bewegen_vorne_Separat_2) ) end
										if bewegen_vorne_Separat_2 == nil then
											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, true)
											bewegen_vorne_Separat_2 = object_vorne_2.getIsLowered(object_vorne_2)
											if debug > 1 then print("-->   Vorne_2 (1)   " .. tostring(bewegen_vorne_Separat_2) ) end
										end																			
										if 	bewegen_vorne_Separat_2 == false then
											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, true)
											bewegen_vorne_Separat_2 = object_vorne_2.getIsLowered(object_vorne_2)
											if debug > 1 then print("-->   Vorne_2(2)   " .. tostring(bewegen_vorne_Separat_2) ) end
										else	
											object_vorne_2.spec_attachable.setLoweredAll(object_vorne_2, false)
											bewegen_vorne_Separat_2 = object_vorne_2.getIsLowered(object_vorne_2)
											if debug > 1 then print("-->   Vorne_2(3)   " .. tostring(bewegen_vorne_Separat_2) ) end
										end
									end	
								end
							end						
						end
]]						
						
	end
--[[#####################################################################################################################################################################
###########################################################vorne heben/senken ENDE       					 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################hinten heben/senken START       				 ############################################################
#######################################################################################################################################################################]]

	if FS19_H_VereinfachteSteuerung.functionHydraulicIsEnabledSeparat and actionName == "FS19_H_VereinfachteSteuerung_AJ_hinten_HochRunter" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)
		
				local funktion_1 = true
		
				local hochrunter_hinten = nil
				local bewegen_hinten
				local object_hinten	
				
					for idx_hinten, obj_hinten in pairs(joints_back) do
						if debug > 1 then print("--> obj_hinten   " .. tostring(obj_hinten) ) end	
						if obj_hinten ~= nil then
							if object_hinten == nil then object_hinten = obj_hinten end
							if object_hinten ~= nil then object_hinten_2 = object_hinten end
						end					
					end		
						
						if object_hinten ~= nil then
							if hochrunter_hinten == nil then
								hochrunter_hinten = not object_hinten[1].spec_attacherJoints.attacherJoints[object_hinten[2]].moveDown
							end
						end
						
						if debug > 1 then print("--> hochrunter_vorne: "..object_hinten[1].rootNode.."/"..object_hinten[2].."/"..tostring(hochrunter_hinten) ) end
						if hochrunter_hinten ~= nil then
							bewegen_hinten = true
							if debug > 1 then print("-->   funktion_1 (1) hinten heben/senken   ") end						
							object_hinten[1].spec_attacherJoints.setJointMoveDown(object_hinten[1], object_hinten[2], hochrunter_hinten)
							funktion_1 = false						
						end
						
						if bewegen_hinten == true then
							for idx_hinten, object_hinten in pairs(implements_back) do
								if debug > 1 then print("-->   funktion_1 (1 - 1) hinten heben/senken   ") end						
								if object_hinten.spec_attachable ~= nil then
									object_hinten.spec_attachable.setLoweredAll(object_hinten, hochrunter_hinten)
									if debug > 1 then print("--> rear up/down: "..object_hinten.rootNode.."/"..tostring(hochrunter_hinten) ) end
								end
							end
						end	
						
						
						if funktion_1 == true then
							if debug > 1 then print("-->   funktion_1 (3) hinten heben/senken   ") end
							if hochrunter_hinten == nil then
								for idx_hinten, object_hinten in pairs(implements_back) do
									if object_hinten.spec_attachable ~= nil then
										if debug > 1 then print("-->   Hinten(0)   " .. tostring(bewegen_hinten_Separat) ) end
										if bewegen_hinten_Separat == nil then
											object_hinten.spec_attachable.setLoweredAll(object_hinten, true)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(1)   " .. tostring(bewegen_hinten_Separat) ) end
										end									
										if 	bewegen_hinten_Separat == false then
											object_hinten.spec_attachable.setLoweredAll(object_hinten, true)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(2)   " .. tostring(bewegen_hinten_Separat) ) end
										else	
											object_hinten.spec_attachable.setLoweredAll(object_hinten, false)
											bewegen_hinten_Separat = object_hinten.getIsLowered(object_hinten)
											if debug > 1 then print("-->   Hinten(3)   " .. tostring(bewegen_hinten_Separat) ) end
										end
									end	
								end
							end
						end	
--#######################################################################################################################################################################						
				local funktion_2 = true
		
				local hochrunter_hinten_2 = nil
				local bewegen_hinten_2
				local object_hinten_2		
						
--						if object_hinten_2 ~= nil then
--							if hochrunter_hinten_2 == nil then
--								hochrunter_hinten_2 = not object_hinten_2[1].spec_attacherJoints.attacherJoints[object_hinten_2[2]].moveDown
--							end
--						end
--						
--						if debug > 1 then print("--> hochrunter_vorne_2: "..object_hinten_2[1].rootNode.."/"..object_hinten_2[2].."/"..tostring(hochrunter_hinten_2) ) end
--						if hochrunter_hinten_2 ~= nil then
--							bewegen_hinten_2 = true
--							if debug > 1 then print("-->   funktion_2 (1) hinten heben/senken   ") end						
--							object_hinten_2[1].spec_attacherJoints.setJointMoveDown(object_hinten_2[1], object_hinten_2[2], hochrunter_hinten_2)
--							funktion_2 = false						
--						end
--						
--						if bewegen_hinten_2 == true then
--							for idx_hinten, object_hinten_2 in pairs(implements_back) do
--								if debug > 1 then print("-->   funktion_2 (1 - 1) hinten heben/senken   ") end						
--								if object_hinten_2.spec_attachable ~= nil then
--									object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, hochrunter_hinten_2)
--									if debug > 1 then print("--> hinten hoch/runter_2: "..object_hinten_2.rootNode.."/"..tostring(hochrunter_hinten_2) ) end
--								end
--							end
--						end	
--						
--						
--						if funktion_2 == true then
--							if debug > 1 then print("-->   funktion_2 (3) hinten heben/senken   ") end
--							if hochrunter_hinten_2 == nil then
--								for idx_hinten, object_hinten_2 in pairs(implements_back) do
--									if object_hinten_2.spec_attachable ~= nil then
--										if debug > 1 then print("-->   Hinten_2 (0)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										if bewegen_hinten_2_Separat == nil then
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, true)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten_2(1)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										end									
--										if 	bewegen_hinten_2_Separat == false then
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, true)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten_2(2)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										else	
--											object_hinten_2.spec_attachable.setLoweredAll(object_hinten_2, false)
--											bewegen_hinten_2_Separat = object_hinten_2.getIsLowered(object_hinten_2)
--											if debug > 1 then print("-->   Hinten_2(3)   " .. tostring(bewegen_hinten_2_Separat) ) end
--										end
--									end	
--								end
--							end
--						end	

				
		
						
	end	

--[[#####################################################################################################################################################################
###########################################################hinten heben/senken ENDE     					 ############################################################
#######################################################################################################################################################################]]	
--[[#####################################################################################################################################################################
###########################################################vorne hinten  an/aus START       				 ############################################################
#######################################################################################################################################################################]]

	if FS19_H_VereinfachteSteuerung.functionabEinschaltenEnabled and actionName == "FS19_H_VereinfachteSteuerung_AJ_hinten_vorne_AnAus" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)
	
				local object_front
				local idx_vorne
				local _onoff_front = nil
				
				local object_front_2
				local idx_vorne_2
				local _onoff_front_2 = nil
				
					for i_vorne, obj_front in pairs(implements_front) do
						if object_front == nil then object_front = obj_front end
						if idx_vorne == nil then idx_vorne = i_vorne end
						if object_front ~= nil then object_front_2 = obj_front end
						if idx_vorne ~= nil then idx_vorne_2 = i_vorne end
					end
					if debug > 1 then 		print("-->   object_front--   " 	.. tostring(object_front) ) end
					if debug > 1 then 		print("-->   idx_vorne--      " 	.. tostring(idx_vorne) ) end
					if debug > 1 then 		print("-->   object_front_2--   " 	.. tostring(object_front_2) ) end
					if debug > 1 then 		print("-->   idx_vorne_2--      " 	.. tostring(idx_vorne_2) ) end					
					if debug > 1 then 		DebugUtil.printTableRecursively(object_front, "-" , 0, 0) end
				
				
				local object_hinten
				local idx_hinten
				local _onoff_hinten = nil
				
				local object_hinten_2
				local idx_hinten_2
				local _onoff_hinten_2 = nil
				
					for i_hinten, obj_hinten in pairs(implements_back) do
						if object_hinten == nil then object_hinten = obj_hinten end
						if idx_hinten == nil then idx_hinten = i_hinten end
						if object_hinten ~= nil then object_hinten_2 = obj_hinten end
						if idx_hinten ~= nil then idx_hinten_2 = i_hinten end						
					end
					if debug > 1 then 		print("-->   object_hinten--   " 	.. tostring(object_hinten) ) end
					if debug > 1 then 		print("-->   idx_hinten--      " 	.. tostring(idx_hinten) ) end
					if debug > 1 then 		print("-->   object_hinten_2--   " 	.. tostring(object_hinten_2) ) end
					if debug > 1 then 		print("-->   idx_hinten_2--      " 	.. tostring(idx_hinten_2) ) end
					if debug > 1 then 		DebugUtil.printTableRecursively(object_hinten, "-" , 0, 0) end
				
				
					-- Kann es aus- und wieder eingeschaltet werden?
			
					if object_front ~= nil then
						if object_front.spec_turnOnVehicle ~= nil then
							if _onoff_front == nil then
								_onoff_front = not object_front.spec_turnOnVehicle.isTurnedOn
							end
							if _onoff_front and object_front.spec_turnOnVehicle.requiresMotorTurnOn and self.spec_motorized and not self.spec_motorized:getIsOperating() then
								_onoff_front = false
								if debug > 1 then 		print("-->   _onoff_front--   " .. tostring(_onoff_front) ) end
							end	
						end
						if object_front_2 ~= nil then
							if object_front_2.spec_turnOnVehicle ~= nil then
								if _onoff_front_2 == nil then
									_onoff_front_2 = not object_front_2.spec_turnOnVehicle.isTurnedOn
								end
								if _onoff_front_2 and object_front_2.spec_turnOnVehicle.requiresMotorTurnOn and self.spec_motorized and not self.spec_motorized:getIsOperating() then
									_onoff_front_2 = false
									if debug > 1 then 		print("-->   _onoff_front_2--   " .. tostring(_onoff_front_2) ) end
								end	
							end		
						end
					end
					
					
					if object_hinten ~= nil then
						if object_hinten.spec_turnOnVehicle ~= nil then
							if _onoff_hinten == nil then
								_onoff_hinten = not object_hinten.spec_turnOnVehicle.isTurnedOn
							end
							if _onoff_hinten and object_hinten.spec_turnOnVehicle.requiresMotorTurnOn and self.spec_motorized and not self.spec_motorized:getIsOperating() then
								_onoff_hinten = false
								if debug > 1 then 		print("-->   _onoff_hinten--   " .. tostring(_onoff_hinten) ) end
							end	
						end
						if object_hinten_2 ~= nil then
							if object_hinten_2.spec_turnOnVehicle ~= nil then
								if _onoff_hinten_2 == nil then
									_onoff_hinten_2 = not object_hinten_2.spec_turnOnVehicle.isTurnedOn
								end
								if _onoff_hinten_2 and object_hinten_2.spec_turnOnVehicle.requiresMotorTurnOn and self.spec_motorized and not self.spec_motorized:getIsOperating() then
									_onoff_hinten_2 = false
									if debug > 1 then 		print("-->   _onoff_hinten_2--   " .. tostring(_onoff_hinten_2) ) end
								end	
							end
						end
					end
			
			
					-- neuer Ein-Aus-Status
			
					if object_front ~= nil and object_hinten ~= nil then
						-- Neuen Ein-Aus-Status setzen
						if _onoff_front == true and _onoff_hinten == true then
							object_hinten.spec_turnOnVehicle.setIsTurnedOn(object_hinten, _onoff_hinten)
							object_front.spec_turnOnVehicle.setIsTurnedOn(object_front, _onoff_front)
							if object_front_2 ~= nil then
								if _onoff_front_2 == true then
									object_front_2.spec_turnOnVehicle.setIsTurnedOn(object_front_2, _onoff_front_2)
								end
							end
							if object_hinten_2 ~= nil then
								if _onoff_hinten_2 == true then
									object_hinten_2.spec_turnOnVehicle.setIsTurnedOn(object_hinten_2, _onoff_hinten_2)
								end
							end	
							return						
						elseif _onoff_front == false and _onoff_hinten == false then
							object_hinten.spec_turnOnVehicle.setIsTurnedOn(object_hinten, _onoff_hinten)
							object_front.spec_turnOnVehicle.setIsTurnedOn(object_front, _onoff_front)
							if object_front_2 ~= nil then
								if _onoff_front_2 == false then
									object_front_2.spec_turnOnVehicle.setIsTurnedOn(object_front_2, _onoff_front_2)
								end
							end
							if object_hinten_2 ~= nil then
								if _onoff_hinten_2 == false then
									object_hinten_2.spec_turnOnVehicle.setIsTurnedOn(object_hinten_2, _onoff_hinten_2)
								end
							end	
							return	
						elseif 	_onoff_front == true and _onoff_hinten == false then
							object_hinten.spec_turnOnVehicle.setIsTurnedOn(object_hinten, _onoff_hinten)
							if object_front_2 ~= nil then
								if _onoff_front_2 == false then
									object_front_2.spec_turnOnVehicle.setIsTurnedOn(object_front_2, _onoff_front_2)
								end
							end
							if object_hinten_2 ~= nil then
								if _onoff_hinten_2 == false then
									object_hinten_2.spec_turnOnVehicle.setIsTurnedOn(object_hinten_2, _onoff_hinten_2)
								end
							end								
							return
						elseif _onoff_front == false and _onoff_hinten == true then
							object_front.spec_turnOnVehicle.setIsTurnedOn(object_front, _onoff_front)
							if object_front_2 ~= nil then
								if _onoff_front_2 == false then
									object_front_2.spec_turnOnVehicle.setIsTurnedOn(object_front_2, _onoff_front_2)
								end
							end
							if object_hinten_2 ~= nil then
								if _onoff_hinten_2 == false then
									object_hinten_2.spec_turnOnVehicle.setIsTurnedOn(object_hinten_2, _onoff_hinten_2)
								end
							end								
							return
--						elseif _onoff_front == false or _onoff_front == true then 
--							object_front.spec_turnOnVehicle.setIsTurnedOn(object_front, _onoff_front)
--							return
--						elseif _onoff_front == false or _onoff_front == true then
--							object_hinten.spec_turnOnVehicle.setIsTurnedOn(object_hinten, _onoff_hinten)
--							return
						end
					else
						if object_front ~= nil then
							if _onoff_front ~= nil then
								object_front.spec_turnOnVehicle.setIsTurnedOn(object_front, _onoff_front)
							end	
							if object_front_2 ~= nil then
								if _onoff_front_2 ~= nil then
									if object_front == true and _onoff_front_2 == false then
										object_front_2.spec_turnOnVehicle.setIsTurnedOn(object_front_2, _onoff_front_2)
									elseif object_front == false and _onoff_front_2 == true then
										object_front_2.spec_turnOnVehicle.setIsTurnedOn(object_front_2, _onoff_front_2)
									end
								end	
							end
							return
						elseif object_hinten ~= nil then
							if _onoff_hinten ~= nil then
								object_hinten.spec_turnOnVehicle.setIsTurnedOn(object_hinten, _onoff_hinten)
							end
							if object_hinten_2 ~= nil then
								if _onoff_hinten_2 ~= nil then
									if object_hinten == true and _onoff_hinten_2 == false then
										object_hinten_2.spec_turnOnVehicle.setIsTurnedOn(object_hinten_2, _onoff_hinten_2)
									elseif object_hinten == false and _onoff_hinten_2 == true then
										object_hinten_2.spec_turnOnVehicle.setIsTurnedOn(object_hinten_2, _onoff_hinten_2)
									end
								end
							end	
							return
						end
					end
	end



  
--[[#####################################################################################################################################################################
###########################################################vorne/hinten  An/Aus ENDE          		  		 ############################################################
#######################################################################################################################################################################]] 
--[[#####################################################################################################################################################################
###########################################################vorne an/aus START       						 ############################################################
#######################################################################################################################################################################]]

	if FS19_H_VereinfachteSteuerung.functionabEinschaltenEnabledSeparat and actionName == "FS19_H_VereinfachteSteuerung_AJ_vorne_AnAus" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)
	
				local object_front
				local idx_vorne
				local _onoff_front = nil
				
				local object_front_2
				local idx_vorne_2
				local _onoff_front_2 = nil
				
					for i_vorne, obj_front in pairs(implements_front) do
						if object_front == nil then object_front = obj_front end
						if idx_vorne == nil then idx_vorne = i_vorne end
						if object_front ~= nil then object_front_2 = obj_front end
						if idx_vorne ~= nil then idx_vorne_2 = i_vorne end
					end
					if debug > 1 then 		print("-->   object_front--   " 	.. tostring(object_front) ) end
					if debug > 1 then 		print("-->   idx_vorne--      " 	.. tostring(idx_vorne) ) end
					if debug > 1 then 		print("-->   object_front_2--   " 	.. tostring(object_front_2) ) end
					if debug > 1 then 		print("-->   idx_vorne_2--      " 	.. tostring(idx_vorne_2) ) end					
					if debug > 1 then 		DebugUtil.printTableRecursively(object_front, "-" , 0, 0) end
					
					
					if object_front ~= nil then
						if object_front.spec_turnOnVehicle ~= nil then
							if _onoff_front == nil then
								_onoff_front = not object_front.spec_turnOnVehicle.isTurnedOn
								if debug > 1 then 		print("-->   object_front.spec_turnOnVehicle ~= nil--   " .. tostring(_onoff_front) ) end
							end
							if _onoff_front and object_front.spec_turnOnVehicle.requiresMotorTurnOn and self.spec_motorized and not self.spec_motorized:getIsOperating() then
								_onoff_front = false
								if debug > 1 then 		print("-->   _onoff_front--   " .. tostring(_onoff_front) ) end
							end	
						end
					end	
					if object_front_2 ~= nil then
						if object_front_2.spec_turnOnVehicle ~= nil then
							if _onoff_front_2 == nil then
								_onoff_front_2 = not object_front_2.spec_turnOnVehicle.isTurnedOn
								if debug > 1 then 		print("-->   object_front.spec_turnOnVehicle_2 ~= nil--   " .. tostring(_onoff_front_2) ) end
							end							
							if _onoff_front_2 and object_front_2.spec_turnOnVehicle.requiresMotorTurnOn and self.spec_motorized and not self.spec_motorized:getIsOperating() then
								_onoff_front_2 = false
								if debug > 1 then 		print("-->   _onoff_front_2--   " .. tostring(_onoff_front_2) ) end
							end	
						end		
					end
					
					
					if _onoff_front ~= nil and _onoff_front_2 ~= nil then				
						if _onoff_front == _onoff_front_2 then
							object_front.spec_turnOnVehicle.setIsTurnedOn(object_front, _onoff_front)
							object_front_2.spec_turnOnVehicle.setIsTurnedOn(object_front_2, _onoff_front_2)
							return
						elseif _onoff_front == true and _onoff_front_2 == false then
							object_front_2.spec_turnOnVehicle.setIsTurnedOn(object_front_2, _onoff_front_2)
							return
						elseif 	_onoff_front == false and _onoff_front_2 == true then
							object_front.spec_turnOnVehicle.setIsTurnedOn(object_front, _onoff_front)
							return
						end
					end	
						
						
					if _onoff_front == nil and _onoff_front_2 ~= nil then						
						object_front.spec_turnOnVehicle.setIsTurnedOn(object_front, _onoff_front)
					end
					if _onoff_front ~= nil and _onoff_front_2 == nil then						
						object_front_2.spec_turnOnVehicle.setIsTurnedOn(object_front_2, _onoff_front_2)	
					end
	end	
--[[#####################################################################################################################################################################
###########################################################vorne an/aus ENDE         						 ############################################################
#######################################################################################################################################################################]]	
--[[#####################################################################################################################################################################
###########################################################hinten an/aus START       						 ############################################################
#######################################################################################################################################################################]]

	if FS19_H_VereinfachteSteuerung.functionabEinschaltenEnabledSeparat and actionName == "FS19_H_VereinfachteSteuerung_AJ_hinten_AnAus" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)

				local object_hinten
				local idx_hinten
				local _onoff_hinten = nil
				
				local object_hinten_2
				local idx_hinten_2
				local _onoff_hinten_2 = nil
				
					for i_hinten, obj_hinten in pairs(implements_back) do
						if object_hinten == nil then object_hinten = obj_hinten end
						if idx_hinten == nil then idx_hinten = i_hinten end
						if object_hinten ~= nil then object_hinten_2 = obj_hinten end
						if idx_hinten ~= nil then idx_hinten_2 = i_hinten end						
					end
					if debug > 1 then 		print("-->   object_hinten--   " 	.. tostring(object_hinten) ) end
					if debug > 1 then 		print("-->   idx_hinten--      " 	.. tostring(idx_hinten) ) end
					if debug > 1 then 		print("-->   object_hinten_2--   " 	.. tostring(object_hinten_2) ) end
					if debug > 1 then 		print("-->   idx_hinten_2--      " 	.. tostring(idx_hinten_2) ) end
					if debug > 1 then 		DebugUtil.printTableRecursively(object_hinten, "-" , 0, 0) end
					
					
					if object_hinten ~= nil then
						if object_hinten.spec_turnOnVehicle ~= nil then
							if _onoff_hinten == nil then
								_onoff_hinten = not object_hinten.spec_turnOnVehicle.isTurnedOn
							end
							if _onoff_hinten and object_hinten.spec_turnOnVehicle.requiresMotorTurnOn and self.spec_motorized and not self.spec_motorized:getIsOperating() then
								_onoff_hinten = false
								if debug > 1 then 		print("-->   _onoff_hinten--   " .. tostring(_onoff_hinten) ) end
							end	
						end
					end	
					if object_hinten_2 ~= nil then
						if object_hinten_2.spec_turnOnVehicle ~= nil then
							if _onoff_hinten_2 == nil then
								_onoff_hinten_2 = not object_hinten_2.spec_turnOnVehicle.isTurnedOn
							end
							if _onoff_hinten_2 and object_hinten_2.spec_turnOnVehicle.requiresMotorTurnOn and self.spec_motorized and not self.spec_motorized:getIsOperating() then
								_onoff_hinten_2 = false
								if debug > 1 then 		print("-->   _onoff_hinten_2--   " .. tostring(_onoff_hinten_2) ) end
							end	
						end
					end
					
					
					
					if _onoff_hinten ~= nil and _onoff_hinten_2 ~= nil then
						if _onoff_hinten == _onoff_hinten_2 then
							object_hinten.spec_turnOnVehicle.setIsTurnedOn(object_hinten, _onoff_hinten)
							object_hinten_2.spec_turnOnVehicle.setIsTurnedOn(object_hinten_2, _onoff_hinten_2)
							return
						elseif	_onoff_hinten == true and _onoff_hinten_2 == false then
							object_hinten_2.spec_turnOnVehicle.setIsTurnedOn(object_hinten_2, _onoff_hinten_2)
							return
						elseif	_onoff_hinten == false and _onoff_hinten_2 == true then
							object_hinten.spec_turnOnVehicle.setIsTurnedOn(object_hinten, _onoff_hinten)
							return
						end
					end	


					if _onoff_hinten ~= nil and _onoff_hinten_2 == nil then
						object_hinten.spec_turnOnVehicle.setIsTurnedOn(object_hinten, _onoff_hinten)
					end
					if _onoff_hinten == nil and _onoff_hinten_2 ~= nil then
						object_hinten_2.spec_turnOnVehicle.setIsTurnedOn(object_hinten_2, _onoff_hinten_2)
					end
					
	end
	
--[[#####################################################################################################################################################################
###########################################################hinten an/aus ENDE       						 ############################################################
#######################################################################################################################################################################]]	
--[[#####################################################################################################################################################################
###########################################################vorne/hinten Auf/Zu klapen START	           		 ############################################################
#######################################################################################################################################################################]] 

    if FS19_H_VereinfachteSteuerung.functionabFaltbarEnabled and actionName == "FS19_H_VereinfachteSteuerung_AJ_hinten_vorne_AufZU" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)



			local	self_vorne  
			local	spec_vorne 
			local	toggleDirection_vorne = nil
			local 	vorne_foldable = false
			
			local	self_vorne_2  
			local	spec_vorne_2 
			local	toggleDirection_vorne_2 = nil
			local 	vorne_foldable_2 = false	
			
				for idx_vorne, object_front in pairs(implements_front) do
					if self_vorne == 				nil	then self_vorne 				= object_front end
					if spec_vorne == 				nil	then spec_vorne 				= self_vorne.spec_foldable end
						
					if 	self_vorne ~= nil then
						if self_vorne.spec_foldable ~= nil then
							if toggleDirection_vorne == 	nil	then toggleDirection_vorne 		= self_vorne:getToggledFoldDirection() end
						end
					end
					
					if self_vorne ~= 				nil	then self_vorne_2 				= object_front end
					if spec_vorne ~= 				nil	then spec_vorne_2 				= spec_vorne.spec_foldable end
						
					if spec_vorne ~= nil then
						if spec_vorne.spec_foldable ~= nil then
							if toggleDirection_vorne ~= 	nil	then toggleDirection_vorne_2 	= self_vorne_2:getToggledFoldDirection() end
						end	
					end						
				end
				if debug > 1 then 		print("-->   self_vorne--   " .. tostring(self_vorne) .. "   spec_vorne--   " .. tostring(spec_vorne) .. "   vorne toggleDirection_vorne--   " .. tostring(toggleDirection_vorne)) end
				if debug > 1 then 		print("-->   self_vorne_2--   " .. tostring(self_vorne_2) .. "   spec_vorne--   " .. tostring(spec_vorne_2) .. "   vorne toggleDirection_vorne_2--   " .. tostring(toggleDirection_vorne_2)) end
				if debug > 1 then
					if table.getn(spec_vorne.foldingParts) > 0 then print("-->  Forhanden spec_vorne.foldingParts") end
					if table.getn(spec_vorne_2.foldingParts) > 0 then print("-->  Forhanden spec_vorne_2.foldingParts") end
				end
				
			local	self_hinten 
			local	spec_hinten 
			local	toggleDirection_hinten = nil
			local 	hinten_foldable = false
			
			local	self_hinten_2 
			local	spec_hinten_2 
			local	toggleDirection_hinten_2 = nil
			local 	hinten_foldable_2 = false	
					
				for idx_hinten, object_hinten in pairs(implements_back) do	
					if self_hinten == nil then self_hinten = object_hinten end
					if spec_hinten == nil then spec_hinten = self_hinten.spec_foldable end
					
					if self_hinten ~= nil then
						if self_hinten.spec_foldable ~= nil then
							if toggleDirection_hinten == nil then toggleDirection_hinten = self_hinten:getToggledFoldDirection() end
						end
					end
					
					if self_hinten ~= nil then self_hinten_2 = object_hinten end
					if spec_hinten ~= nil then spec_hinten_2 = self_hinten.spec_foldable end
					
					if self_hinten ~= nil then
						if self_hinten.spec_foldable ~= nil then
							if toggleDirection_hinten ~= 	nil then toggleDirection_hinten_2 	= self_hinten_2:getToggledFoldDirection() end
						end
					end
				end
				if debug > 1 then 		print("-->   self_hinten--   " .. tostring(self_hinten) .. "   spec_hinten--   " .. tostring(spec_hinten) .. "   hinten toggleDirection_hinten--   " .. tostring(toggleDirection_hinten)) end
				if debug > 1 then 		print("-->   self_hinten_2--   " .. tostring(self_hinten_2) .. "   spec_hinten_2--   " .. tostring(spec_hinten_2) .. "   hinten toggleDirection_hinten_2--   " .. tostring(toggleDirection_hinten_2)) end
				if debug > 1 then
					if table.getn(spec_hinten.foldingParts) > 0 then print("-->  Forhanden spec_hinten.foldingParts") end
					if table.getn(spec_hinten_2.foldingParts) > 0 then print("-->  Forhanden spec_hinten_2.foldingParts") end
				end
			
			
			
			
				if spec_vorne ~= nil and spec_hinten ~= nil then
					if table.getn(spec_hinten.foldingParts) > 0 and table.getn(spec_vorne.foldingParts) > 0 then
						if toggleDirection_vorne == toggleDirection_hinten then
							vorne_foldable = true
							hinten_foldable = true
							if toggleDirection_vorne_2 ~= nil then
								if toggleDirection_vorne_2 == toggleDirection_hinten then
									vorne_foldable_2 = true
								end
							end
							if toggleDirection_hinten_2 ~= nil then
								if toggleDirection_hinten_2 == toggleDirection_hinten then
									hinten_foldable_2 = true
								end
							end
							if debug > 1 then 		print("-->  toggleDirection_vorne == toggleDirection_hinten   vorne   "  .. toggleDirection_vorne .. "   hinten   "  .. toggleDirection_hinten .. "   vorne_2   "  .. toggleDirection_vorne_2 .. "   hinten_2   "  .. toggleDirection_hinten_2) end
						
						elseif toggleDirection_vorne > toggleDirection_hinten then
							vorne_foldable = true
							if toggleDirection_vorne_2 ~= nil then
								if toggleDirection_vorne_2 > toggleDirection_hinten then
									vorne_foldable_2 = true
								end
							end	
							if toggleDirection_hinten_2 ~= nil then
								if toggleDirection_hinten_2 > toggleDirection_hinten then
									hinten_foldable_2 = true
								end
							end
							if debug > 1 then 		print("-->  toggleDirection_vorne > toggleDirection_hinten   vorne   "  .. toggleDirection_vorne .. "   hinten   "  .. toggleDirection_hinten .. "   vorne_2   "  .. toggleDirection_vorne_2 .. "   hinten_2   "  .. toggleDirection_hinten_2) end
					
						elseif toggleDirection_vorne < toggleDirection_hinten then
							hinten_foldable = true
							if toggleDirection_vorne_2 ~= nil then
								if toggleDirection_vorne_2 ~= toggleDirection_vorne then
									vorne_foldable_2 = true
								end
							end	
							if toggleDirection_hinten_2 ~= nil then
								if toggleDirection_hinten_2 > toggleDirection_vorne then
									hinten_foldable_2 = true
								end
							end	
							if debug > 1 then 		print("-->  toggleDirection_vorne < toggleDirection_hinten   vorne   "  .. toggleDirection_vorne .. "   hinten   "  .. toggleDirection_hinten .. "   vorne_2   "  .. toggleDirection_vorne_2 .. "   hinten_2   "  .. toggleDirection_hinten_2) end
										
						end
						
					else
						if debug > 1 then print("--> nur ein gerät was auf und zu geht") end
						if toggleDirection_vorne ~= nil then
							if debug > 1 then 		print("-->  vorne   "  .. toggleDirection_vorne) end
								vorne_foldable = true
							if toggleDirection_vorne_2 ~= nil then
								if toggleDirection_vorne_2 == toggleDirection_vorne then
									vorne_foldable_2 = true	
								end
							end
						elseif toggleDirection_hinten ~= nil then
							if debug > 1 then 		print("-->  hinten   "  .. toggleDirection_hinten) end
							hinten_foldable = true
							if toggleDirection_hinten_2 ~= nil then
								if toggleDirection_hinten_2 == toggleDirection_hinten then
									hinten_foldable_2 = true
								end
							end
						end
					end
			else
				if debug > 1 then print("--> nur ein gerät angehangen") end
				if toggleDirection_vorne ~= nil then
					if debug > 1 then 		print("-->  vorne   "  .. toggleDirection_vorne) end
						vorne_foldable = true
					if toggleDirection_vorne_2 ~= nil then
						if toggleDirection_vorne_2 == toggleDirection_vorne then
							vorne_foldable_2 = true						
						end	
					end
				elseif toggleDirection_hinten ~= nil then
					if debug > 1 then 		print("-->  hinten   "  .. toggleDirection_hinten) end
						hinten_foldable = true
					if toggleDirection_hinten_2 ~= nil then
						if toggleDirection_hinten_2 == toggleDirection_hinten then
							hinten_foldable_2 = true
						end
					end
				end
			end
			
						
							
						if vorne_foldable == true and toggleDirection_vorne ~= 0 then
							if debug > 1 then 		print("-->  vorne   "  .. tostring(vorne_foldable)) end
							if table.getn(spec_vorne.foldingParts) > 0 then
								if self_vorne:getIsFoldAllowed(toggleDirection_vorne, false) then
									if toggleDirection_vorne == spec_vorne.turnOnFoldDirection then
										self_vorne:setFoldState(toggleDirection_vorne, true)
									else
										self_vorne:setFoldState(toggleDirection_vorne, false)
									end
								end
							end
						end
						

				if hinten_foldable == true and toggleDirection_hinten ~= 0 then
					if debug > 1 then 		print("-->  hinten   "  .. tostring(hinten_foldable)) end
					if table.getn(spec_hinten.foldingParts) > 0 then
						if self_hinten:getIsFoldAllowed(toggleDirection_hinten, false) then
							if toggleDirection_hinten == spec_hinten.turnOnFoldDirection then
							self_hinten:setFoldState(toggleDirection_hinten, true)
							else
							self_hinten:setFoldState(toggleDirection_hinten, false)
							end
						end
					end
				end
				
				
				if vorne_foldable_2 == true and toggleDirection_vorne_2 ~= 0 then
					if debug > 1 then 		print("-->  vorne_2   "  .. tostring(vorne_foldable_2)) end
					if table.getn(spec_vorne_2.foldingParts) > 0 then
						if self_vorne_2:getIsFoldAllowed(toggleDirection_vorne_2, false) then
							if toggleDirection_vorne_2 == spec_vorne_2.turnOnFoldDirection then
								self_vorne_2:setFoldState(toggleDirection_vorne_2, true)
							else
								self_vorne_2:setFoldState(toggleDirection_vorne_2, false)
							end
						end
					end
				end
						

				if hinten_foldable_2 == true and toggleDirection_hinten_2 ~= 0 then
					if debug > 1 then 		print("-->  hinten_2   "  .. tostring(hinten_foldable_2)) end
					if table.getn(spec_hinten_2.foldingParts) > 0 then
						if self_hinten_2:getIsFoldAllowed(toggleDirection_hinten_2, false) then
							if toggleDirection_hinten_2 == spec_hinten_2.turnOnFoldDirection then
							self_hinten_2:setFoldState(toggleDirection_hinten_2, true)
							else
							self_hinten_2:setFoldState(toggleDirection_hinten_2, false)
							end
						end
					end
				end

	end
	 	
		
--[[#####################################################################################################################################################################
###########################################################vorne hinten Auf/Zu klapen ENDE	           		 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################vorne Auf/Zu klapen START	           		 	 ############################################################
#######################################################################################################################################################################]] 

    if FS19_H_VereinfachteSteuerung.functionabFaltbarEnabledSeparat and actionName == "FS19_H_VereinfachteSteuerung_AJ_vorne_AufZU" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)



			local	self_vorne  
			local	spec_vorne 
			local	toggleDirection_vorne = nil
			local 	vorne_foldable = false
			
			local	self_vorne_2  
			local	spec_vorne_2 
			local	toggleDirection_vorne_2 = nil
			local 	vorne_foldable_2 = false	
			
				for idx_vorne, object_front in pairs(implements_front) do
					if self_vorne == 				nil	then self_vorne 				= object_front end
					if spec_vorne == 				nil	then spec_vorne 				= self_vorne.spec_foldable end
						
					if spec_vorne ~= nil then
						if spec_vorne.spec_foldable ~= nil then
							if toggleDirection_vorne == 	nil	then toggleDirection_vorne 		= self_vorne:getToggledFoldDirection() end
						end
					end	
					if self_vorne ~= 				nil	then self_vorne_2 				= object_front end
					if spec_vorne ~= 				nil	then spec_vorne_2 				= spec_vorne.spec_foldable end
						
					if spec_vorne ~= nil then
						if spec_vorne.spec_foldable ~= nil then
							if toggleDirection_vorne ~= 	nil	then toggleDirection_vorne_2 	= self_vorne_2:getToggledFoldDirection() end
						end
					end						
				end
				if debug > 1 then 		print("-->   self_vorne--   " .. tostring(self_vorne) .. "   spec_vorne--   " .. tostring(spec_vorne) .. "   vorne toggleDirection_vorne--   " .. tostring(toggleDirection_vorne)) end
				if debug > 1 then 		print("-->   self_vorne_2--   " .. tostring(self_vorne_2) .. "   spec_vorne--   " .. tostring(spec_vorne_2) .. "   vorne toggleDirection_vorne_2--   " .. tostring(toggleDirection_vorne_2)) end
				if debug > 1 then
					if table.getn(spec_vorne.foldingParts) > 0 then print("-->  Forhanden spec_vorne.foldingParts") end
					if table.getn(spec_vorne_2.foldingParts) > 0 then print("-->  Forhanden spec_vorne_2.foldingParts") end
				end
				
				
				
				if toggleDirection_vorne ~= nil then
					if debug > 1 then 		print("-->  vorne   "  .. toggleDirection_vorne) end
						vorne_foldable = true
					if toggleDirection_vorne_2 ~= nil then
						if toggleDirection_vorne_2 == toggleDirection_vorne then
							vorne_foldable_2 = true						
						end	
					end
				end	
				
				
				
				if vorne_foldable == true and toggleDirection_vorne ~= 0 then
					if debug > 1 then 		print("-->  vorne   "  .. tostring(vorne_foldable)) end
					if table.getn(spec_vorne.foldingParts) > 0 then
						if self_vorne:getIsFoldAllowed(toggleDirection_vorne, false) then
							if toggleDirection_vorne == spec_vorne.turnOnFoldDirection then
								self_vorne:setFoldState(toggleDirection_vorne, true)
							else
								self_vorne:setFoldState(toggleDirection_vorne, false)
							end
						end
					end
				end
				if vorne_foldable_2 == true and toggleDirection_vorne_2 ~= 0 then
					if debug > 1 then 		print("-->  vorne_2   "  .. tostring(vorne_foldable_2)) end
					if table.getn(spec_vorne_2.foldingParts) > 0 then
						if self_vorne_2:getIsFoldAllowed(toggleDirection_vorne_2, false) then
							if toggleDirection_vorne_2 == spec_vorne_2.turnOnFoldDirection then
								self_vorne_2:setFoldState(toggleDirection_vorne_2, true)
							else
								self_vorne_2:setFoldState(toggleDirection_vorne_2, false)
							end
						end
					end
				end
			
	end
--[[#####################################################################################################################################################################
###########################################################vorne Auf/Zu klapen ENDE	           		 	 	 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################hinten Auf/Zu klapen START	           		 	 ############################################################
#######################################################################################################################################################################]] 

    if FS19_H_VereinfachteSteuerung.functionabFaltbarEnabledSeparat and actionName == "FS19_H_VereinfachteSteuerung_AJ_hinten_AufZU" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)

			local	self_hinten 
			local	spec_hinten 
			local	toggleDirection_hinten = nil
			local 	hinten_foldable = false
			
			local	self_hinten_2 
			local	spec_hinten_2 
			local	toggleDirection_hinten_2 = nil
			local 	hinten_foldable_2 = false	
					
				for idx_hinten, object_hinten in pairs(implements_back) do	
					if self_hinten == 				nil then self_hinten  				= object_hinten end
					if spec_hinten == 				nil then spec_hinten 				= self_hinten.spec_foldable end
					
					if self_hinten ~= nil then
						if self_hinten.spec_foldable ~= nil then
							if toggleDirection_hinten == 	nil then toggleDirection_hinten 	= self_hinten:getToggledFoldDirection() end
						end
					end
					
					if self_hinten ~= 				nil then self_hinten_2  			= object_hinten end
					if spec_hinten ~= 				nil then spec_hinten_2 				= self_hinten.spec_foldable end		
					
					if self_hinten ~= nil then
						if self_hinten.spec_foldable ~= nil then
							if toggleDirection_hinten ~= 	nil then toggleDirection_hinten_2 	= self_hinten_2:getToggledFoldDirection() end
						end	
					end
						
				end
				if debug > 1 then 		print("-->   self_hinten--   " .. tostring(self_hinten) .. "   spec_hinten--   " .. tostring(spec_hinten) .. "   hinten toggleDirection_hinten--   " .. tostring(toggleDirection_hinten)) end
				if debug > 1 then 		print("-->   self_hinten_2--   " .. tostring(self_hinten_2) .. "   spec_hinten_2--   " .. tostring(spec_hinten_2) .. "   hinten toggleDirection_hinten_2--   " .. tostring(toggleDirection_hinten_2)) end
				if debug > 1 then
					if table.getn(spec_hinten.foldingParts) > 0 then print("-->  Forhanden spec_hinten.foldingParts") end
					if table.getn(spec_hinten_2.foldingParts) > 0 then print("-->  Forhanden spec_hinten_2.foldingParts") end
				end
				
				if toggleDirection_hinten ~= nil then
					if debug > 1 then 		print("-->  hinten   "  .. toggleDirection_hinten) end
					hinten_foldable = true
					if toggleDirection_hinten_2 ~= nil then
						if toggleDirection_hinten_2 == toggleDirection_hinten then
							hinten_foldable_2 = true
						end
					end
				end
					
				
				if hinten_foldable == true and toggleDirection_hinten ~= 0 then
					if debug > 1 then 		print("-->  hinten   "  .. tostring(hinten_foldable)) end
					if table.getn(spec_hinten.foldingParts) > 0 then
						if self_hinten:getIsFoldAllowed(toggleDirection_hinten, false) then
							if toggleDirection_hinten == spec_hinten.turnOnFoldDirection then
							self_hinten:setFoldState(toggleDirection_hinten, true)
							else
							self_hinten:setFoldState(toggleDirection_hinten, false)
							end
						end
					end
				end
				if hinten_foldable_2 == true and toggleDirection_hinten_2 ~= 0 then
					if debug > 1 then 		print("-->  hinten_2   "  .. tostring(hinten_foldable_2)) end
					if table.getn(spec_hinten_2.foldingParts) > 0 then
						if self_hinten_2:getIsFoldAllowed(toggleDirection_hinten_2, false) then
							if toggleDirection_hinten_2 == spec_hinten_2.turnOnFoldDirection then
							self_hinten_2:setFoldState(toggleDirection_hinten_2, true)
							else
							self_hinten_2:setFoldState(toggleDirection_hinten_2, false)
							end
						end
					end
				end
	end

--[[#####################################################################################################################################################################
###########################################################hinten Auf/Zu klapen ENDE	           		 	 ############################################################
#######################################################################################################################################################################]]  
--[[#####################################################################################################################################################################
###########################################################vorne Apkoppeln START       		         		 ############################################################
#######################################################################################################################################################################]]

    if FS19_H_VereinfachteSteuerung.functionabKoppelnEnabled and actionName == "FS19_H_VereinfachteSteuerung_AJ_vorne_abkoppeln" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)

					for i_vorne, obj_front in pairs(implements_front) do
						    local spec = obj_front.spec_attachable
							if spec.attacherVehicle ~= nil then
								spec.attacherVehicle:detachImplementByObject(obj_front, false)
							end
							g_currentMission:removeAttachableVehicle(obj_front)
					end
	end

--[[#####################################################################################################################################################################
###########################################################vorne Apkoppeln ENDE       		         		 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################hinten Apkoppeln START       		       		 ############################################################
#######################################################################################################################################################################]]

    if FS19_H_VereinfachteSteuerung.functionabKoppelnEnabled and actionName == "FS19_H_VereinfachteSteuerung_AJ_hinten_abkoppeln" then
		FS19_H_VereinfachteSteuerung:enumerateAttachments(self)

					for i_hinten, obj_hinten in pairs(implements_back) do
						    local spec = obj_hinten.spec_attachable
							if spec.attacherVehicle ~= nil then
								spec.attacherVehicle:detachImplementByObject(obj_hinten, false) 
							end
								g_currentMission:removeAttachableVehicle(obj_hinten)
					end
	end

--[[#####################################################################################################################################################################
###########################################################hinten Apkoppeln ENDE       		         		 ############################################################
#######################################################################################################################################################################]]
--[[#####################################################################################################################################################################
###########################################################Konfig zurücksetzen								 ############################################################
#######################################################################################################################################################################]]

  -- Konfig zurücksetzen
  if actionName == "FS19_H_VereinfachteSteuerung_RESET" then
    if mogli_loaded and (self.ksmShuttleIsOn or self.ksmShuttleCtrl or self.vcaShuttleCtrl) then
      FS19_H_VereinfachteSteuerung:resetConfig(true)
    else
      FS19_H_VereinfachteSteuerung:resetConfig()
    end
    xmlM:writeConfig()
    FS19_H_VereinfachteSteuerung:activateConfig()
  end

  -- Konfiguration neu laden
  if actionName == "FS19_H_VereinfachteSteuerung_RELOAD" then
    xmlM:readConfig()
    FS19_H_VereinfachteSteuerung:activateConfig()
  end

  -- debug stuff
  if H_dbg then
    -- debug1
    if actionName == "H_DBG1_UP" then
      H_dbg1 = H_dbg1 + 0.01
      updateDifferential(self.rootNode, 2, H_dbg1, H_dbg2)
    end
    if actionName == "H_DBG1_DOWN" then
      H_dbg1 = H_dbg1 - 0.01
      updateDifferential(self.rootNode, 2, H_dbg1, H_dbg2)
    end
    -- debug2
    if actionName == "H_DBG2_UP" then
      H_dbg2 = H_dbg2 + 0.01
      updateDifferential(self.rootNode, 2, H_dbg1, H_dbg2)
    end
    if actionName == "H_DBG2_DOWN" then
      H_dbg2 = H_dbg2 - 0.01
      updateDifferential(self.rootNode, 2, H_dbg1, H_dbg2)
    end
    -- debug3
    if actionName == "H_DBG3_UP" then
      H_dbg3 = H_dbg3 + 0.01
    end
    if actionName == "H_DBG3_DOWN" then
      H_dbg3 = H_dbg3 - 0.01
    end
  end

end

--[[#####################################################################################################################################################################
###########################################################Hydraulic Index									 ############################################################
#######################################################################################################################################################################]]

function FS19_H_VereinfachteSteuerung:cameras(obj)
	local index, kamera
	if debug > 1 then 		DebugUtil.printTableRecursively(obj.spec_enterable.cameras, "-" , 0, 2) end
  
	for index, kamera in pairs(obj.spec_enterable.cameras) do
		if kamera ~= nil and index ~= nil then
			table.insert(kamera_winkel, { kamera, index }) 			
		end
	end
	if debug > 1 then 		DebugUtil.printTableRecursively(kamera_winkel, "-" , 0, 0) end
end



function FS19_H_VereinfachteSteuerung:enumerateAttachments2(rootNode, obj)

  if debug > 1 then print("entering: "..obj.rootNode) end

  local idx, attacherJoint
  local relX, relY, relZ



  for idx, attacherJoint in pairs(obj.spec_attacherJoints.attacherJoints) do
    -- Position relativ zu unserem Fahrzeug
    local x, y, z = getWorldTranslation(attacherJoint.jointTransform)
    relX, relY, relZ = worldToLocal(rootNode, x, y, z)
    -- wenn es auf und ab bewegt werden kann ->
    if attacherJoint.allowsLowering then
      if relZ > 0 then -- Vorderseite
        table.insert(joints_front, { obj, idx })
      end
      if relZ < 0 then -- zurück
        table.insert(joints_back, { obj, idx })
      end
      if debug > 2 then print(obj.rootNode.."/"..idx.." x: "..tostring(x)..", y: "..tostring(y)..", z: "..tostring(z)) end
      if debug > 2 then print(obj.rootNode.."/"..idx.." x: "..tostring(relX)..", y: "..tostring(relY)..", z: "..tostring(relZ)) end
    end

    -- Was ist hier angebracht?
    local implement = obj.spec_attacherJoints:getImplementByJointDescIndex(idx)
    if implement ~= nil and implement.object ~= nil then
      if relZ > 0 then -- Vorderseite
        table.insert(implements_front, implement.object)
      end
      if relZ < 0 then -- zurück
        table.insert(implements_back, implement.object)
      end

      -- when it has joints by itsself then recursive into them
      if implement.object.spec_attacherJoints ~= nil then
        if debug > 1 then print("go into recursive:"..obj.rootNode) end
        FS19_H_VereinfachteSteuerung:enumerateAttachments2(rootNode, implement.object)
      end

    end
  end
  if debug > 1 then print("leaving: "..obj.rootNode) end
end

--[[#####################################################################################################################################################################
###########################################################Hydraulic Index									 ############################################################
#######################################################################################################################################################################]]

function FS19_H_VereinfachteSteuerung:enumerateAttachments(obj)
  joints_front = {}
  joints_back = {}
  implements_front = {}
  implements_back = {}
  kamera_winkel = {}

  -- stellen sie eine liste aller anhänge zusammen
  FS19_H_VereinfachteSteuerung:enumerateAttachments2(obj.rootNode, obj)
  FS19_H_VereinfachteSteuerung:cameras(obj)
end

-- #############################################################################


function mySelf(obj)
  return " (rootNode: " .. obj.rootNode .. ", typeName: " .. obj.typeName .. ", typeDesc: " .. obj.typeDesc .. ")"
end

-- #############################################################################
