//
//  ViewController.swift
//  djalarm
//
//  Created by Namai Satoshi on 2016/02/28.
//  Copyright © 2016年 ainame. All rights reserved.
//

import UIKit
import MediaPlayer
import RxSwift
import RxCocoa

final class ViewController: UIViewController, MPMediaPickerControllerDelegate {
    @IBOutlet weak var musicPlayerView: MusicPlayerView!
    let musicPlayer = MusicPlayer()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        musicPlayer.state.subject
            .observeOn(MainScheduler.instance)
            .subscribe { event in
                switch event {
                case .Next(let state):
                    self.musicPlayerView.playerState = state
                case .Error(let error):
                    print("error!!!")
                    print(error)
                case .Completed:
                    break
                }
        }.addDisposableTo(bag)
        musicPlayerView.pickerButton.rx_tap
            .observeOn(MainScheduler.instance)
            .subscribeNext(onTapPickButton).addDisposableTo(bag)
        musicPlayerView.playButton.rx_tap
            .observeOn(MainScheduler.instance)
            .subscribeNext(onTapPlayButton).addDisposableTo(bag)
        musicPlayerView.pauseButton.rx_tap
            .observeOn(MainScheduler.instance)
            .subscribeNext(onTapPauseButton).addDisposableTo(bag)
        musicPlayerView.stopButton.rx_tap
            .observeOn(MainScheduler.instance)
            .subscribeNext(onTapStopButton).addDisposableTo(bag)
    }
    
    func onTapPickButton() {
        let pickerController = MPMediaPickerController()
        pickerController.delegate = self
        pickerController.allowsPickingMultipleItems = true
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func onTapPlayButton() {
        musicPlayer.sendNext()
    }
    
    func onTapPauseButton() {
        print("pause")
    }
    
    func onTapStopButton() {
        print("stop")
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        let tracks = mediaItemCollection.items.map { Track(item: $0) }
        tracks.forEach { musicPlayer.queue.append($0) }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

