package aleiiioa.components.tools;

import dn.Cooldown;

typedef Transition = {from:Grapple_State,to:Array<Grapple_State>};
typedef Order = {from:Grapple_State,to:Grapple_State};

class GrappleFSM {
    
    
    var next_state:Grapple_State;
    public var state:Grapple_State;
    public var registered_transition:Null<Order>;
    var transitions:Array<Transition>;
    public var inputA:Bool = false;
    public var legal:String = "";
    public var cd:Cooldown;
    
    public function new(){
        cd = new Cooldown(Const.FIXED_UPDATE_FPS);
        next_state = Idle;
        state = Idle;
        transitions = [
            {from:Idle,  to : [Recall]},
            {from:Recall,to : [Idle,Docked]},
            {from:Docked,to : [Idle,Loaded]},
            {from:Loaded,to : [Idle]}  
        ];
        // sample transition = [[Idle,[Recall,Docked]],[Idle,[Recall,Docked]],[Idle,[Recall,Docked]]]

    }

    public function next(nState:Grapple_State){
        next_state = nState;
        legal = "";
        if(state == next_state){
            legal = "next = state";
            return;
        }


        if(state != next_state){
            var count:Int = 0 ;
            for(t in transitions){
                if(t.from == state){
                    for(dir in t.to){
                        if(next_state == dir){
                            count +=1;
                            legal = "Legal switch";
                            registered_transition = {from:state,to:next_state};
                        }
                    }
                }
            }

            if(count == 0 )
                legal ="Illegal switch";
        }

    }
    
}
/* 
public function request(new_state:GrappleFSM_State) {
        
    if(state != new_state){
        state = new_state;
        setTransition();
        previous_state = state;
    }

}

function setTransition(){

    if(previous_state == Idle){
        if(state == Recall)
            transition = Idle_to_Recall;
    }

    if(previous_state == Recall){
        if(state == Docked)
            transition = Recall_to_Docked;
        if(state == Idle)
            transition = Recall_to_Idle;
    }

    if(previous_state == Docked){
        if(state == Load)
            transition = Docked_to_Load;

    }
    
    if(previous_state == Load){
        if(state ==Loaded )
            transition = Load_to_Loaded;
        
        if(state == Launch )
            transition = Load_to_Launch;
    }

    if(previous_state == Loaded){
        if(state == Launch)
            transition = Loaded_to_Launch;
    }
    
    if(previous_state == Launch){
        if(state == Idle)
            transition = Launch_to_Idle;
        if(state == Recall)
            transition = Launch_to_Recall;
    }
} */