package aleiiioa.systems.logic;

import aleiiioa.components.core.InputComponent;
import aleiiioa.components.core.rendering.DebugLabel;
import aleiiioa.components.tools.LauncherFSM;

class LauncherLogicSystem extends echoes.System {
    public function new() {
    }

    @u function inputStateMachine(dt:Float,launcher:LauncherFSM,input:InputComponent,label:DebugLabel){
        launcher.cd.update(dt);
        if(input.ca.isDown(ActionY)){
            launcher.next(Recall);
        }
        if(!input.ca.isDown(ActionY)){
            launcher.next(Idle);
        }

        if(input.ca.isPressed(ActionX)){
            if(launcher.currentState == Recall)
                launcher.next(Docked);

            if(launcher.currentState == Docked)
                launcher.next(Loaded);
        }

        launcher.switchToRegisteredTransition();
        launcher.debugLabelUpdate(label);
    }
    
}