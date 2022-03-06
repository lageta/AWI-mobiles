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
    func changed (progression : [Any])
    func changed (categorie : String)
}

class FicheTechnique {
    
    var observer : FicheTechniqueObserver?
    
    var id : String
    var intitule : String
    var responsable : String
    var nbCouvert : Int
    var progression : [Any]
    var categorie : String
    
    init(id:String,intitule:String,responsable:String,nbCouvert:Int,progression:[Any],categorie:String){
        self.id = id
        self.intitule = intitule
        self.responsable = responsable
        self.nbCouvert = nbCouvert
        self.progression = progression
        self.categorie = categorie
        
    }
}
