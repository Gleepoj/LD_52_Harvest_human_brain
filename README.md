# About

Gamebase_ECS is a basic transcription of *[gameBase](https://github.com/deepnight/gameBase)* by *[deepnight](https://github.com/deepnight)* for Heaps.io in an Entity Component System paradigm , based on *[echo](https://github.com/deepcake/echo)* ECS framework by *[deepcake](https://github.com/deepcake)* .

If you're not familiar with Haxe and Heaps.io see install instructions *[here](https://deepnight.net/tutorial)*


# Install gameBase_ECS

 1. Install required libs by running the following command **in the root of the repo**: `haxe setup.hxml`

# Features 
 
 1. gameBase_ECS feature most of *[gameBase](https://github.com/deepnight/gameBase)* functionality like physics system , sprite rendering, 	  squash and stretch, LDtk binding, console stats etc.
 2. Nasty NPCs and Bomb Flower(named "Choux peteur" in the source).
 3. An embryo of particules system which is quite confuse and poorly customizable for the moment.
 4. A prototype of a  *[YarnSpinner](https://yarnspinner.dev/docs/writing/yarn-editor/)* based dialog system using *[hxyarn](https://github.com/cxsquared/hxyarn)* by *[cxsquared](https://github.com/cxsquared)*
 5. There is no camera system for the moment.
 6. Scene is load in aleiiioa.Aleiiioa.hx which extends Game class, all ECS logic is store in aleiiioa file (sorry for the name space its a   name of an abandoned game and I am too lazy to rename it properly :) )
 7. More about ECS *[here](https://cowboyprogramming.com/2007/01/05/evolve-your-heirachy/)*

# Compile

From the command line, run either:

 - For **DirectX**: `haxe hl.dx.hxml`
 - For **OpenGL**: `haxe hl.sdl.hxml`
 - For **Javascript/WebGL**: `haxe js.hxml`

The `hl.debug.hxml` is just a shortcut to one of the previous ones, with added `-debug` flag.

Run the result with either:

 - For **DirectX/OpenGL**: `hl bin\client.hl`
 - For **Javascript**: `start run_js.html`

# Issues

 - If you have issues with compiling maybe it come from the fact that you had to use my fork of deepcake/echo and cxsquared/hxyarn 
   and setup.hxml have not work as intended. Normally my fork of deepnightLibs and Heaps.io aren't necessary.

 - I actually use Hashlink nightly build and Haxe 4.2.5.

 - There is a compiled version for Windows in redist/opengl that should work. 

 - This code is not intended to be use as is for game developpement, I made it for my own purpose as a "self"-taught developer,
   and I share it more as bunch of snippet for curious people than as a polished tools. Fell free to tell me if you have any suggestions or if you find weirds things, bugs,bad practices,or a pretext for medieval-like theoretical controversy about software architecture :) . 



Latest release notes: [View changelog](CHANGELOG.md).