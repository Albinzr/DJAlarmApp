//
//  MusicPlayerView.swift
//  djalarm
//
//  Created by Namai Satoshi on 2016/02/29.
//  Copyright © 2016年 ainame. All rights reserved.
//

import UIKit

@IBDesignable final class MusicPlayerView: UIView {
    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var time: UILabel!
    
    var playerState: MusicPlayer.PlayerState? {
        willSet {
            title.text = newValue?.title
            album.text = newValue?.album
            artist.text = newValue?.artist
            artwork.image = newValue?.artwork
            time.text = "\(newValue?.time ?? 0)"
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(MusicPlayerView.self), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first
        if let view = view as? UIView {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            let bindings = ["view": view]
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
                options:NSLayoutFormatOptions(rawValue: 0),
                metrics:nil,
                views: bindings))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
                options:NSLayoutFormatOptions(rawValue: 0),
                metrics:nil,
                views: bindings))
        }
    }
}
