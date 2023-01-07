package aleiiioa.shaders;

class SmokeShader extends hxsl.Shader {
		static var SRC = {
			@:import h3d.shader.Base2d;
			@param var texture:Sampler2D;
			@param var seed:Int;
			@param var ratio:Float;
			@param var speed:Float;
			@param var frequency:Float;
			@param var lifetime:Float;
			@param var decay:Float;
			

			function fragment() {
				var st = calculatedUV;
				var input:Vec4 = texture.get(input.uv);
				

				var colorA:Vec3 = vec3(0.8,0,0);
				var colorB:Vec3 = vec3(0.6,0,0);
				
				if(seed == 2){
					colorB = vec3(0.8,0.4,0.);
					colorA = vec3(1,0.6,0.);
				}

				if(seed == 3){
					colorA = vec3(0.4,0.,0.);
					colorB = vec3(0.2,0.,0.);
				}

				var eA = vec3(0.,0.,0.);
				var eB = vec3(0.,0.,0.);

				var color = vec3(0,0,0);
				
				colorA = mix(eA,colorA,ratio);
				colorB = mix(eB,colorB,ratio);

				color = mix(color,colorA,input.r);
				color = mix(color,colorB,input.b);

				pixelColor = vec4(color,(input.r+input.b)*ratio);
	
			}
			
		}
	
		public function new(tex:h3d.mat.Texture,se:Int,rat:Float) {
			super();
			texture = tex;
			seed = se;
			ratio = rat;
			lifetime = 1.;
			decay = 0.5;
		}
}

