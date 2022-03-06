//
//  FicheTechniqueDetailView.swift
//  AWI mobiles
//
//  Created by m1 on 04/03/2022.
//

import SwiftUI

struct FicheTechniqueDetailView: View {
    @State var ficheTechnique : FicheTechnique
    
    var intent : FicheTechniqueIntent = FicheTechniqueIntent()
    var viewModel : FicheTechniqueDetailViewModel
    var listViewModel : FicheTechniqueListViewModel
    
    @State private var selectedIngredient = Ingredient()
    
    init(ficheTechnique : FicheTechnique, listViewModel : FicheTechniqueListViewModel){
        self.listViewModel = listViewModel
        self.ficheTechnique = ficheTechnique
        self.viewModel = FicheTechniqueDetailViewModel(model: ficheTechnique)
        intent.addObserver(viewModel : self.viewModel, listViewModel : self.listViewModel)
    }
    
    	
    private var steps = ["Informations générales", "Etapes"]
    @State private var selectedStep = "Informations générales"
    
    @State private var newTitre : String = ""
    @State private var newDescription : String = ""
    @State private var newTemps : Int = 0
    @State private var newIngredients : [Ingredient] = []
    @State private var newIngredientsQte : [Int] = []
    @State private var qte = 0
    @State var popoverCreate = false
    @State var showingIngredients = false
    
    var body: some View {
        Picker("Choisissez votre étape", selection: $selectedStep) {
            ForEach(steps, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.segmented)
        
       
        if(selectedStep == "Informations générales"){
            VStack{
                HStack{
                    FloatingTextFieldView( placeHolder: "Intitule", text: $ficheTechnique.intitule)
                        .onSubmit {
                            intent.intentToChange(intitule: ficheTechnique.intitule)
                            intent.intentToUpdateList()
                        }
                    FloatingTextFieldIntegerView( placeHolder: "Nombre de couverts", text: $ficheTechnique.nbCouvert)
                        .onSubmit {
                            intent.intentToChange(nbCouvert: ficheTechnique.nbCouvert)
                            intent.intentToUpdateList()
                        }
                    
                }
                HStack{
                    FloatingTextFieldView( placeHolder: "Responsable", text: $ficheTechnique.responsable)
                        .onSubmit {
                            intent.intentToChange(responsable: ficheTechnique.responsable)
                            intent.intentToUpdateList()
                        }
                    FloatingTextFieldView( placeHolder: "Catégorie", text: $ficheTechnique.categorie)
                        .onSubmit {
                            intent.intentToChange(intitule: ficheTechnique.categorie)
                            intent.intentToUpdateList()
                        }
                }
            }
        }
        else if(selectedStep == "Etapes"){
            Button(action: {
                self.popoverCreate = true
            }){
                Text("Ajouter une étape")
            }.popover(isPresented: $popoverCreate){
                GeometryReader { (geometry) in
                    VStack {
                        
                        FloatingTextFieldView(placeHolder: "Titre étape", text: $newTitre)
                        FloatingTextFieldView(placeHolder: "Description", text: $newDescription)
                        FloatingTextFieldIntegerView(placeHolder: "Temps", text: $newTemps)
                        Picker(selection: $selectedIngredient, label: Text("Selectionner un ingrédient")) {
                            ForEach(viewModel.ingredients, id: \.id) { ingredient in
                                Text("\(ingredient.LIBELLE)").tag(ingredient)
                            }
                        }.id(UUID())
                            
                    }.frame(width: (geometry.size.width), height: geometry.size.height)
                }
                FloatingTextFieldIntegerView(placeHolder: "Quantité", text: $qte)
                Button(action: {
                    self.showingIngredients = true
                  }) {
                    Text("Ingredients ajoutés")
                  }.popover(isPresented: $showingIngredients) {
                      List{
                          ForEach(newIngredients, id: \.id){
                              ingredient in
                                Text(ingredient.LIBELLE)

                          }
                      }
                    
                  }
                Button(action : {
                    print(selectedIngredient.LIBELLE)
                    newIngredients.insert(selectedIngredient, at: newIngredients.count)
                    newIngredientsQte.insert(qte, at: newIngredientsQte.count)
                    qte = 0
                    selectedIngredient = Ingredient()
                }){
                    Text("test")
                }
            }
            .onAppear{
                Task{
                    await viewModel.getIngredients()
                }
                
            }
            
            
        }
        Spacer()
        
    }
}

struct FicheTechniqueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
