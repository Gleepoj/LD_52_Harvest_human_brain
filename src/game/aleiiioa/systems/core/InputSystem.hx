package aleiiioa.systems.core;


import aleiiioa.components.logic.LauncherBodyComponent;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.velocity.VelocityAnalogSpeed;
import aleiiioa.components.core.InputComponent;


class InputSystem extends echoes.System {
	
    public function new() {
	}

	@u function updatePlayer(inp:InputComponent,vas:VelocityAnalogSpeed,cl:CollisionsListener,launcher:LauncherBodyComponent){		

		if(inp.ca.isDown(MoveRight)){
			launcher.direction = 1;	
		}
		if(inp.ca.isDown(MoveLeft)){
			launcher.direction =-1;
		}

	}
}