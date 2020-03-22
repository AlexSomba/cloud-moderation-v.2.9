function mod_hit(id, source, weapon, hpdmg, apdmg, rawdmg, object)
	if Player[id].var_god_toggle then
		return 1
	end

    if cloud.settings.modules.freeroam == true then
        if source ~= 0 then
            if freeroam[id].insafezone or freeroam[source].insafezone then
                return 1
            end
            -- victim, attacker cannot hurt eachother while protection is ON
            if freeroam[id].safe_protection == 1 or freeroam[source].safe_protection == 1 then
                return 1
            end
        end
    end

	if cloud.settings.modules.prison == true then
		if weapon == 78 then
			return 1
		end
	end
end
addhook("hit","mod_hit")
