SEStoreConstructor = newclass(Object, function(base, ...)
    Object.init(base, ...)
    base.Nodes = nil
end)

    function SEStoreConstructor:OnInit()
        -- Nodes
        if (global.Nodes == nil) then
            global.Nodes = {}
        end
        SEStoreConstructor:OnLoad()
    end

    function SEStoreConstructor:OnLoad()
        if (global.Nodes == nil) then
            global.Nodes = {}
        end
        SEStoreConstructor.Nodes = global.Nodes
    end

