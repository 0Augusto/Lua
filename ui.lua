-- ui.lua
local M = {}

-- Dimensões dos botões
local button_width, button_height = 150, 50
local button_padding = 10

-- Função para desenhar um botão
local function drawButton(button, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", button.x, button.y, button_width, button_height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(button.label, button.x, button.y + (button_height / 4), button_width, "center")
end

-- Função para verificar se um ponto está dentro de um retângulo
local function isPointInRect(px, py, rect)
    return px >= rect.x and px <= rect.x + button_width and py >= rect.y and py <= rect.y + button_height
end

-- Inicialização da interface gráfica
function M.init()
    M.buttons = {
        start = {x = button_padding, y = button_padding, label = "Iniciar Bot"},
        stop = {x = button_padding, y = button_padding + button_height + button_padding, label = "Parar Bot"},
        save = {x = button_padding, y = button_padding + 2 * (button_height + button_padding), label = "Salvar Estado"},
        load = {x = button_padding, y = button_padding + 3 * (button_height + button_padding), label = "Carregar Estado"}
    }
    M.button_colors = {
        default = {0.8, 0.8, 0.8},
        hover = {0.9, 0.9, 0.9},
        active = {0.7, 0.7, 0.7}
    }
    M.current_button = nil
end

-- Atualiza a cor do botão conforme o mouse está sobre ele
function M.mousemoved(x, y)
    M.current_button = nil
    for key, button in pairs(M.buttons) do
        if isPointInRect(x, y, button) then
            M.current_button = key
            break
        end
    end
end

-- Desenha a interface gráfica
function M.draw()
    love.graphics.setColor(1, 1, 1)
    local estado = bot.get_estado()
    love.graphics.print("Bot Interface", 10, 10)
    love.graphics.print("Nível: " .. estado.level, 10, 40)
    love.graphics.print("HP: " .. estado.hp .. " / " .. estado.max_hp, 10, 70)
    love.graphics.print("MP: " .. estado.mp .. " / " .. estado.max_mp, 10, 100)
    love.graphics.print("Poções HP: " .. estado.potions_hp, 10, 130)
    love.graphics.print("Poções MP: " .. estado.potions_mp, 10, 160)
    
    local status = bot_running and "Bot está rodando" or "Bot parado"
    love.graphics.print(status, 10, 190)
    
    -- Desenha os botões com cores dinâmicas
    for key, button in pairs(M.buttons) do
        local color = M.button_colors.default
        if key == M.current_button then
            color = M.button_colors.hover
        end
        drawButton(button, color)
    end
end

-- Função para lidar com cliques do mouse
function M.mousepressed(x, y, button)
    if button == 1 then
        for key, btn in pairs(M.buttons) do
            if isPointInRect(x, y, btn) then
                return key
            end
        end
    end
end

return M

