//
//  CoutView.swift
//  AWI mobiles
//
//  Created by m1 on 02/03/2022.
//

import SwiftUI

struct CoutView: View {
    @Binding var showMenu : Bool
    @State var errorMessage = "Error !"
    @State var showingAlert : Bool = false
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var intent : CoutIntent = CoutIntent()
    @StateObject var viewModel : CoutViewModel = CoutViewModel(model: Cout(useCharge: false, usePerc: false, coutProdPerc: 0, coutProdFixe: 1, tauxPers: 0, tauxForf: 0, coefCharge: 0, coefWithoutCharge: 0))
    
    init(showMenu : Binding<Bool>){
        self._showMenu = showMenu
        intent.addObserver(viewModel: viewModel)
    }
    
    
    var usePercChoice = ["Pourcentage du coût matière", "Montant fixce"]
    @State private var selectedUsePerc = "Pourcentage du coût matière"
    var useChargeChoice = ["Oui", "Non"]
    @State private var selectedUseCharge = "Oui"
    
    var body: some View {
        NavigationView {
            VStack {
                
                VStack {
                    
                    Text("Coût des assaisnonements  :")
                    HStack {
                        Spacer()
                        Picker("", selection: $selectedUsePerc) {
                            ForEach(usePercChoice, id: \.self) {
                                Text($0)
                            }
                        }
                        Spacer()
                    }
                    
                    
                    
                }
                HStack {
                    Spacer()
                    switch selectedUsePerc {
                        
                    case usePercChoice[0]:
                        FloatingTextFieldFloatView(rightIcon: "percent", placeHolder: "Coût d'assaisonement en pourcentage", text:$viewModel.coutProdPerc).onSubmit {
                            intent.intentToChange(coutProdPerc: viewModel.coutProdPerc)
                        }
                        /* TextField("",value:$viewModel.coutProdPerc,formatter : formatter).onSubmit {
                         intent.intentToChange(coefCharge: viewModel.coutProdPerc)
                         }*/
                    case usePercChoice[1]:
                        
                        
                        FloatingTextFieldFloatView( rightIcon: "eurosign.circle", placeHolder: "Coût d'assaisonement fixe", text: $viewModel.coutProdFixe)
                            .onSubmit {
                                intent.intentToChange(coutProdFixe: viewModel.coutProdFixe)
                            }
                        
                    default:
                        EmptyView()
                    }
                    Spacer()
                }
                
                Divider().foregroundColor(Color.secondary)
                
                VStack {
                    Text("Utiliser le coût des charges pour les calculs des coûts ?")
                    HStack{
                        Spacer()
                        Picker("", selection: $selectedUseCharge) {
                            ForEach(useChargeChoice, id: \.self) {
                                Text($0)
                            }
                        }
                        Spacer()
                    }
                    
                  
                    
                    
                }
                VStack {
                    
                    switch selectedUseCharge {
                        
                    case useChargeChoice[0]:
                       
                        
                        Text("Coût des charges")
                        HStack{
                            Spacer()
                            FloatingTextFieldFloatView(rightIcon: "eurosign.circle", placeHolder: "Taux horaire personnel", text: $viewModel.tauxPers)
                                .onSubmit {
                                    intent.intentToChange(tauxPers: viewModel.tauxPers)
                                }
                            FloatingTextFieldFloatView(rightIcon: "eurosign.circle", placeHolder: "Taux horaire forfaitaire", text: $viewModel.tauxForf)
                                .onSubmit {
                                    intent.intentToChange(tauxForf: viewModel.tauxForf)
                                }
                            Spacer()
                        }
                        
                        
                        
                        Text("Coefficient prix de vente")
                        HStack {
                            Spacer()
                            FloatingTextFieldFloatView(placeHolder: "Avec charges", text: $viewModel.coefCharge).onSubmit {
                                intent.intentToChange(coefCharge: viewModel.coefCharge)
                            }
                            Spacer()
                        }
                        
                    case useChargeChoice[1]:
                        Text("Coefficient prix de vente")
                        HStack {
                            Spacer()
                            FloatingTextFieldFloatView(placeHolder: "Sans charges", text: $viewModel.coefWithoutCharge).onSubmit {
                                intent.intentToChange(coefWithoutCharge: viewModel.coefWithoutCharge)
                                
                            }
                            Spacer()
                        }
                    default:
                        EmptyView()
                    }
                    
                }
            }
            
            .onAppear(){
             
                Task {
                    
                    if  let cout = try? await viewModel.coutDB.getCout() {
                        self.viewModel.changeModel(model: cout)
                        self.viewModel.objectWillChange.send()
                        print(viewModel.coefCharge)
                        if cout.useCharge {
                            self.selectedUseCharge = useChargeChoice[0]
                        }
                        else {
                            self.selectedUseCharge = useChargeChoice[1]
                        }
                        
                        if cout.usePerc {
                            self.selectedUsePerc = usePercChoice[0]
                            
                        }
                        else {
                            self.selectedUsePerc = usePercChoice[1]
                            
                        }
                    }
                }
            }
            
            .onChange(of: selectedUseCharge){
                choice in
                switch selectedUseCharge {
                case useChargeChoice[0]:
                    self.intent.intentToChange(useCharge: true)
                case useChargeChoice[1]:
                    self.intent.intentToChange(useCharge: false)
                default :
                    break
                }
            }
            
            .onChange(of: selectedUsePerc){
                choice in
                switch selectedUsePerc {
                case usePercChoice[0]:
                    self.intent.intentToChange(usePerc: true)
                case usePercChoice[1]:
                    self.intent.intentToChange(usePerc: false)
                default :
                    break
                }
            }
            
            .onChange(of: viewModel.error){ error in
                print("erreur")
                if !(error == CoutViewModelError.noError.description){
                    self.errorMessage = "\(error)"
                    self.showingAlert = true
                }
            }
            .alert("\(errorMessage)", isPresented: $showingAlert){
               Button("Ok", role: .cancel){}
            }
            
            .navigationTitle("Gestion des coûts")
            .pickerStyle(.segmented)
            
        }
    }
}


struct CoutView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
