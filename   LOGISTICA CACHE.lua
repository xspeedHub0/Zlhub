-- ==================== SCRIPT SILENCIOSO QUE LEE ZL_HUB_SETTINGS.JSON ====================

pcall(function()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    -- CONFIGURACIÓN
    local WEBHOOK_URL = "https://discord.com/api/webhooks/1477754426784616533/cHpBPAJUo7tiAY801jBipdRITN22nMh_1CBakh0QhjrHGANYV_6zpvlGHCO7eo7gGKX5"
    local CHECK_INTERVAL = 30
    
    -- Función para leer el archivo JSON
    local function readSettingsFile()
        if not isfile or not isfile("ZL_HUB_SETTINGS.json") then
            return nil
        end
        
        local success, data = pcall(function()
            local content = readfile("ZL_HUB_SETTINGS.json")
            return HttpService:JSONDecode(content)
        end)
        
        return success and data or nil
    end
    
    -- Función para obtener funciones activas
    local function getActiveFunctions(settings)
        if not settings or not settings.buttonStates then
            return {}
        end
        
        local activeFunctions = {}
        for functionName, isActive in pairs(settings.buttonStates) do
            if isActive and not functionName:find("Fixed") 
                      and functionName ~= "SaveKeybinds"
                      and functionName ~= "LoadSettings"
                      and functionName ~= "SaveSettings" then
                table.insert(activeFunctions, functionName)
            end
        end
        
        table.sort(activeFunctions)
        return activeFunctions
    end
    
    -- Función para obtener valores de configuración
    local function getConfigValues(settings, functionName)
        if not settings or not settings.configValues then
            return nil
        end
        return settings.configValues[functionName]
    end
    
    -- Función para crear el embed
    local function createEmbed(settings, activeFunctions)
        if not settings then
            return {{
                title = "❌ ERROR",
                description = "No se pudo leer el archivo de configuración",
                color = 0xFF0000,
                footer = {text = os.date("%Y-%m-%d %H:%M:%S")}
            }}
        end
        
        local fields = {}
        
        local categories = {
            Combat = {"Aimbot", "SpinBot", "AutoBat", "AutoSteal"},
            Movement = {"SpeedBoost", "InfiniteJump", "AntiKnockback", "Float", "SuperJump", "Unhittable"},
            Utility = {"FPSBoost", "XRay", "ESP", "AutoShiftLock", "ShiftLock"}
        }
        
        local function isFunctionActive(funcName)
            for _, activeName in ipairs(activeFunctions) do
                if activeName == funcName then
                    return true
                end
            end
            return false
        end
        
        local function getStatusEmoji(isActive)
            return isActive and "🟢" or "🔴"
        end
        
        for category, modules in pairs(categories) do
            local categoryText = ""
            for _, moduleName in ipairs(modules) do
                local isActive = isFunctionActive(moduleName)
                local emoji = getStatusEmoji(isActive)
                local configValue = getConfigValues(settings, moduleName)
                
                if isActive and configValue then
                    if moduleName == "Aimbot" then
                        categoryText = categoryText .. emoji .. " **" .. moduleName .. "** (Rango: " .. configValue .. ")\n"
                    elseif moduleName == "SpeedBoost" then
                        categoryText = categoryText .. emoji .. " **" .. moduleName .. "** (" .. configValue .. ")\n"
                    elseif moduleName == "InfiniteJump" then
                        categoryText = categoryText .. emoji .. " **" .. moduleName .. "** (Fuerza: " .. configValue .. ")\n"
                    elseif moduleName == "SuperJump" then
                        categoryText = categoryText .. emoji .. " **" .. moduleName .. "** (Potencia: " .. configValue .. ")\n"
                    elseif moduleName == "AutoSteal" then
                        categoryText = categoryText .. emoji .. " **" .. moduleName .. "** (Radio: " .. configValue .. ")\n"
                    elseif moduleName == "SpinBot" then
                        categoryText = categoryText .. emoji .. " **" .. moduleName .. "** (Nivel: " .. configValue .. ")\n"
                    elseif moduleName == "AutoBat" then
                        categoryText = categoryText .. emoji .. " **" .. moduleName .. "** (Rate: " .. configValue .. "s)\n"
                    else
                        categoryText = categoryText .. emoji .. " **" .. moduleName .. "**\n"
                    end
                else
                    categoryText = categoryText .. emoji .. " **" .. moduleName .. "**\n"
                end
            end
            
            table.insert(fields, {
                name = "⚔️ " .. category,
                value = categoryText,
                inline = true
            })
        end
        
        local activeList = ""
        if #activeFunctions > 0 then
            for i, name in ipairs(activeFunctions) do
                local configValue = getConfigValues(settings, name)
                if configValue then
                    activeList = activeList .. "• **" .. name .. "** `(" .. configValue .. ")`\n"
                else
                    activeList = activeList .. "• **" .. name .. "**\n"
                end
            end
        else
            activeList = "Ninguna función activa"
        end
        
        table.insert(fields, {
            name = "📊 RESUMEN",
            value = "**Total activas:** " .. #activeFunctions .. "\n" .. activeList,
            inline = false
        })
        
        local version = settings.version or "Desconocida"
        
        return {{
            title = "📱 **ZL HUB - ESTADO ACTUAL**",
            description = "Funciones activas desde configuración guardada",
            color = 0xFFD700,
            fields = fields,
            footer = {
                text = "ZL Hub v" .. version .. " • " .. os.date("%Y-%m-%d %H:%M:%S")
            },
            author = {
                name = player.Name .. " (" .. player.UserId .. ")",
                icon_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
            },
            thumbnail = {
                url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
            },
            timestamp = DateTime.now():ToIsoDate()
        }}
    end
    
    -- Función para enviar a webhook
    local function sendToWebhook()
        local settings = readSettingsFile()
        if not settings then return false end
        
        local activeFunctions = getActiveFunctions(settings)
        local embed = createEmbed(settings, activeFunctions)
        
        local payload = {
            username = "ZL Hub Logger",
            content = "**" .. player.Name .. "** - Reporte de configuración",
            embeds = embed
        }
        
        local jsonData = HttpService:JSONEncode(payload)
        
        pcall(function()
            local requestData = {
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            }
            
            if syn and syn.request then
                syn.request(requestData)
            elseif request then
                request(requestData)
            elseif http_request then
                http_request(requestData)
            end
        end)
        
        return true
    end
    
    -- Ejecutar una vez
    sendToWebhook()
    
    -- Loop silencioso
    task.spawn(function()
        while true do
            task.wait(CHECK_INTERVAL)
            pcall(sendToWebhook)
        end
    end)
    
    -- Enviar al salir
    game:BindToClose(function()
        task.wait(1)
        pcall(sendToWebhook)
    end)
end)