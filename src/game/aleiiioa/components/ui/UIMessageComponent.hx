package aleiiioa.components.ui;

import h2d.Text;
import dn.heaps.FlowBg;

class UIMessageComponent {
    public var flow:h2d.Flow;
    public var bubble:FlowBg;
    public var text:Text;
    public var message:String;
   
    public function new(m:String) {
        message = m;
    }
}