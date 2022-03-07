//
//  FicheTechnique.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import Foundation

protocol FicheTechniqueObserver {
    func changed (intitule : String)
    func changed (responsable :String)
    func changed (nbCouvert : Int)
    func changed (progression : [Progression])
    func changed (categorie : String)
}

class Progression : Identifiable{
}

class Denree{
    var ingredient : Ingredient
    var quantite : Double
    
    init(ingredient : Ingredient, quantite : Double){
        self.ingredient = ingredient
        self.quantite = quantite
    }
}

class Etape : Progression{
    var titreEtape : String
    var description : String
    var temps : Int
    var denrees : [Denree]
    
    init(titreEtape : String, description : String, temps : Int, denrees : [Denree]){
        self.titreEtape = titreEtape
        self.description = description
        self.temps = temps
        self.denrees = denrees
    }
}

class FicheTechnique : Progression {
    
    var observer : FicheTechniqueObserver?
    
    var id : String
    var intitule : String
    var responsable : String
    var nbCouvert : Int
    var progression : [Progression]
    var categorie : String
    
    init(id:String,intitule:String,responsable:String,nbCouvert:Int,progression:[Progression],categorie:String){
        self.id = id
        self.intitule = intitule
        self.responsable = responsable
        self.nbCouvert = nbCouvert
        self.progression = progression
        self.categorie = categorie
        
    }
}
