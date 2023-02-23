package aleiiioa.systems.core;


import aleiiioa.components.tools.LauncherFSM;
import aleiiioa.components.logic.MethanizerComponent;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.velocity.VelocityAnalogSpeed;
import aleiiioa.components.core.velocity.VelocityComponent;
import hxd.Pad.PadConfig;
import aleiiioa.components.core.InputComponent;

import aleiiioa.components.core.position.GridPositionOffset;



class InputSystem extends echoes.System {
	var energyOutput:Float =0.;
    public function new() {
	}
	@u function getEnergyOutput(met:MethanizerComponent){
		energyOutput = met.energyOutput/8;
	}

	@u function updatePlayer(inp:InputComponent,vas:VelocityAnalogSpeed,cl:CollisionsListener,launcher:LauncherFSM){		
		var dir = launcher.direction;

		if(inp.ca.isDown(MoveRight)){
			launcher.direction = 1;	
		}
		if(inp.ca.isDown(MoveLeft)){
			launcher.direction =-1;
		}

	}
}