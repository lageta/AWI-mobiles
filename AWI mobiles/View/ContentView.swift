//
//  ContentView.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var showMenu : Bool = false
    
    @State var selectedView: SelectedView = .cout
    
    
    
    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        
        return NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    
                    
                    switch self.selectedView {
                    case .ingredient :
                        IngredientsView(showMenu: self.$showMenu)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                            .disabled(self.showMenu ? true : false)
                    case .cout :
                        CoutView(showMenu : self.$showMenu)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                            .disabled(self.showMenu ? true : false)
                    case .ficheTechnique :
                        FicheTechniqueListView(showMenu : self.$showMenu)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                            .disabled(self.showMenu ? true : false)
                    }
                    
                    
                    
                    if self.showMenu {
                        MenuView(selectedView : self.$selectedView)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                        
                    }
                }
                .gesture(drag)
            }
            .navigationBarTitle("Projet IOs", displayMode: .inline)
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.showMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
            ))
        }
    }
}

/*struct MainView : View{
 @Binding var showMenu: Bool
 var body: some View{
 
 IngredientsView()
 }
 }*/

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
