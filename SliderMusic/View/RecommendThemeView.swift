//
//  RecommendThemeView.swift
//  RecommendThemeView
//
//  Created by Lee Jaeho on 2021/08/12.
//

import SwiftUI

@available(iOS 15.0, *)
struct RecommendThemeView: View {
    let screenSize = UIScreen.main.bounds
    var body: some View {
        ZStack{
            AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2021/07/23/14/52/submarine-6487509_960_720.png"), content: { img in
                img.resizable().aspectRatio(contentMode: .fill).clipped()
            }, placeholder: {
                Rectangle().foregroundColor(.gray)
            })
            
        }.frame(width: screenSize.width - 20,height: 280).clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

@available(iOS 15.0, *)
struct RecommendThemeView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendThemeView()
    }
}
