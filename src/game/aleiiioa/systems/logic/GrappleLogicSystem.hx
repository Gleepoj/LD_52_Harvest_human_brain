package aleiiioa.systems.logic;

import aleiiioa.components.core.InputComponent;
import aleiiioa.components.core.rendering.DebugLabel;
import aleiiioa.components.tools.GrappleFSM;

class GrappleLogicSystem extends echoes.System {
    public function new() {
        
    }

    @u function updateStateMachine(dt:Float,gr:GrappleFSM,input:InputComponent){
        gr.cd.update(dt);

        gr.inputA = input.ca.isDown(ActionY);

        if(gr.inputA)
             gr.next(Docked);

        if(input.ca.isDown(ActionX))
            gr.next(Recall);

        if(gr.registered_transition != null){
            if(!gr.cd.has("transition"))
                gr.cd.setS("transition",0.01);
            
        }
        
        //var new = gr.cd.onComplete("transition",()-> return gr.registered_transition.to);

    }
    
    @u function updateLabel(gr:GrappleFSM,label:DebugLabel){

        var state = gr.state;
        var trans = gr.registered_transition;
        var input = gr.inputA;
        var leg = gr.legal;
   
        label.v = '$state=>$trans=>$input, $leg';
    }
}