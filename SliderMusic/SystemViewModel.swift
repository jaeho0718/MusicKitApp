//
//  SystemViewModel.swift
//  SystemViewModel
//
//  Created by Lee Jaeho on 2021/08/13.
//

import Foundation
import MusicKit


@available(iOS 15.0, *)
class SystemViewModel : ObservableObject{
    var currensSong : ApplicationMusicPlayer.Queue.Entry?{
        ApplicationMusicPlayer.shared.queue.currentEntry
    }
    
}
