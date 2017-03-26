//
//  DownloadiCloudDataViewController.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/24.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

extension Reactive where Base: UIView {
    
    var hidden: Observable<Bool> {
        return self.methodInvoked(#selector(setter: self.base.isHidden)).map { (event) -> Bool in
            guard let hidden = event.first as? Bool else {
                return false
            }
            return hidden
        }
        .startWith(self.base.isHidden)
    }
    
}


class DownloadiCloudDataViewController: UIViewController {

    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!

    @IBOutlet weak var importView: UIView!
    @IBOutlet weak var deniedView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var fileNotExistView: UIView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let store = DownloadiCloudDataStore()
    
    func showView(_ body: () -> ()) {
        
        let views = [importView, deniedView, loadingView]
        
        views.forEachEnumerated { _, view in
            view?.isHidden = true
        }
        
        activityView.stopAnimating()
        
        body()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pushInputView: () -> () = {
            
            guard let vc = R.storyboard.input.inputViewController() else {
                fatalError("inputViewController is nil")
            }
            self.pushVC(vc);
            
        }
        
        
        let stateProc: (DownloadState) -> () = {
            switch $0 {
            case .denied:
                self.showView {
                    self.deniedView.isHidden = false
                }
            case .fileNotExist:
                self.showView {
                    self.fileNotExistView.isHidden = false
                }
            case .downloading:
                self.showView {
                    self.loadingView.isHidden = false
                    self.activityView.startAnimating()
                }
            case .done:
                break
//                realm = try! Realm()
//                pushInputView()
            case .unknown:
                self.showView {
                    self.importView.isHidden = false
                }
            }
        }
        
        Observable.of(skipBtn.rx.tap,
                      noBtn.rx.tap)
            .merge()
            .bindNext { _ in
                pushInputView()
        }
        .addDisposableTo(disposeBag)
        
        
        Observable.combineLatest(deniedView.rx.hidden, fileNotExistView.rx.hidden) {
            return ($0 && $1)
        }
        .bindTo(skipBtn.rx.isHidden)
        .addDisposableTo(disposeBag)
        
        
        let download = yesBtn.rx.tap
            .flatMap { [unowned store = self.store] _ in store.commit.download }
        
        download
            .bindNext(stateProc)
            .addDisposableTo(disposeBag)
        
        download.filter { $0 == .done }
            .map { _ in
                setDefaultRealmForUser(username: "download")
                realm = try! Realm()
            }
            .map { _ in
//                realm = try! Realm()
                return LaunchStore()
            }
            .flatMap { $0.getter.lauchPage }
            .bindNext { [unowned self] vc in
                guard let vc = vc else {
                    fatalError()
                }

                self.pushVC(vc)
        }
        .addDisposableTo(disposeBag)
        
            
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
