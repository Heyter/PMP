function SpawnUnit( event )
    local caster = event.caster
    local owner = caster:GetOwner()
    local player = caster:GetPlayerOwner()
    local playerID = player:GetPlayerID()
    local hero = player:GetAssignedHero()
    local ability = event.ability
    local unit_name = event.UnitName
    local position = caster:GetAbsOrigin()
    local teamID = caster:GetTeam()

    local food_cost = GetFoodCost(unit_name)
    local numSpawns = GetSpawnRate(playerID)

    -- Don't spawn more than 1 leader
    if string.match(unit_name,"_leader") then
        numSpawns = 1
    end

    for i=1,numSpawns do

        if not PlayerHasEnoughFood(playerID, food_cost) then
            return
        else
            ModifyFoodUsed(playerID, food_cost)
        end

        local unit = CreateUnitByName(unit_name, position, true, owner, owner, caster:GetTeamNumber())
        unit:SetOwner(hero)
        unit:SetControllableByPlayer(playerID, true)
        FindClearSpaceForUnit(unit, position, true)

        table.insert(hero.units, unit)

        -- Add all current upgrades
        PMP:ApplyAllUpgrades(playerID, unit)

        -- Move to rally point
        Timers:CreateTimer(0.05, function() 
            unit:MoveToPosition(caster.rally_point)
        end)
    end

    ability:StartCooldown(ability:GetCooldown(1))
end

function SpawnSuperUnit( event )
    local caster = event.caster
    local owner = caster:GetOwner()
    local player = caster:GetPlayerOwner()
    local playerID = player:GetPlayerID()
    local hero = player:GetAssignedHero()
    local ability = event.ability
    local unit_name = event.UnitName
    local duration = event.Duration
    local position = caster:GetAbsOrigin()
    local teamID = caster:GetTeam()

    local charges = caster:GetModifierStackCount("modifier_super_unit_charges", caster)
    if charges and charges > 0 then
        local unit = CreateUnitByName(unit_name, position, true, owner, owner, caster:GetTeamNumber())
        unit:SetOwner(hero)
        unit:SetControllableByPlayer(playerID, true)
        FindClearSpaceForUnit(unit, position, true)

        unit:AddNewModifier(caster, nil, "modifier_kill", {duration=duration})
        
        charges = charges - 1
        caster:SetModifierStackCount("modifier_super_unit_charges", caster, charges)
        ability:SetLevel(charges)
        if charges == 0 then
            caster:RemoveModifierByName("modifier_super_unit_charges")
            local endAbility = TeachAbility(caster, "summon_super_peon_empty")
            caster:SwapAbilities("summon_super_peon", "summon_super_peon_empty", false, true)
        end
    end
end

function SuperPeonCharges( event )
    Timers:CreateTimer(0.1, function()
        local ability = event.ability
        local caster = event.caster
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_super_unit_charges", {})
        caster:SetModifierStackCount("modifier_super_unit_charges", caster, 3)
    end)
end