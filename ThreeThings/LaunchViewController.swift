//
//  LaunchViewController.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/8.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import LocalAuthentication
import IBAnimatable

class LaunchViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    @IBOutlet var tapLaunchPage: UITapGestureRecognizer!
    
    fileprivate let launchStore = LaunchStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let setViewController: (UIViewController?) -> Void = { [unowned self] viewController in
            
            guard let viewController = viewController else {
                fatalError("viewController is nil")
            }
            
            guard let navigationController = self.navigationController as? AnimatableNavigationController else { fatalError("AnimatableNavigationController type error") }
            navigationController.transitionAnimationType = .fade(direction: .in)
            self.navigationController?.setViewControllers([viewController], animated: true)

        }
        
        var touchIDAuth: Observable<Bool> {
            
            return Observable.create { observer in
                
                let authContext = LAContext()
                
                let authError:  NSErrorPointer = nil
                
                if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: authError) {
                    authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "三件事") { (success, evaluateError) in
                        DispatchQueue.main.async {
                            observer.onNext(success)
                            observer.onCompleted()
                        }
                    }
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
                
                return Disposables.create {
                }
            }
        }
        
        let tapEvent = tapLaunchPage.rx.event.map { _ in UserDefaults.Setting.bool(forKey: .enableTouchID) }
        let launchLoad = Observable.just(UserDefaults.Setting.bool(forKey: .enableTouchID))
        
        
        Observable.of(tapEvent, launchLoad)
            .merge()
            .filter { $0 }
            .flatMap{ _ in
                touchIDAuth
            }
            .filter { $0 }
            .flatMap { [unowned self] _ in
                self.launchStore.getter.lauchPage
            }
            .bindNext(setViewController)
            .addDisposableTo(disposeBag)
        
        Observable.of(tapEvent, launchLoad)
            .merge()
            .filter { !$0 }
            .flatMap { [unowned self] _ in
                self.launchStore.getter.lauchPage
            }
            .bindNext(setViewController)
            .addDisposableTo(disposeBag)
        
        

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
