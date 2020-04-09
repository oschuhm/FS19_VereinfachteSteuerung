--
-- Mod: FS19_H_VereinfachteSteuerung_Register
--
-- Author: Hummel2211
-- email: 
-- @Date: 12.06.2019
-- @Version: 1.0.0.0

-- #############################################################################

source(Utils.getFilename("FS19_H_VereinfachteSteuerung.lua", g_currentModDirectory))


-- include our new libConfig XML management
source(Utils.getFilename("xmlManager.lua", g_currentModDirectory))
xmlM = xmlManager("FS19_H_VereinfachteSteuerung", 1, 0)


FS19_H_VereinfachteSteuerung_Register = {}
FS19_H_VereinfachteSteuerung_Register.modDirectory = g_currentModDirectory;

local modDesc = loadXMLFile("modDesc", g_currentModDirectory .. "modDesc.xml");
FS19_H_VereinfachteSteuerung_Register.version = getXMLString(modDesc, "modDesc.version");


if g_specializationManager:getSpecializationByName("FS19_H_VereinfachteSteuerung") == nil then
  if FS19_H_VereinfachteSteuerung == nil then
    print("ERROR: unable to add specialization 'FS19_H_VereinfachteSteuerung'")
  else
    for i, typeDef in pairs(g_vehicleTypeManager.vehicleTypes) do
      if typeDef ~= nil and i ~= "locomotive" then
        local isDrivable  = false
        local isEnterable = false
        local hasMotor    = false
        for name, spec in pairs(typeDef.specializationsByName) do
          if name == "drivable"  then
            isDrivable = true
          elseif name == "motorized" then
            hasMotor = true
          elseif name == "enterable" then
            isEnterable = true
          end
        end
        if isDrivable and isEnterable and hasMotor then
          if debug > 1 then print("INFO: attached specialization 'FS19_H_VereinfachteSteuerung' to vehicleType '" .. tostring(i) .. "'") end
          typeDef.specializationsByName["FS19_H_VereinfachteSteuerung"] = FS19_H_VereinfachteSteuerung
          table.insert(typeDef.specializationNames, "FS19_H_VereinfachteSteuerung")
          table.insert(typeDef.specializations, FS19_H_VereinfachteSteuerung)
        end
      end
    end
  end
end

-- #############################################################################

function FS19_H_VereinfachteSteuerung_Register:loadMap()
	print("########################################################################################################")
	print("--> FS19_H_VereinfachteSteuerung version " .. self.version .. " (by Hummel2211) <--");
	print("########################################################################################################")

  -- first set our current and default config to default values
  if g_modIsLoaded.FS19_KeyboardSteer ~= nil or g_modIsLoaded.FS19_VehicleControlAddon ~= nil then
    FS19_H_VereinfachteSteuerung:resetConfig(true)
  else
    FS19_H_VereinfachteSteuerung:resetConfig()
  end

  -- then read values from disk and "overwrite" current config
  xmlM:readConfig()
  -- then write current config (which is now a merge between default values and from disk)
  xmlM:writeConfig()
  -- and finally activate current config
  FS19_H_VereinfachteSteuerung:activateConfig()
end

-- #############################################################################

function FS19_H_VereinfachteSteuerung_Register:deleteMap()
	print("########################################################################################################")
	print("--> unloaded FS19_H_VereinfachteSteuerung version " .. self.version .. " (by Hummel2211) <--");
	print("########################################################################################################")
end

-- #############################################################################

function FS19_H_VereinfachteSteuerung_Register:keyEvent(unicode, sym, modifier, isDown)
end

-- #############################################################################

function FS19_H_VereinfachteSteuerung_Register:mouseEvent(posX, posY, isDown, isUp, button)
end

-- #############################################################################

function FS19_H_VereinfachteSteuerung_Register:update(dt)
end

-- #############################################################################

addModEventListener(FS19_H_VereinfachteSteuerung_Register);
