package aleiiioa.components.tools;

class GrappleFSM {
    
    
    previous_state:GrappleFSM_State = Idle ;
    state:GrappleFSM_State = Idle;
    transition:GrappleFSM_Transition = Empty_Transition;
    cd:Cooldown;
    
    public function new(){
        
    }

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
    }
}