package aleiiioa.components.logic;

import aleiiioa.builders.UIBuilders;

class LauncherBodyComponent {
    public var xSpeed:Float = 0;
    public var angle:Float = 0 - Math.PI/4;
    public var velocity:Float = 0;
    public var acceleration:Float =0;
    public var damping:Float = 0.995;
    public var direction:Int = 0;

    public var maxSpeed:Float = 0.51; 

    public function new() {
      #if debug   
            UIBuilders.slider("maxSpeed",     function()  return maxSpeed,      function(v) maxSpeed = v, 0.3,0.9); 
      #end
    }
}