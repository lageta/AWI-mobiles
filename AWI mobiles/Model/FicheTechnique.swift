//
//  FicheTechnique.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import Foundation

class FicheTechnique {
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
