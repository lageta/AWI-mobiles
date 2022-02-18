//
//  Ingredient.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import Foundation

class Ingredient : ObservableObject {
    public var id : String;
    public var CODE : Int;
    public var LIBELLE : String;
    public var CATEGORIE : String;
    public var PRIX_UNITAIRE : Float;
    public var UNITE : String;
    public var STOCK : Int;
    public var ALLERGENES : [String]

     init(code : Int, libelle: String, categorie: String, prix_unitaire : Float, unite : String, stock : Int,allergenes:[String],id: String){
        self.CODE = code;
        self.LIBELLE = libelle;
        self.CATEGORIE = categorie;
        self.PRIX_UNITAIRE = prix_unitaire;
        self.UNITE = unite;
        self.id = id
        self.STOCK = stock
        self.ALLERGENES = allergenes
    }
}
