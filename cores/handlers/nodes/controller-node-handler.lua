
ControllerNodeHandlersController = newclass(BaseNodeHandlerController,function(base,...)
    BaseNodeHandler.init(base,...)
    base.Type = SE.Constants.NodeTypes.Controller
  end)

    -- @See BaseNode.NewNode
    function ControllerNodeHandlersController.NewNode(entity)
        -- Prevent player interaction with the Controller GUI
        entity.operable = false

        return ControllerNodeHandlersController.EnsureStructure(ControllerNodeHandlersController._super.NewNode(entity))
    end

    -- @See BaseNode:EnsureStructure
    function ControllerNodeHandlersController:EnsureStructure()
        ControllerNodeHandlersController._super.EnsureStructure(self)
        return self
    end
