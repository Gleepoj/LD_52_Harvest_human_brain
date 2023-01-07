package aleiiioa;

import echoes.Entity;
import aleiiioa.systems.logic.EntityLogicSystem;
import aleiiioa.systems.logic.InteractivesSystem;
import aleiiioa.builders.*;
import aleiiioa.components.core.position.GridPosition;

import aleiiioa.systems.ui.*;
import aleiiioa.systems.core.*;
import aleiiioa.systems.particules.*;
import aleiiioa.systems.renderer.*;
import aleiiioa.systems.collisions.*;
import aleiiioa.systems.dialog.*;

import echoes.Workflow;

class Aleiiioa extends Game {
	var game(get,never) : Game; inline function get_game() return Game.ME;
	
	var cameraFocus:Entity;
	var cameraFocusPosition:GridPosition;

	public function new() {
		super();
		Workflow.reset();
		
		var cameraPoint = level.data.l_Entities.all_CameraPoint[0];
		cameraFocus = EntityBuilders.cameraFocus(cameraPoint.cx,cameraPoint.cy);
		cameraFocusPosition = cameraFocus.get(GridPosition);

		Game.ME.camera.trackEntityGridPosition(cameraFocusPosition,true,1);
		Game.ME.camera.centerOnGridTarget();		
		Game.ME.camera.clampToLevelBounds = false;
		
		
		// ECS //
		var player = level.data.l_Entities.all_Player[0];
		EntityBuilders.player(player.cx,player.cy);

		for (e in level.data.l_Entities.all_PNJ){
			EntityBuilders.pnj(e.cx,e.cy,e.f_Dialog);
		}

		for (cp in level.data.l_Entities.all_ChouxPeteur){
			EntityBuilders.chouxPeteur(cp.cx,cp.cy);
		}
		
		//Collision
		Workflow.addSystem(new GarbageCollectionSystem());
		Workflow.addSystem(new CollisionsListenerActualizer());
		Workflow.addSystem(new EntityCollisionsSystem());
		
		//Object
		Workflow.addSystem(new LevelCollisionsSystem());
		Workflow.addSystem(new VelocitySystem());
		Workflow.addSystem(new DynamicPhysicSystem());
		Workflow.addSystem(new GridPositionActualizer());

		//Interaction
		Workflow.add60FpsSystem(new InteractivesSystem());
		Workflow.add60FpsSystem(new EntityLogicSystem());
		
		//Particles
		Workflow.addSystem(new ParticulesVelocitySystem());
		Workflow.add60FpsSystem(new ParticulesSystem());
		Workflow.add60FpsSystem(new ParticuleRenderer());
		
		//Graphics
		Workflow.add60FpsSystem(new SquashRenderer());
		Workflow.add60FpsSystem(new SpriteExtensionFx());
		Workflow.add60FpsSystem(new SpriteRenderer(Game.ME.scroller,Game.ME));
		Workflow.add60FpsSystem(new BoundingBoxRenderer(Game.ME.scroller));
		
		//Dialog
		Workflow.add60FpsSystem(new DialogYarnSystem());
		Workflow.add60FpsSystem(new DialogInputSystem());
		Workflow.add60FpsSystem(new DialogUISystem());
		
		
		//Helpers
		Workflow.add60FpsSystem(new UIHelperSystem());
		//Input
		Workflow.add60FpsSystem(new InputSystem());


	}


	override function fixedUpdate() {
		super.fixedUpdate();
		Workflow.update(Const.FIXED_DELTA);
	}

	override function postUpdate() {
		super.postUpdate();
		Workflow.postUpdate(tmod);
	}


}
	

