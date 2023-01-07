package aleiiioa.systems.particules;

import aleiiioa.components.core.velocity.VelocityAnalogSpeed;
import aleiiioa.components.particules.ParticulesComponent;
import hxease.Quart;
import hxease.*;

class ParticulesVelocitySystem extends echoes.System {
    public function new() {
    
    }

    @u function updateParticule(pc:ParticulesComponent,vas:VelocityAnalogSpeed) {
        var qe = Back.easeIn.calculate(pc.lifeRatio);
        
        if(pc.frict > 0){
            
            vas.xSpeed *= qe;
            vas.ySpeed *= qe;
            
        }

        if(pc.gravity >0){
            vas.ySpeed += 0.2;
        }
    }
}