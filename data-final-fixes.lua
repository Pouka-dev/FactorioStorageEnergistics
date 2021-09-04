
local isNormalMode = settings.startup["se-mod_difficulty"].value == "Normal"
if (not isNormalMode) then
    local ingredients = data.raw["technology"]["circuit-network"].unit.ingredients
    for i, ingredient in pairs(ingredients or {}) do
        if ingredient[1] == "logistic-science-pack" then
            table.remove(ingredients, i)
            break
        end
    end
end
