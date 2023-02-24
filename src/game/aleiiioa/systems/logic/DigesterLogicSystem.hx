package aleiiioa.systems.logic;

import aleiiioa.components.logic.DigesterSharedComponent;
import aleiiioa.components.tools.DigesterFSM;
import aleiiioa.components.core.rendering.BoundingBox;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.position.GridPosition;
import aleiiioa.components.logic.DoorComponent;

class DigesterLogicSystem extends echoes.System {

    public function new(){

    }

    @u function updateDoors(door:DoorComponent,dsc:DigesterSharedComponent,gp:GridPosition,cl:CollisionsListener,bb:BoundingBox) {
        if(cl.onContactDoor){
            dsc.feed = true;
        }

        if(dsc.digesterState == Free && !door.isOpen)
            door.openDoor();

        if(dsc.digesterState != Free && door.isOpen)
            door.closeDoor();
        
    }

    @u function synchronizeState(dt:Float,digest:DigesterFSM,dsc:DigesterSharedComponent) {
        digest.cd.update(dt);
        dsc.digesterState = digest.currentState;

        if(dsc.feed && digest.currentState == Free ){
            digest.cd.setS("digest",0.06);//0.03 perfect for init value
        }

        if(digest.cd.has("digest") && digest.currentState != Digest)
            digest.next(Digest);

        if(!digest.cd.has("digest") && digest.currentState == Digest){
            digest.next(Accept);
            digest.cd.setS("toSpit",0.02);
        }

        if(digest.currentState == Accept && !digest.cd.has("toSpit")){
            digest.next(Spit);
            digest.cd.setS("spit",0.02);
        }

        if(digest.currentState == Spit && !digest.cd.has("spit"))
            digest.next(Free);

        if(digest.currentState == Free)
            dsc.feed = false;
        
    }
}