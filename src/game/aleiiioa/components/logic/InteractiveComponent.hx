package aleiiioa.components.logic;

import dn.Cooldown;

class InteractiveComponent {
    public var isGrabbed:Bool = false;
    public var cd:Cooldown;
    public function new() {
        cd = new Cooldown(Const.FIXED_UPDATE_FPS);
    }
}