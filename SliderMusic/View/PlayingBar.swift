//
//  PlayingBar.swift
//  PlayingBar
//
//  Created by Lee Jaeho on 2021/08/13.
//

import SwiftUI
import MusicKit

@available(iOS 15.0, *)
struct PlayingBar: View {
    @EnvironmentObject var systemViewModel : SystemViewModel
    @EnvironmentObject var musicState : MusicPlayer.State
    @EnvironmentObject var musicQueue : ApplicationMusicPlayer.Queue
    @Namespace var transition
    @State private var show : Bool = false
    @State private var soundLevel : Double = 0.2
    @SceneStorage("minibarMode") private var minibarMode : Bool = false
    
    var bar : some View{
        HStack(spacing:15){
            AsyncImage(url: musicQueue.currentEntry?.artwork?.url(width: 100, height: 100), content: { img in
                img.resizable().aspectRatio(contentMode: .fill)
            }, placeholder: {
                Rectangle().foregroundColor(.secondary)
            }).frame(width:45,height:45).clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 5).matchedGeometryEffect(id: "albumImage", in: transition)
            Text(systemViewModel.currensSong?.title ?? "현재 재생중인 곡이 없습니다.").lineLimit(1).matchedGeometryEffect(id: "backward", in: transition,properties: .position)
            Spacer(minLength: 0)
            HStack(alignment:.center,spacing: 20){
                Button(action:{
                    if musicState.playbackStatus == .paused || musicState.playbackStatus == .stopped{
                        Task{
                            try await ApplicationMusicPlayer.shared.play()
                        }
                    }else{
                        ApplicationMusicPlayer.shared.stop()
                    }
                }){
                    Image(systemName: musicState.playbackStatus == .playing ? "pause.fill" : "play.fill")
                }.tint(.primary).matchedGeometryEffect(id: "play", in: transition,properties: .position)
                Button(action:{
                    Task{
                        try await ApplicationMusicPlayer.shared.skipToNextEntry()
                    }
                }){
                    Image(systemName: "forward.fill")
                }.tint(.primary).matchedGeometryEffect(id: "forward", in: transition,properties: .position)
            }
        }.frame(height:70).padding([.leading,.trailing]).background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 15)).padding([.leading,.trailing])
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)){
                    show.toggle()
                }
            }
            .matchedGeometryEffect(id: "background", in: transition,properties: .size)
    }
    
    var controllbar : some View{
        HStack(alignment:.center,spacing: 20){
            Button(action:{
                Task{
                    try await ApplicationMusicPlayer.shared.skipToPreviousEntry()
                }
            }){
                Image(systemName: "backward.fill")
            }.tint(.primary).matchedGeometryEffect(id: "backward", in: transition,properties: .position)
            Spacer()
            Button(action:{
                if musicState.playbackStatus == .paused || musicState.playbackStatus == .stopped{
                    Task{
                        try await ApplicationMusicPlayer.shared.play()
                    }
                }else{
                    ApplicationMusicPlayer.shared.stop()
                }
            }){
                Image(systemName: musicState.playbackStatus == .playing ? "pause.fill" : "play.fill")
            }.tint(.primary).matchedGeometryEffect(id: "play", in: transition,properties: .position)
            Spacer()
            Button(action:{
                Task{
                    try await ApplicationMusicPlayer.shared.skipToNextEntry()
                }
            }){
                Image(systemName: "forward.fill")
            }.tint(.primary)
                .matchedGeometryEffect(id: "forward", in: transition,properties: .position)
        }.frame(maxWidth:.infinity,maxHeight:70).padding([.leading,.trailing]).background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 15)).padding([.leading,.trailing])
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)){
                    show.toggle()
                }
            }.matchedGeometryEffect(id: "background", in: transition,properties: .size)
    }
    
    var minibar : some View{
        ZStack {
            AsyncImage(url: musicQueue.currentEntry?.artwork?.url(width: 100, height: 100), content: { img in
                img.resizable().aspectRatio(contentMode: .fill)
            }, placeholder: {
                Rectangle().foregroundColor(.secondary)
            })
        }.frame(width:60,height:60).clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 5).matchedGeometryEffect(id: "albumImage", in: transition).padding([.leading,.trailing])
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)){
                    show.toggle()
                }
            }
    }
    
    var body: some View {
        VStack{
            if show{
                PlayingDetailView(show: $show, transition: transition)
                controllbar
            }else{
                if minibarMode{
                    minibar.gesture(DragGesture().onChanged(onChanged).onEnded(onEnded))
                }else{
                    bar.gesture(DragGesture().onChanged(onChanged).onEnded(onEnded))
                }
            }
        }
    }
    
    private func onChanged(value : DragGesture.Value){
        
    }
    private func onEnded(value : DragGesture.Value){
        let Upratio = value.translation.height / UIScreen.main.bounds.height
        let Lightratio = value.translation.width / UIScreen.main.bounds.width
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)){
            if 1+Upratio < 0.9{
                show = true
            }else if 1-Lightratio < 0.9{
                minibarMode = true
            }else if 1 + Lightratio < 0.9{
                minibarMode = false
            }
        }
    }
}
@available(iOS 15.0, *)
struct PlayingBar_Previews: PreviewProvider {
    static var previews: some View {
        PlayingBar().environmentObject(SystemViewModel())
            .environmentObject(ApplicationMusicPlayer.shared.state)
            .environmentObject(ApplicationMusicPlayer.shared.queue)
    }
}
