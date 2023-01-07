package aleiiioa.shaders;



import h3d.Vector;
import h3d.mat.Texture;

class StreamlineShader extends hxsl.Shader {
    static var SRC = {
		
        @:import h3d.shader.Base2d;
		@param var wind:Sampler2D;
        @param var rand_seed:Float;

        @param var rand_constants:Vec3;
        
        
		function fragment() {
            var uv = vec2(calculatedUV.xy);
            var color:Vec4 = wind.get(input.uv);
            //var pos:Vec2 = vec2(color.r / 255.0 + color.g,color.b / 255.0 + color.a);
            
            pixelColor = vec4(color);
        }
	}


    public function new(tex:Texture) {
		super();
		wind = tex;
        rand_seed = 0.223422;
      
        rand_constants = new Vector(12.9898, 78.233, 4375.85453,0);
	}
}

class StreamlineShader23 extends hxsl.Shader {
    static var SRC = {
		
        @:import h3d.shader.Base2d;
		@param var wind:Sampler2D;
        @param var rand_seed:Float;
        @param var speed:Float;
		@param var frequency:Float;
		@param var amplitude:Float;
		@param var NUM_OCTAVES:Int;

        @param var rand_constants:Vec3;
        

        
        function rand(co:Vec2):Float{
            return dot(rand_constants.xy, co);
        }
        function random(_st:Vec2):Float {
			return fract(sin(dot(_st.xy,vec2(12.9898,78.233)))*43758.5453123);
		}

		function fbm(_st:Vec2):Float {
			var v = 0.0;
			var a = 0.5;
			var shift = vec2(100.0);

			var rot = mat2(cos(0.5), sin(0.5),-sin(0.5), cos(0.50));

			for(i in 0...NUM_OCTAVES){
				v += a * noise(_st);
				_st = _st*rot * 2.0 + shift;
				a *= 0.5;
			}
			return v;

		}

		function noise(_st:Vec2):Float {
			var i = floor(_st);
			var f = fract(_st);

			var a = random(i);
			var b = random(i + vec2(1.0, 0.0));
			var c = random(i + vec2(0.0, 1.0));
			var d = random(i + vec2(1.0, 1.0));

			var u = f*f*(3.0-2.0*f);

			return mix(a, b, u.x) +
					(c - a)* u.y * (1.0 - u.x) +
					(d - b) * u.x * u.y;
		}
		
		function fragment() {
			//var st = calculatedUV;
			//var color = vec3(0.0);
            //var uv = vec2(calculatedUV.xy);
            var color:Vec4 = wind.get(input.uv);
            var st = vec2(color.xy);
            var l:Float = length(color.xy)/2;
			
			var q = vec2(0.);
			q.x = fbm(st);// + 0.00*time);
			q.y = fbm(st);// + vec2(1.0));
			
			var r = vec2(0.);
			r.x = fbm( st + 1.0*q + vec2(1.7,9.2)+ 0.15*time );
			r.y = fbm( st + 1.0*q + vec2(8.3,2.8)+ 0.126*time);

			var f = fbm(st-r);

			var final_color = mix(vec3(0.666667,1,1),
					vec3(0.666667,0.666667,0.498039),
					clamp((f*f)*4.0,0.0,1.0));
	
/* 			color = mix(color,
						vec3(0,0,0.164706),
						clamp(length(q),0.0,1.0)); */
		
			/* color = mix(color,
						vec3(0.666667,1,1),
						clamp(length(r.x),0.0,1.0)); */
		
			pixelColor = vec4((f*f*f+.6*f*f+.5*f)* final_color,1.);

		}


      
	}


    public function new(tex:Texture) {
		super();
		wind = tex;
        rand_seed = 0.223422;
        rand_constants = new Vector(12.9898, 78.233, 4375.85453,0);
        NUM_OCTAVES = 5;
	}
}


class StreamlineShader2 extends hxsl.Shader {
    static var SRC = {
		
        @:import h3d.shader.Base2d;
		@param var wind:Sampler2D;
        @param var rand_seed:Float;

        @param var dr_rate:Float;
        @param var dr_rate_bump:Float;

        @param var rand_constants:Vec3;
        
        
        function rand(co:Vec2):Float{
            var t:Float = dot(rand_constants.xy, co);
            return fract(sin(t)*(rand_constants.z + t));
        }
        
		function fragment() {
            var uv = vec2(calculatedUV.xy);
            var color:Vec4 = wind.get(input.uv);
            var pos:Vec2 = vec2(color.r / 255.0 + color.g,color.b / 255.0 + color.a);
            
            var wind_min:Vec2 = vec2(0.3,0.3);
            var wind_max:Vec2 = vec2(0.7,0.7);

            var velocity:Vec2 = mix(wind_min, wind_max, lookup_wind(pos));
            var speed_t:Float = length(velocity) / length(wind_max);

            var seed:Vec2 = (pos + uv.y) * rand_seed;    
            
            // drop rate is a chance a particle will restart at random position, to avoid degeneration
            var drop_rate:Float = dr_rate + speed_t * dr_rate_bump;
            var drop = step(1.0 - drop_rate, rand(seed));
            
            var random_pos:Vec2 = vec2(rand(seed + 1.3),rand(seed + 2.1));
            pos = mix(pos, random_pos, drop);
            var vel_color:Vec4 = vec4(speed_t,speed_t,speed_t,1);
            var final_color:Vec4 = vec4(fract(pos * 255.0),floor(pos * 255.0) / 255.0);

			pixelColor = vec4(vel_color);
		}

        function lookup_wind(uv:Vec2):Vec2 {
            
			var res = wind.size();
            
            var px:Vec2 = 1. / res ;
            var vc:Vec2 = (floor(uv *res)) * px;
            var f:Vec2  = fract(uv * res);
            var tl:Vec2 = wind.get(vc).rg;
            var tr:Vec2 = wind.get(vc + vec2(px.x, 0)).rg;
            var bl:Vec2 = wind.get(vc + vec2(0, px.y)).rg;
            var br:Vec2 = wind.get(vc + px).rg;
        
            return mix(mix(tl, tr, f.x), mix(bl, br, f.x), f.y);  
        }
	}


    public function new(tex:Texture) {
		super();
		wind = tex;
        rand_seed = 0.223422;
        dr_rate = 2.3;
        dr_rate_bump = 0.7;
        rand_constants = new Vector(12.9898, 78.233, 4375.85453,0);
	}
}

