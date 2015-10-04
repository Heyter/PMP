function AttachOrbs( event )
    local hero = event.caster
    local origin = hero:GetAbsOrigin()
    hero:StartGesture(ACT_DOTA_CONSTANT_LAYER)
    
    local particleName = "particles/custom/blood_elf/exort_orb.vpcf"

    local orb1 = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, hero)
    ParticleManager:SetParticleControlEnt(orb1, 1, hero, PATTACH_POINT_FOLLOW, "attach_orb1", origin, false)

    local orb2 = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, hero)
    ParticleManager:SetParticleControlEnt(orb2, 1, hero, PATTACH_POINT_FOLLOW, "attach_orb2", origin, false)

    local orb3 = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, hero)
    ParticleManager:SetParticleControlEnt(orb3, 1, hero, PATTACH_POINT_FOLLOW, "attach_orb3", origin, false)
end