-- bot.lua
local M = {}

-- Configurações do bot
local CONFIG = {
    hp_threshold = 0.3,
    mp_threshold = 0.2,
    attack_interval = 2,
    heal_interval = 10,
    habilidade_mp_cost = 50,
    max_potions_hp = 10,
    max_potions_mp = 10
}

-- Estado inicial do bot
local estado = {
    hp = 100,
    mp = 100,
    max_hp = 1000,
    max_mp = 1000,
    potions_hp = CONFIG.max_potions_hp,
    potions_mp = CONFIG.max_potions_mp,
    level = 1,
    last_attack_time = os.time(),
    last_heal_time = os.time(),
    last_use_skill_time = os.time()
}

local bot_running = false

-- Atualiza o nível e os recursos com base no nível
local function atualizar_nivel()
    estado.max_hp = 1000 + (estado.level - 1) * 15
    estado.max_mp = 1000 + (estado.level - 1) * 5
    estado.potions_hp = CONFIG.max_potions_hp + (estado.level - 1) * 25
    estado.potions_mp = CONFIG.max_potions_mp + (estado.level - 1) * 25
end

-- Atualiza o estado do bot
function M.atualizar_estado()
    local tempo_atual = os.time()
    if bot_running then
        atualizar_nivel()
        if estado.hp < estado.max_hp * CONFIG.hp_threshold and estado.potions_hp > 0 and tempo_atual - estado.last_heal_time >= CONFIG.heal_interval then
            estado.hp = estado.max_hp
            estado.potions_hp = estado.potions_hp - 1
            estado.last_heal_time = tempo_atual
        end

        if estado.mp > CONFIG.mp_threshold * estado.max_mp and tempo_atual - estado.last_use_skill_time >= 5 then
            estado.mp = estado.mp - CONFIG.habilidade_mp_cost
            estado.last_use_skill_time = tempo_atual
        end

        if tempo_atual - estado.last_attack_time >= CONFIG.attack_interval then
            estado.last_attack_time = tempo_atual
        end
    end
end

-- Salva o estado do bot
function M.salvar_estado()
    local file = love.filesystem.newFile("estado_bot.json", "w")
    file:write(json.encode(estado))
    file:close()
    print("Estado salvo.")
end

-- Carrega o estado do bot
function M.carregar_estado()
    if love.filesystem.getInfo("estado_bot.json") then
        local file = love.filesystem.newFile("estado_bot.json", "r")
        local content = file:read()
        estado = json.decode(content)
        atualizar_nivel()
        file:close()
        print("Estado carregado.")
    else
        print("Nenhum estado salvo encontrado.")
    end
end

-- Função para acessar o estado
function M.get_estado()
    return estado
end

-- Função para definir o estado
function M.set_estado(novo_estado)
    estado = novo_estado
    atualizar_nivel()
end

return M

