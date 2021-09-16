
ControllerNodeHandlersConstructor = newclass(BaseNodeHandlerConstructor,function(base,...)
    BaseNodeHandler.init(base,...)
    base.Type = RSE.Constants.NodeTypes.Controller
  end)

    -- @See BaseNode.NewNode
    function ControllerNodeHandlersConstructor.NewNode(entity)
        -- Prevent player interaction with the Controller GUI
        entity.operable = false

        return ControllerNodeHandlersConstructor.EnsureStructure(ControllerNodeHandlersConstructor._super.NewNode(entity))
    end

    -- @See BaseNode:EnsureStructure
    function ControllerNodeHandlersConstructor:EnsureStructure()
        ControllerNodeHandlersConstructor._super.EnsureStructure(self)
        -- Name of the handler that implements functionality
        self.HandlerName = ControllerNodeHandlers.HandlerName
        return self
    end
