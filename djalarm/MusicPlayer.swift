//
//  MusicPlayer.swift
//  djalarm
//
//  Created by Namai Satoshi on 2016/02/28.
//  Copyright © 2016年 ainame. All rights reserved.
//

import Foundation
import MediaPlayer

final class MusicPlayer {
    let controller = MPMusicPlayerController.applicationMusicPlayer()
    var queue = MusicQueue()
    
    required init() {
    }
    
    func play() {
    }
}

final class MusicQueue {

}