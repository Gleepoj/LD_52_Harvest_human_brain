package aleiiioa.systems.core;


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

	@u function updatePlayer(inp:InputComponent,vas:VelocityAnalogSpeed,cl:CollisionsListener){
	
		if(inp.ca.isDown(MoveRight)){
			vas.xSpeed = (0.3 + energyOutput);
		}
		if(inp.ca.isDown(MoveLeft)){
			vas.xSpeed = -(0.3 +energyOutput);
		}
		if(inp.ca.isPressed(Jump) && cl.cd.has("recentlyOnGround")){
			//vas.ySpeed = -0.9;
			//cl.cd.unset("recentlyOnGround");
		}

		if(inp.ca.isDown(MoveUp)){
			//vas.ySpeed = -0.3;
		}
	}
}