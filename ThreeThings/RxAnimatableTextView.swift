//
//  RxAnimatableTextView.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/2/12.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Foundation
import IBAnimatable
import RxSwift
import RxCocoa

extension Reactive where Base: AnimatableTextView {
    
    var placeholderText: UIBindingObserver<Base, String?> {
        return UIBindingObserver(UIElement: self.base) { textView, placeholderText in
            textView.placeholderText = placeholderText
        }
    }
    
}
