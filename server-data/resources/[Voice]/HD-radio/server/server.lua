HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateUseableItem("radio", function(source, item)
  local Player = HDCore.Functions.GetPlayer(source)
  TriggerClientEvent('HD-radio:use', source)
end)

HDCore.Functions.CreateCallback('HD-radio:server:GetItem', function(source, cb, item)
  local src = source
  local Player = HDCore.Functions.GetPlayer(src)
  if Player ~= nil then 
    local RadioItem = Player.Functions.GetItemByName(item)
    if RadioItem ~= nil then
      cb(true)
    else
      cb(false)
    end
  else
    cb(false)
  end
end)