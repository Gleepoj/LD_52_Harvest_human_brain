package aleiiioa.systems.logic;

import aleiiioa.components.logic.ContainerComponent;
import aleiiioa.components.logic.ContainerSharedComponent;
import aleiiioa.components.logic.DigesterSharedComponent;
import aleiiioa.components.tools.DigesterFSM;
import aleiiioa.components.core.rendering.BoundingBox;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.position.GridPosition;
import aleiiioa.components.logic.DoorComponent;

class DigesterLogicSystem extends echoes.System {

    public function new(){

    }

    @u function updateDoors(door:DoorComponent,dsc:DigesterSharedComponent,cl:CollisionsListener,csc:ContainerSharedComponent,bb:BoundingBox) {
        if(cl.onContactDoor){
            dsc.feed = true;
        }

        if(cl.onSwallowGille){
            dsc.bellyState = Gilles;
        }

        if(cl.onSwallowJohn){
            dsc.bellyState = John;
        }

        if(dsc.digesterState == Free && !door.isOpen && !csc.isFull){
            door.openDoor();
            dsc.bellyState = Empty;
        }

        if(dsc.digesterState != Free && door.isOpen)
            door.closeDoor();
        
        if(!door.isOpen && csc.isFull)
            door.closeDoor();
    }


    @u function synchronizeState(dt:Float,digest:DigesterFSM,dsc:DigesterSharedComponent,csc:ContainerSharedComponent) {
        digest.cd.update(dt);
        dsc.digesterState = digest.currentState;

        if(dsc.feed && digest.currentState == Free ){
            digest.cd.setS("digest",0.03);//0.03 perfect for init value
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

        if(digest.currentState == Spit && !digest.cd.has("spit")){
            csc.fillContainer(dsc.bellyState);
            digest.next(Free);
        }
        if(digest.currentState == Free)
            dsc.feed = false;
        
    }

    @u function updateContainers(cc:ContainerComponent,csc:ContainerSharedComponent){
        var val = csc.containers.get(cc.id);
        cc.state = val;
    }
}