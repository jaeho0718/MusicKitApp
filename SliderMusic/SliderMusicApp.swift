//
//  SliderMusicApp.swift
//  SliderMusic
//
//  Created by Lee Jaeho on 2021/08/12.
//

import SwiftUI
import MusicKit


@available(iOS 15.0, *)
@main
struct SliderMusicApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var systemViewmodel = SystemViewModel()
    @StateObject var musicState = ApplicationMusicPlayer.shared.state
    @StateObject var musicQueue = ApplicationMusicPlayer.shared.queue
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(systemViewmodel)
                .environmentObject(musicState).environmentObject(musicQueue)
        }.onChange(of: scenePhase, perform: { phase in
            if phase == .active{
                Task{
                   await MusicAuthorization.request()
                }
            }
        })
    }
}
