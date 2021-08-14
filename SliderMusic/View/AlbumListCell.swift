//
//  AlbumListCell.swift
//  AlbumListCell
//
//  Created by Lee Jaeho on 2021/08/12.
//

import SwiftUI
import MusicKit

@available(iOS 15.0, *)
struct AlbumListCell: View {
    var album : Album
    var body: some View {
        NavigationLink(destination:AlbumDetail(album: album)){
            HStack(alignment:.center){
                AsyncImage(url: album.artwork?.url(width: 300, height: 300), content: {
                    img in
                    img.resizable().aspectRatio(contentMode: .fill)
                }, placeholder: {
                    Rectangle().foregroundColor(.secondary)
                }).frame(width:50,height:50).clipShape(RoundedRectangle(cornerRadius: 5))
                Text(album.title).font(.caption)
            }
        }
    }
}

@available(iOS 15.0, *)
struct SongListCell : View{
    var song : Song
    var body: some View {
        Button(action:{
            let queue = ApplicationMusicPlayer.Queue(arrayLiteral: song)
            ApplicationMusicPlayer.shared.queue = queue
            Task{
                try await ApplicationMusicPlayer.shared.play()
            }
        }){
            HStack(alignment:.center){
                AsyncImage(url: song.artwork?.url(width: 300, height: 300), content: {
                    img in
                    img.resizable().aspectRatio(contentMode: .fill)
                }, placeholder: {
                    Rectangle().foregroundColor(.secondary)
                }).frame(width:50,height:50).clipShape(RoundedRectangle(cornerRadius: 5))
                VStack(alignment:.leading){
                    Text(song.title).font(.caption)
                    if let artists = song.artists{
                        HStack{
                            ForEach(artists){ artist in
                                Text(artist.name).font(.caption2).foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
    }
}
