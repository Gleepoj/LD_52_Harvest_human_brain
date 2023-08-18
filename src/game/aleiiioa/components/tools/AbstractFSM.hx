package aleiiioa.components.tools;

import dn.Cooldown;


private typedef Order      = {from:Int, to:Int};
private typedef Transition = {from:Int, to:Array<Int>};

class FSM {
    
    var legal:String = "";
    var state:Int;
    var states = new Map();
    //var allowed_states:Array<Astate>;
    var allowed_transitions:Array<Transition>;
    var registered_transition:Null<Order>;
    
    
    public var currentState(get,never):Int; inline function get_currentState() return state;    
    public var cd:Cooldown;

    public function new() {
        cd = new Cooldown(Const.FIXED_UPDATE_FPS);
    }

    inline public function init(init_state:Int,_allowed_transitions:Array<Transition>) {
        state = init_state;
        allowed_transitions = _allowed_transitions;
    }

    inline public function next(next_state:Int){
       
        if(currentState == next_state){
            return;
        }
        
        for(transition in allowed_transitions){
            if(transition.from == state){
                for(to in transition.to){
                    if(next_state == to){
                        registered_transition = {from:state,to:next_state};
                    }
                }
            }
        }
        switchToRegisteredTransition();
    }

    function switchToRegisteredTransition() {
        if(registered_transition != null){
            state = registered_transition.to;
            registered_transition = null;            
        }  
    }

    public function setTranstion(_from:Dynamic<>,_to:Dynamic<>) {
        var t:Transition = {from :_from,to:_to};
        allowed_transitions.push(t);
    }

} 

class BlurFsm extends FSM{
    public function new() {
        super();
        
        states.set(1,Idle);
        states.set(2,Recall);
        states.set(3,Docked);
        states.set(4,Loaded);
        states.set(5,Expulse);

        setTranstion(1,[2]);
        setTranstion(2,[3]);
        setTranstion(3,[4]);
        setTranstion(4,[5]);
        setTranstion(5,[2]);

    }
}

/* var legal:String = "";
    var state:Digester_State;
    var allowed_transitions:Array<Transition_Digest>;
    var registered_transition:Null<Order_Digest>;
    
    public var currentState(get,never):Digester_State; inline function get_currentState() return state;    
    public var cd:Cooldown;
    
    public function new(){
        
        cd = new Cooldown(Const.FIXED_UPDATE_FPS);
        state = Free;
        
        allowed_transitions = [
            {from:Free,   to : [Digest]},
            {from:Digest, to : [Accept,Reject]},
            {from:Accept, to : [Spit]},
            {from:Reject, to : [Spit]},
            {from:Spit,   to : [Free]}
        ];
        
    }
    
    public function next(next_state:Digester_State){
       
        if(currentState == next_state){
            return;
        }
        
        for(transition in allowed_transitions){
            if(transition.from == state){
                for(to in transition.to){
                    if(next_state == to){
                        registered_transition = {from:state,to:next_state};
                    }
                }
            }
        }
        switchToRegisteredTransition();
    }

    function switchToRegisteredTransition() {
        if(registered_transition != null){
            state = registered_transition.to;
            registered_transition = null;            
        }  
    }
    
    public function debugLabelUpdate(label:DebugLabel){
            label.v = "";
            var state = currentState;
            var trans = registered_transition;
            var leg   = legal;
            label.v = 'cur:$state t:$trans leg:$leg';
    } */