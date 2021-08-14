//
//  PlayingDetailView.swift
//  PlayingDetailView
//
//  Created by Lee Jaeho on 2021/08/13.
//

import SwiftUI
import MusicKit
import Marquee

@available(iOS 15.0, *)
struct PlayingDetailView: View {
    @EnvironmentObject var musicState : MusicPlayer.State
    @EnvironmentObject var musicQueue : ApplicationMusicPlayer.Queue
    @Binding var show : Bool
    @State private var animation : Bool = false
    @State private var scale : CGFloat = 1.0
    var transition : Namespace.ID
    
    var largeAlbumInfo : some View{
        HStack(spacing:20){
            AsyncImage(url: musicQueue.currentEntry?.artwork?.url(width: 60, height: 60), content: { img in
                img.resizable().aspectRatio(contentMode: .fill)
            }, placeholder: {
                Rectangle().foregroundColor(.secondary)
            }).frame(width:60,height:60).clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 5).matchedGeometryEffect(id: "albumImage", in: transition,properties: [.position,.frame])
            VStack(alignment:.leading,spacing:5){
                Marquee{
                    Text(musicQueue.currentEntry?.title ?? "현재 재생중인 음악이 없습니다.").font(.title3).foregroundColor(.primary)
                }.marqueeDuration(20)
                    .marqueeWhenNotFit(true)
                    .frame(height:30)
                Text(musicQueue.currentEntry?.subtitle ?? "").lineLimit(1).font(.caption).foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
    }
    
    var menuBar : some View{
        HStack{
            Spacer()
            Button(action:{}){
                Image(systemName: "text.quote").resizable().aspectRatio(contentMode: .fit).frame(width:15,height:15)
                    .foregroundColor(.primary)
            }.buttonStyle(.bordered)
            Button(action:{}){
                Image(systemName: "list.dash").resizable().aspectRatio(contentMode: .fit).frame(width:15,height:15)
                    .foregroundColor(.primary)
            }.buttonStyle(.bordered)
        }
    }
    
    var playList : some View{
        VStack(alignment:.leading){
            HStack{
                Text("재생 목록").font(.caption2).foregroundColor(.secondary)
                Spacer()
            }
            ScrollView(.vertical){
                VStack{
                    ForEach(musicQueue.entries){ track in
                        Button(action:{
                            ApplicationMusicPlayer.shared.queue.currentEntry = track
                            Task{
                                try await ApplicationMusicPlayer.shared.play()
                            }
                        }){
                            HStack(alignment:.top){
                                AsyncImage(url: track.artwork?.url(width: 45, height: 45), content: {img in img.resizable().aspectRatio( contentMode: .fill)}, placeholder: {Rectangle().foregroundColor(.secondary)}).frame(width:45,height:45)
                                VStack(alignment:.leading,spacing:3){
                                    Text(track.title).font(.callout).foregroundColor(.primary)
                                    Text(track.subtitle ?? "").font(.caption2).foregroundColor(.secondary)
                                }
                                Spacer(minLength: 0)
                            }.frame(height:46)
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing:10){
            menuBar.padding(.top)
            playList
            largeAlbumInfo.padding(.bottom)
        }.frame(maxWidth:.infinity,minHeight:100,maxHeight:600).padding([.leading,.trailing])
            .background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 15)).padding([.leading,.trailing,.top])
            .scaleEffect(scale)
            .matchedGeometryEffect(id: "background", in: transition)
            .offset(y: animation ? 0 : 140)
            .onAppear{
                withAnimation(.spring()){
                    animation.toggle()
                }
            }.gesture(DragGesture().onChanged(onChanged).onEnded(onEnded))
    }
    
    private func onChanged(value : DragGesture.Value){
        let ratio = value.translation.height / UIScreen.main.bounds.height
        if 1-ratio > 1.1{
            withAnimation(.spring()){
                scale = 1
            }
        }else{
            scale = 1-ratio
        }
    }
    private func onEnded(value : DragGesture.Value){
        let ratio = value.translation.height / UIScreen.main.bounds.height
        if 1-ratio < 0.9{
            withAnimation(.spring()){
                show = false
            }
        }
        withAnimation(.spring()){
            scale = 1
        }
    }
}

@available(iOS 15.0, *)
struct PlayingDetailView_Previews: PreviewProvider {
    struct TestView: View {
            @Namespace var ns
            var body: some View {
                PlayingDetailView(show:.constant(true), transition: ns)
                    .environmentObject(ApplicationMusicPlayer.shared.state)
                    .environmentObject(ApplicationMusicPlayer.shared.queue)
            }
    }
    static var previews: some View {
        TestView()
    }
}
