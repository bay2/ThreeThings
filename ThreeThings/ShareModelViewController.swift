//
//  ShareModelViewController.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/2/27.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import IBAnimatable
import RxSwift
import RxCocoa

class ShareModelViewController: AnimatableModalViewController {
    
    @IBOutlet fileprivate weak var backBtn: UIButton!
    @IBOutlet fileprivate weak var shareBtn: UIButton!
    @IBOutlet fileprivate weak var homeBtn: UIButton!
    
    var tapBack: ControlEvent<Void> {
        return backBtn.rx.controlEvent(.touchUpInside)
    }
    
    var tapHome: ControlEvent<Void> {
        return homeBtn.rx.controlEvent(.touchUpInside)
    }
    
    var tapShare: ControlEvent<Void> {
        return shareBtn.rx.controlEvent(.touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
