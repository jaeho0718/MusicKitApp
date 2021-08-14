//
//  HeartButton.swift
//  HeartButton
//
//  Created by Lee Jaeho on 2021/08/13.
//

import SwiftUI

struct HeartButton: View {
    @State private var heart : Bool = false
    var body: some View {
        Toggle("", isOn: $heart).toggleStyle(HeartToggleStyle())
    }
}

struct HeartButton_Previews: PreviewProvider {
    static var previews: some View {
        HeartButton()
    }
}

struct HeartToggleStyle : ToggleStyle{
    func makeBody(configuration: Configuration) -> some View {
        ZStack{
            Image(systemName: configuration.isOn ? "suit.heart.fill" : "suit.heart")
                .foregroundColor(configuration.isOn ? .red : .secondary)
        }.onTapGesture {
            withAnimation(.spring()){
                configuration.isOn.toggle()
            }
        }
    }
}
