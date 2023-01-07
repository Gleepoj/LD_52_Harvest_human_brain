package aleiiioa.components.core;

import hxd.Pad.PadConfig;

class InputComponent {
    public var ca : ControllerAccess<GameAction>;
    public var conf:PadConfig;
    
    public function new() {
		ca = App.ME.controller.createAccess();
		ca.lockCondition = Game.isGameControllerLocked;
		conf = ca.input.pad.config;
    }
}