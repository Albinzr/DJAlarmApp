//
//  MusicPlayer.swift
//  djalarm
//
//  Created by Namai Satoshi on 2016/02/28.
//  Copyright © 2016年 ainame. All rights reserved.
//

import Foundation
import RxSwift
import MediaPlayer

struct Track {
    var item: MPMediaItem
}

final class MusicPlayer {
    var queue = MusicQueue()
    var state: State
    
    private let controller = MPMusicPlayerController.applicationMusicPlayer()
    private let schedule = PublishSubject<Void>()
    private let sequencer: Observable<Track>
    private let bag = DisposeBag()
    
    required init() {
        state = State(player: controller)
        sequencer = Observable<Track>.zip(schedule, queue.observe()) { $1 }
        sequencer.subscribe { (event) -> Void in
            switch event {
            case .Next(let track):
                self.playTrack(track)
            case .Error(let error):
                print(error)
                break
            case .Completed:
                break
            }
        }.addDisposableTo(bag)
    }
    
    func sendNext() {
        schedule.onNext()
    }
    
    func playTrack(track: Track) {
        let collection = MPMediaItemCollection(items: [track.item])
        controller.setQueueWithItemCollection(collection)
        controller.play()
    }

    struct PlayerState {
        var artwork: UIImage?
        var title: String
        var time: NSTimeInterval
        var artist: String
        var album: String
        var currentPlaybackTime: NSTimeInterval
        var state: MPMusicPlaybackState
        var volume: Int
        var shuffule: Bool
        var `repeat`: Bool
        
        static func empty() -> PlayerState {
            return PlayerState(
                artwork: nil,
                title: "",
                time: 0,
                artist: "",
                album: "",
                currentPlaybackTime: 0,
                state: .Stopped,
                volume: 0,
                shuffule: false,
                `repeat`: false
            )
        }
    }
    
    final class State {
        enum PlayerEvent {
            case ChangeItem
            case ChangePlaybackState
        }
        
        let subject = PublishSubject<PlayerState>()
        private let playerEvent = PublishSubject<(PlayerEvent, MPMusicPlayerController?)>()
        private let bag = DisposeBag()
        private var currentState = PlayerState.empty()
        
        init(player: MPMusicPlayerController) {
            weak var weakPlayer = player
            let center = NSNotificationCenter.defaultCenter()
            center.addObserverForName(MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
                object: weakPlayer, queue: NSOperationQueue.mainQueue()) { notification in
                    self.playerEvent.onNext((.ChangeItem, notification.object as? MPMusicPlayerController))
            }
            
            center.addObserverForName(MPMusicPlayerControllerPlaybackStateDidChangeNotification,
                object: weakPlayer, queue: NSOperationQueue.mainQueue()) { notification in
                    self.playerEvent.onNext((.ChangePlaybackState, notification.object as? MPMusicPlayerController))
            }
            weakPlayer?.beginGeneratingPlaybackNotifications()
            playerEvent.doOnError { error in print("EERRRROORR \(error)") }
                .subscribeNext(publishState)
                .addDisposableTo(bag)
        }
        
        deinit {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        
        private func publishState(event: PlayerEvent, player: MPMusicPlayerController?) {
            guard let player = player, let item = player.nowPlayingItem else { return }
            let state = renewState(event, player: player, item: item)
            print(state)
            subject.onNext(state)
        }
        
        private func renewState (event: PlayerEvent, player: MPMusicPlayerController, item: MPMediaItem) -> PlayerState {
            var copy = currentState
            copy.artwork = item.artwork?.imageWithSize(item.artwork!.imageCropRect.size)
            copy.title = item.title ?? ""
            copy.album = item.albumTitle ?? ""
            copy.artist = item.artist ?? ""
            copy.time = item.playbackDuration
            copy.state = player.playbackState
            copy.currentPlaybackTime = player.currentPlaybackTime
            copy.state = player.playbackState
            currentState = copy
            return copy
        }
    }
    
    final class MusicQueue {
        let subject = PublishSubject<Track>()
        
        func append(track: Track) {
            subject.onNext(track)
        }
        
        func observe() -> Observable<Track> {
            return subject
        }
    }
}
