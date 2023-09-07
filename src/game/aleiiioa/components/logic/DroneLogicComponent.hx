package aleiiioa.components.logic;

class DroneLogicComponent {
    public var charge:Float = 0.;
    
    var recallSpeed  :Float = 3.4;
    var expulseSpeed :Float = 3.4;
    var launchSpeed :Float = 2.3;
    
    var slowdown    :Float = 0.99;
    var chargeSpeed :Float = 0.08;
    var chargeMax:Float = 3.;
    
    //var droneBoost  :Float = 0.002;
    

    public function new (){
        #if debug        
           // UIBuilders.slider("Drone : launchSpeed", function()  return grapplePower, function(v) grapplePower = v, 2.,9.);  
            //UIBuilders.slider("Drone : reloadSpeed",    function()  return loadSpeed,     function(v) loadSpeed = v, 0.03,0.09);  
            //UIBuilders.slider("Drone : recallSpeed", function() return recallSpeed , function(v) recallSpeed = v, 2.2,5);
            //UIBuilders.slider("Drone : expulseOffset",function() return expulseSpeed, function(v) expulseSpeed = v, 1.8,5);  
            //UIBuilders.slider("Drone : BoostSpeed", function()  return droneBoost,    function(v) droneBoost   = v, 0.05,0.2); 
            //UIBuilders.slider("Drone : maxLoad",    function()  return droneMaxLoad,  function(v) droneMaxLoad = v, 1.,4.); 
            //UIBuilders.slider("Drone : slowdown",   function()  return slowdown,     function(v) slowdown     = v, 0.9,1); 
        #end
          
    }

    public function power(?factor:Float = 1.){
        if(charge <  chargeMax)
            charge += chargeSpeed * factor;
        limit();
    }

    public function slowdown(?factor:Float = 1.){
        if(charge >=  0)
            charge *= slowdown ;
        limit();
    }

    public function reset(){
        charge = 0;
    }

    function limit(){
        if(charge > chargeMax)
            charge = chargeMax;
        
        if(charge < 0.0001)
            charge = 0;
    }

}