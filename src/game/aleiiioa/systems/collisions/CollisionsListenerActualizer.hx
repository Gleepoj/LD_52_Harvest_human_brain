package aleiiioa.systems.collisions;

import echoes.System;

import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.systems.collisions.CollisionEvent.InstancedCollisionEvent;

class CollisionsListenerActualizer extends System {
    var events:InstancedCollisionEvent;// pas neccessaire ?
    public function new() {
        events = new InstancedCollisionEvent();
    }

    @u function cooldownUpdate(dt:Float,cl:CollisionsListener) {
        cl.cd.update(dt);
    }
}