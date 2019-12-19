//
//  SwipeOverlay.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 07/12/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import Koloda

class SwipeOverlay: OverlayView {
    
    private let overlayLeftImageName = "overlaySkip"
    private let overlayRightImageName = "overlayLike"
    
    private let overlayImageView = UIImageView()
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
        }
    }
}
