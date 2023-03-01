package aleiiioa.components.logic;

class ContainerComponent {
    
    public var state:Container_State = Empty;
    public var suggestion: Int = 0; //-1 john 0 neutre 1 gilles
    public var id:Int;
   
    public function new(_id:Int) {
        id = _id;
    }

    public function fillContainer(couleur_bonhomme:Int) {
        if(couleur_bonhomme == -1)
            state = John;

        if(couleur_bonhomme == 1)
            state = Gilles;
    }

    public function emptyContainer(){
        state = Empty;
    }
}