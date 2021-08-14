//
//  AlbumDetail.swift
//  AlbumDetail
//
//  Created by Lee Jaeho on 2021/08/13.
//

import SwiftUI
import IrregularGradient
import MusicKit
import AlertToast
import SwimplyPlayIndicator

@available(iOS 15.0, *)
struct AlbumDetail: View {
    let screenSize = UIScreen.main.bounds
    
    var album : Album
    @EnvironmentObject var musicQueue : ApplicationMusicPlayer.Queue
    @State private var tracks :  MusicItemCollection<Track>? = nil
    @State private var onLoad : Bool = true
    var albumColors : [Color]{
        [Color(cgColor: album.artwork?.backgroundColor ?? .init(red: 0, green: 0, blue: 0, alpha: 0)),Color(cgColor: album.artwork?.primaryTextColor ?? .init(red: 0, green: 0, blue: 0, alpha: 0))]
    }
    
    var albumInfo : some View{
        VStack(spacing:-30){
            ZStack(alignment:.center){
                IrregularGradient(colors: albumColors, backgroundColor: .clear, speed: 2).frame(width:200,height:200).blur(radius: 16)
                AsyncImage(url: album.artwork?.url(width: 800, height: 800), content: {img in
                    img.resizable().aspectRatio(contentMode: .fill)
                }, placeholder: {
                    Rectangle().foregroundColor(.secondary)
                }).frame(width:200,height:200).clipShape(RoundedRectangle(cornerRadius: 10))
            }.frame(width:300,height:300)
            VStack(alignment:.center,spacing:5){
                Text(album.title).font(.title2).bold()
                Text(album.artistName).font(.caption).foregroundColor(.secondary)
                Spacer(minLength: 0)
                HStack(alignment:.center,spacing:30){
                    Button(action:{
                        if let tracks = tracks{
                            let queue = ApplicationMusicPlayer.Queue(for: tracks, startingAt: tracks.first)
                            ApplicationMusicPlayer.shared.queue = queue
                            Task{
                                try await ApplicationMusicPlayer.shared.play()
                            }
                        }
                    }){
                        Label("재생", systemImage: "play.fill").frame(width:100,height:25)
                    }.buttonStyle(.bordered)
                    Button(action:{
                        if let track = tracks?.randomElement(){
                            let queue = ApplicationMusicPlayer.Queue(arrayLiteral: track)
                            ApplicationMusicPlayer.shared.queue = queue
                            Task{
                                try await ApplicationMusicPlayer.shared.play()
                            }
                        }
                    }){
                        Label("임의 재생", systemImage: "shuffle").frame(width:100,height:25)
                    }.buttonStyle(.bordered)
                }
            }.frame(width:300,height:105)
        }
    }
    
    var songList : some View{
        List{
            if let tracks = tracks{
                ForEach(tracks){ track in
                    Button(action:{
                        let queue = ApplicationMusicPlayer.Queue(arrayLiteral: track)
                        ApplicationMusicPlayer.shared.queue = queue
                        Task{
                            try await ApplicationMusicPlayer.shared.play()
                        }
                    }){
                        HStack(alignment:.bottom){
                            if track.playParameters == musicQueue.currentEntry?.item?.playParameters{
                                SwimplyPlayIndicator(state: .constant(.play), count: 4, color: .red, style: .modern).frame(width:20,height:20)
                            }
                            Text(track.title).font(.callout)
                        }
                    }.frame(height:40)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button(action:{}){
                                Label("download", systemImage: "arrow.down")
                            }.tint(.blue)
                        })
                        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                            Button(action:{
                                Task{
                                    try await ApplicationMusicPlayer.shared.queue.insert(track, position: .tail)
                                }
                            }){
                                Label("Add PlayList", systemImage: "list.dash")
                            }.tint(.purple)
                        })
                }
            }
        }.listStyle(.plain).frame(height:CGFloat(55*(tracks?.count ?? 0)))
    }
    
    var body: some View {
        ScrollView{
            albumInfo
            songList
            Rectangle().foregroundColor(.clear).frame(height:80)
        }.toolbar(content: {
            ToolbarItemGroup(placement:.navigationBarTrailing){
                Button(action:{}){
                    Image(systemName: "arrow.down").resizable().aspectRatio(contentMode: .fit).frame(width:10,height: 10).foregroundColor(.red)
                }.buttonStyle(.bordered).clipShape(Circle())
            }
        })
            .onAppear{
                Task{
                    let detailedAlbum = try await album.with([.tracks])
                    self.tracks = detailedAlbum.tracks
                    onLoad = false
                }
            }
            .toast(isPresenting: $onLoad, alert: {
                AlertToast(displayMode: .alert, type: .loading)
            })
            .navigationTitle(Text(album.title))
            .navigationBarTitleDisplayMode(.inline)
            
    }
}

