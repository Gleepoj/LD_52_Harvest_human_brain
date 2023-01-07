package aleiiioa.components.dialog;

import dn.heaps.FlowBg;
import h2d.Layers;

class UIOption{
    
    public var layer:h2d.Layers; 
    public var flow:h2d.Flow;
    public var bubbles:Array<FlowBg>;
        
    public function new() {
        layer = new h2d.Layers();
        Game.ME.root.add(layer,Const.DP_UI);
		layer.name = "Option Layer";
        bubbles = new Array<FlowBg>();
    }
}
