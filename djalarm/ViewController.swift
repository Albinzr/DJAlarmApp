//
//  ViewController.swift
//  djalarm
//
//  Created by Namai Satoshi on 2016/02/28.
//  Copyright © 2016年 ainame. All rights reserved.
//

import UIKit
import MediaPlayer

final class ViewController: UIViewController, MPMediaPickerControllerDelegate {
    let playerController = MPMusicPlayerController.applicationMusicPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTapPickButton(sender: UIButton) {
        let pickerController = MPMediaPickerController()
        pickerController.delegate = self
        pickerController.allowsPickingMultipleItems = true
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func onTapPlayButton(sender: UIButton) {
        playerController.play()
    }
    
    @IBAction func onTapPauseButton(sender: UIButton) {
        playerController.pause()
    }
    
    @IBAction func onTapStopButton(sender: UIButton) {
        playerController.stop()
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        playerController.setQueueWithItemCollection(mediaItemCollection)
        playerController.play()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

