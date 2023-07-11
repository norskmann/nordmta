local sx, sy = guiGetScreenSize()
local zoom = sx < 1920 and math.min(2, 1920 / sx) or 1
local fonts = {
  [1] = exports.nord_fonts:getFont("Manrope-SemiBold.ttf", 16) or "default-bold",
  [2] = exports.nord_fonts:getFont("Manrope-SemiBold.ttf", 12) or "default-bold",
}
local CacheData = {}
local isHUDEnabled = false

function drawHUD(player)
  dxDrawImage(sx - 150 / zoom, 33 / zoom, 98 / zoom, 98 / zoom, CacheData.avatarImage or "images/noavatar.png")
  local playerMoney = getPlayerMoney(player)
  if (CacheData.playerMoney or (-1)) ~= playerMoney then
    CacheData.playerMoney = playerMoney
    CacheData.playerMoneyFormated = formatNumber(playerMoney, ",")
  end
  dxDrawText(CacheData.playerMoneyFormated .. " $", sx - 171 / zoom, 51 / zoom, sx - 171 / zoom, 51 / zoom, tocolor(0, 0, 0, 60), 1 / zoom, fonts[1], "right", "top")
  dxDrawText("#FFFFFF" .. CacheData.playerMoneyFormated .. " #34b518$", sx - 172 / zoom, 50 / zoom, sx - 172 / zoom, 50 / zoom, tocolor(230, 230, 230, 220), 1 / zoom, fonts[1], "right", "top", false, false, false, true)

  local playerName = getPlayerName(player)
  dxDrawText(playerName, sx - 171 / zoom, 81 / zoom, sx - 171 / zoom, 71 / zoom, tocolor(0, 0, 0, 60), 1 / zoom, fonts[1], "right", "top")
  dxDrawText(playerName, sx - 172 / zoom, 80 / zoom, sx - 172 / zoom, 70 / zoom, tocolor(230, 230, 230, 220), 1 / zoom, fonts[1], "right", "top", false, false, false, true)

  local daysOfWeek = {
    "Niedziela",
    "Poniedziałek",
    "Wtorek",
    "Środa",
    "Czwartek",
    "Piątek",
    "Sobota"
  }
  local version = (getVersion()).number
  local currentTime = getRealTime()
  local dayOfWeek = daysOfWeek[currentTime.weekday + 1]
  dxDrawText("nordmta.pl (v" .. version .. ") - " .. dayOfWeek .. " " .. string.format("%02d", currentTime.hour) .. ":" .. string.format("%02d", currentTime.minute) .. "", sx - 1655 / zoom, sy - 19 / zoom, _, _, tocolor(255, 255, 255, 120), 1 / zoom, fonts[2], "right")
end

function enableHUD()
  if not isHUDEnabled then
    addEventHandler("onClientRender", root, function() drawHUD(localPlayer) end)
    addEventHandler("onClientPlayerDamage", localPlayer, onClientPlayerHealthChange)
    addEventHandler("onClientPlayerWeaponFire", localPlayer, onClientPlayerHealthChange)
    addEventHandler("onClientPlayerWeaponSwitch", localPlayer, onClientPlayerHealthChange)
    isHUDEnabled = true
  end
end

addEventHandler("onClientResourceStart", resourceRoot, enableHUD)

function disableHUD()
  if isHUDEnabled then
    removeEventHandler("onClientRender", root, function() drawHUD(localPlayer) end)
    removeEventHandler("onClientPlayerDamage", localPlayer, onClientPlayerHealthChange)
    removeEventHandler("onClientPlayerWeaponFire", localPlayer, onClientPlayerHealthChange)
    removeEventHandler("onClientPlayerWeaponSwitch", localPlayer, onClientPlayerHealthChange)
    isHUDEnabled = false
  end
end

addEventHandler("onClientResourceStop", resourceRoot, disableHUD)

function toggleDefalutHUD(state)
  local components = {
    "ammo",
    "armour",
    "breath",
    "clock",
    "health",
    "money",
    "weapon",
    "wanted"
  }
  for i, v in ipairs(components) do
    setPlayerHudComponentVisible(v, state)
  end
end

addEventHandler("onClientResourceStart", getResourceRootElement(), function()
  toggleDefalutHUD(false)
end)

addEventHandler("onClientResourceStop", getResourceRootElement(), function()
  toggleDefalutHUD(true)
end)

function onClientPlayerHealthChange()
  if getElementHealth(localPlayer) ~= (CacheData.playerHealth or (-1)) then
    if CacheData.playerHealth and CacheData.playerHealth ~= getElementHealth(localPlayer) and getElementHealth(localPlayer) < CacheData.playerHealth then
      CacheData.playerHealthTick = getTickCount()
    end
    CacheData.playerHealth = getElementHealth(localPlayer)
  end
end

enableHUD()
