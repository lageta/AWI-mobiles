//
//  FloatingTextFieldFloatView
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//
import Foundation
import SwiftUI


struct FloatingTextFieldIntegerView : View {
    var leftIcon : String? = nil
    var rightIcon : String? = nil
    var placeHolder : String? = nil
    
    @Binding var text : Int
    
    @State private var isEditing = false
    @State private var edges = EdgeInsets(top: 0, leading:45, bottom: 0, trailing: 0)
    
    
    private enum Field : Int, Hashable {
        case fieldName
    }
    
    @FocusState private var focusField : Field?
    
    var body: some View {
        ZStack(alignment : .leading) {
            HStack {
                if(leftIcon != nil){
                    Image(systemName: leftIcon ?? "person")
                        .foregroundColor(Color.secondary)
                }
                TextField("", value: $text, formatter: NumberFormatter()) { status in
                    DispatchQueue.main.async {
                        isEditing = status
                        if isEditing || text>=0 {
                            edges = EdgeInsets(top: 0, leading:15, bottom: 60, trailing: 0)
                        }
                        else {
                            edges = EdgeInsets(top: 0, leading:45, bottom: 0, trailing: 0)
                        }
                    }
                }
                .focused($focusField, equals: .fieldName)
                
                if(rightIcon != nil){
                    Image(systemName: rightIcon ?? "person")
                        .foregroundColor(Color.secondary)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary))
          
            Text(placeHolder ?? "")
                .background(Color(UIColor.systemBackground))
                .foregroundColor(Color.secondary)
                .padding(edges)
                .animation(Animation.easeInOut(duration: 0.4), value: edges)
                .onTapGesture {
                    self.focusField = .fieldName
                }
            
        }.onAppear(){
            edges = (text >= 0 ) ?  EdgeInsets(top: 0, leading:15, bottom: 60, trailing: 0) : EdgeInsets(top: 0, leading:45, bottom: 0, trailing: 0)
        }
    }
}

