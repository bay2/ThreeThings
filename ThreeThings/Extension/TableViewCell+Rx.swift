//
//  TableViewCell+Rx.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/8.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableViewCell {
    public var prepareForReuse: Observable<Void> {
        return Observable.of(sentMessage(#selector(UITableViewCell.prepareForReuse)).map { _ in }, deallocated).merge()
    }
    
    public var prepareForReuseBag: DisposeBag {
        return base._rx_prepareForReuseBag
    }
}

private struct AssociatedKeys {
    static var _disposeBag: Void = ()
}

extension UITableViewCell {
    
    fileprivate var _rx_prepareForReuseBag: DisposeBag {
        MainScheduler.ensureExecutingOnScheduler()
        
        if let bag = objc_getAssociatedObject(self, &AssociatedKeys._disposeBag) as? DisposeBag {
            return bag
        }
        
        let bag = DisposeBag()
        objc_setAssociatedObject(self, &AssociatedKeys._disposeBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        _ = rx.prepareForReuse
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                let newBag = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKeys._disposeBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            })
        
        return bag
    }
}
