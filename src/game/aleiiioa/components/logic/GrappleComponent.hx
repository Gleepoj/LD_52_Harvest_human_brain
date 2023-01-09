package aleiiioa.components.logic;

class GrappleComponent {
    public var maxLoad:Float = 1.;
    public var load:Float = 0;
    public var state:GrappleState = Idle;
    public var home:Bool = true;
    public var bonus:Float = 0.;
    public function new() {
        
    }
}