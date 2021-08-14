//
//  ContentView.swift
//  SliderMusic
//
//  Created by Lee Jaeho on 2021/08/12.
//

import SwiftUI
import MusicKit

@available(iOS 15.0, *)
struct ContentView: View {
    var body: some View {
        ZStack(alignment:.bottomTrailing){
            MusicSearchView()
            PlayingBar()
        }.ignoresSafeArea(.keyboard)
    }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
.environmentObject(SystemViewModel())
.environmentObject(ApplicationMusicPlayer.shared.state)
.environmentObject(ApplicationMusicPlayer.shared.queue)
    }
}
