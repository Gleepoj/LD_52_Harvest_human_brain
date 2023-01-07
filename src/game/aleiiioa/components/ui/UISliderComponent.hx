package aleiiioa.components.ui;


class UISliderComponent {
    
    public var label:String;
    public var get:Void->Float;
    public var set:Float->Void;
    public var min:Float;
    public var max:Float;
    
    public function new(_label : String, _get : Void -> Float, _set : Float -> Void,_min : Float = 0., _max : Float = 1.) {
        label = _label;
        get = _get;
        set = _set;
        min = _min;
        max = _max;
    }
}