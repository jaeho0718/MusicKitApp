//
//  MusicSearchView.swift
//  MusicSearchView
//
//  Created by Lee Jaeho on 2021/08/12.
//

import SwiftUI
import MusicKit
import AlertToast

@available(iOS 15.0, *)
struct MusicSearchView: View {
    @State private var searchText : String = ""
    @State private var searchResult : MusicCatalogSearchResponse? = nil
    @State private var onLoad = false
    var body: some View {
        NavigationView{
            List{
                if let result = searchResult{
                    ForEach(result.albums){ album in
                        AlbumListCell(album: album)
                    }
                    ForEach(result.songs){ song in
                        SongListCell(song: song)
                    }
                }
            }.listStyle(.plain).navigationTitle(Text("검색"))
        }.searchable(text: $searchText)
        .onSubmit(of: .search, {
            onLoad = true
            let reqeust = MusicCatalogSearchRequest(term: searchText, types: [])
            Task{
                self.searchResult = try? await reqeust.response()
                onLoad = false
            }
        })
        .toast(isPresenting: $onLoad, alert: {
            AlertToast(displayMode: .alert, type: .loading)
        })
    }
}


@available(iOS 15.0, *)
struct MusicSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MusicSearchView()
    }
}
