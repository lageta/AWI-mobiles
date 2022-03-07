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
    
    @State private var selectedIngredient = Ingredient(libelle:"Veuillez sélectionner un ingrédient")
    @State private var isAdding : Bool
    @State private var disableEdit : Bool = true
    
    init(ficheTechnique : FicheTechnique, listViewModel : FicheTechniqueListViewModel, isAdding : Bool){
        self.listViewModel = listViewModel
        self.ficheTechnique = ficheTechnique
        self.isAdding = isAdding
        self.viewModel = FicheTechniqueDetailViewModel(model: ficheTechnique)
        intent.addObserver(viewModel : self.viewModel, listViewModel : self.listViewModel)
    }
    
    
    private var steps = ["Informations générales", "Etapes", "Coûts"]
    @State private var selectedStep = "Informations générales"
    
    @State private var newTitre : String = ""
    @State private var newDescription : String = ""
    @State private var newTemps : Int = 0
    @State private var newIngredients : [Ingredient] = []
    @State private var newIngredientsQte : [Double] = []
    @State private var qte : Double = 0
    @State var popoverCreate = false
    @State var showingIngredients = false
    @State var deleteAlert = false
    
    func addEtape(){
        var denrees : [Denree] = []
        for i in 0..<newIngredients.count{
            denrees.append(Denree(ingredient: newIngredients[i], quantite: newIngredientsQte[i]))
        }
        ficheTechnique.progression.append(Etape(titreEtape: newTitre, description: newDescription, temps: newTemps, denrees: denrees))
        newTitre = ""
        newDescription = ""
        newTemps = 0
        newIngredients = []
        intent.intentToChange(progression: ficheTechnique.progression)
    }
    
    var body: some View {
        if(isAdding == false){
            Button(action :{
                self.deleteAlert = true
            }){
                Text("Supprimer la fiche technique")
            }
            .alert("Voulez vous supprimer cette fiche technique ?", isPresented: $deleteAlert){
                Button("Oui"){
                    self.viewModel.deleteFicheTechnique(ficheTechnique: ficheTechnique)
                }
                Button("Annuler", role: .cancel){}
            }
        }
        
        
        Picker("Choisissez votre étape", selection: $selectedStep) {
            ForEach(steps, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.segmented)
        
        
        if(selectedStep == "Informations générales"){
            VStack{
                HStack{
                    FloatingTextFieldView( placeHolder: "Intitule", text:$ficheTechnique.intitule)
                        .onSubmit {
                            intent.intentToChange(intitule: ficheTechnique.intitule)
                            intent.intentToUpdateList()
                        }
                        .disabled(!isAdding && disableEdit)
                    
                    FloatingTextFieldIntegerView( placeHolder: "Nombre de couverts", text: $ficheTechnique.nbCouvert)
                        .onSubmit {
                            intent.intentToChange(nbCouvert: ficheTechnique.nbCouvert)
                            intent.intentToUpdateList()
                        }
                        .disabled(!isAdding && disableEdit)
                }
                HStack{
                    FloatingTextFieldView( placeHolder: "Responsable", text: $ficheTechnique.responsable)
                        .onSubmit {
                            intent.intentToChange(responsable: ficheTechnique.responsable)
                            intent.intentToUpdateList()
                        }
                        .disabled(!isAdding && disableEdit)
                    FloatingTextFieldView( placeHolder: "Catégorie", text: $ficheTechnique.categorie)
                        .onSubmit {
                            intent.intentToChange(categorie: ficheTechnique.categorie)
                            intent.intentToUpdateList()
                        }
                        .disabled(!isAdding && disableEdit)
                }
            }
        }
        else if(selectedStep == "Etapes"){
            List{
                
                ForEach(0..<$ficheTechnique.progression.count){ index in
                    if (ficheTechnique.progression[index] is Etape){
                        if let etape = ficheTechnique.progression[index] as? Etape{
                            NavigationLink(destination: EtapeDetailsView(denrees : etape.denrees)){
                                VStack{
                                    Text("\(index + 1) - \(etape.titreEtape) - \(etape.temps) mins ")
                                    Text(etape.description)
                                }
                            }
                            
                        }
                    }else{
                        if let ft = ficheTechnique.progression[index] as? FicheTechnique{
                           NavigationLink(destination: FicheTechniqueDetailView(ficheTechnique: ft, listViewModel: listViewModel, isAdding: false)){
                               HStack{
                                   Text("Fiche Technique : \(ft.intitule)")
                               }
                               
                               
                            }
                            
                        }
                    }
                    
                    
                }
                
                .onDelete(){
                    indexSet in
                    ficheTechnique.progression.remove(atOffsets: indexSet)
                    intent.intentToChange(progression: ficheTechnique.progression)
                }
                
            }
            
            
            .environment(\.editMode, .constant(self.disableEdit ? EditMode.inactive : EditMode.active))
            
            
            if( isAdding || !disableEdit){
                Button(action: {
                    self.popoverCreate = true
                }){
                    Text("Ajouter une étape")
                }
                .popover(isPresented: $popoverCreate){
                    GeometryReader { (geometry) in
                        VStack {
                            
                            FloatingTextFieldView(placeHolder: "Titre étape", text: $newTitre)
                            FloatingTextFieldView(placeHolder: "Description", text: $newDescription)
                            FloatingTextFieldIntegerView(placeHolder: "Temps", text: $newTemps)
                            Divider()
                            HStack{
                                Text("Ingrédient : ")
                                Picker(selection: $selectedIngredient, label: Text("Selectionner un ingrédient")) {
                                    ForEach(viewModel.ingredients, id: \.id) { ingredient in
                                        Text("\(ingredient.LIBELLE)").tag(ingredient)
                                    }
                                }.id(UUID())
                            }
                            FloatingTextFieldFloatView(placeHolder: "Quantité", text: $qte)
                            Button(action : {
                                print(selectedIngredient.LIBELLE)
                                newIngredients.insert(selectedIngredient, at: newIngredients.count)
                                newIngredientsQte.insert(qte, at: newIngredientsQte.count)
                                qte = 0
                                selectedIngredient = Ingredient()
                            }){
                                Text("Ajouter l'ingrédient")
                            }
                            Divider()
                            Button(action: {
                                self.showingIngredients = true
                            }) {
                                Text("Ingredients ajoutés")
                            }
                            
                            Spacer()
                            
                            
                            
                            .popover(isPresented: $showingIngredients) {
                                List{
                                    ForEach(0..<newIngredients.count){i in
                                        Text("\(newIngredients[i].LIBELLE) : \(newIngredientsQte[i]) ")
                                        
                                    }
                                }
                            }
                        }.frame(width: (geometry.size.width), height: geometry.size.height)
                    }
                    
                    Button(action: {
                        self.popoverCreate = false
                        self.addEtape()
                        
                        
                    }) {
                        Text("Ajouter l'étape")
                    }
                }
                .onAppear{
                    Task{
                        await viewModel.getIngredients()
                        await viewModel.getCout()
                    }
                    
                }
            }
            
            
            
            
        }
        else{
            VStack{
                if(viewModel.cout.useCharge){
                    Text("Cout avec charge : \( (viewModel.cout.tauxForf + viewModel.cout.tauxPers) / 60 * 40 )")
                }
                HStack{
                    
                }
                HStack{
                    Text("0.00")
                }
                HStack{
                    Text("1.00")
                }
            }
        }
        Spacer()
        if(self.isAdding == true){
            Button(action:{
                
                viewModel.createFicheTechnique(ficheTechnique: ficheTechnique)
            }){
                Text("Créer")
            }
        }else{
            Button(action:{
                disableEdit = !disableEdit
            }){
                if(disableEdit){
                    Text("Modifier")
                }else{
                    Text("Arrêter la modification")
                }
                
            }
        }
        
        
    }
    
}

struct FicheTechniqueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
