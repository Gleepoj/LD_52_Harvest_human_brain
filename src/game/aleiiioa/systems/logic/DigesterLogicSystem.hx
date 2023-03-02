package aleiiioa.systems.logic;

import echoes.View;
import aleiiioa.components.core.rendering.DebugLabel;
import aleiiioa.components.logic.ContainerComponent;
import aleiiioa.components.logic.ContainerSharedComponent;
import aleiiioa.components.logic.DigesterSharedComponent;
import aleiiioa.components.tools.DigesterFSM;
import aleiiioa.components.core.rendering.BoundingBox;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.position.GridPosition;
import aleiiioa.components.logic.DoorComponent;

typedef ContainersStatus = {left:Array<Container_State>,right:Array<Container_State>}; 
typedef Points = {pts:Int,status:ContainersStatus};

class DigesterLogicSystem extends echoes.System {
    var ALL_CONTAINERS:View<ContainerSharedComponent,DigesterFSM>;
    var container_list = new Map();
    var point_map = new Map();
    
    public function new(){
        var a:ContainersStatus = {left: [Gilles,Gilles,Gilles], right:[John,John,John]};
        var b:ContainersStatus = {left: [Gilles,John,Gilles], right:[Gilles,John,Gilles]};
        var c:ContainersStatus = {left: [Gilles,Gilles,Gilles], right:[Gilles,Gilles,Gilles]};
        var d:ContainersStatus = {left: [John,John,John], right:[John,John,John]};

        point_map.set(1,{pts: 100, status : a});
        point_map.set(2,{pts: 100, status : b});
        point_map.set(3,{pts: 150, status : c});
        point_map.set(4,{pts: 150, status : d});

    }

    @u function getContainerContent() {
        var head = ALL_CONTAINERS.entities.head;
        container_list.clear();
        var i = 0;
        while (head != null) {
            var cont = head.value.get(ContainerSharedComponent);
            container_list.set(i,cont.containers);
            head = head.next;
            i++;
        }
/* 
        var actual:ContainersStatus = {left:container_list.get(0),right:container_list.get(1)};

        for(v in point_map){
            compare(v,actual);
        } */
    }
    function compare(v:Points,actual:ContainersStatus){
        if(v.status == actual)
            trace(v.pts);
    }

    @u function updateDoors(door:DoorComponent,dsc:DigesterSharedComponent,cl:CollisionsListener,csc:ContainerSharedComponent,bb:BoundingBox) {
        if(cl.onContactDoor){
            dsc.feed = true;
        }
        
        if(dsc.digesterState == Free && !dsc.feed)
            dsc.bellyState = Empty;

        if(cl.onSwallowGille){
            dsc.bellyState = Gilles;
        }

        if(cl.onSwallowJohn){
            dsc.bellyState = John;
        }
        

        if(dsc.digesterState == Free && !door.isOpen && !csc.isFull){
            door.openDoor();
        }

        if(dsc.digesterState != Free && door.isOpen)
            door.closeDoor();
        
        if(door.isOpen && csc.isFull)
            door.closeDoor();
    }


    @u function synchronizeState(dt:Float,digest:DigesterFSM,dsc:DigesterSharedComponent,csc:ContainerSharedComponent,dl:DebugLabel) {
        digest.cd.update(dt);
        dsc.digesterState = digest.currentState;
        //dl.v = digest.currentState;
        dl.v = container_list.toString();

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