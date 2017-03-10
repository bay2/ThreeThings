//
//  ShareViewController.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/2/24.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EZSwiftExtensions
import IBAnimatable
import MonkeyKing


class ShareViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var webView: UIWebView!
    var thingsModel: ThreeThingsModel!
    
    @IBOutlet var tapWebView: UITapGestureRecognizer!
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let inputStore = InputStore()
    
    let makeImage: (UIWebView) -> UIImage? = { webView in
        let height = webView.stringByEvaluatingJavaScript(from: "document.getElementById('displayDiv').clientHeight")?.toFloat() ?? 0
        UIGraphicsBeginImageContextWithOptions(CGSize(width: webView.size.width, height: CGFloat(height)), false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        webView.scrollView.layer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    let shareImage: (UIViewController, UIImage?) -> Void = { presentVC, image in
        
        var sharingItems = [AnyObject]()
        sharingItems.append(image!)
        
        let info = MonkeyKing.Info(title: nil, description: nil, thumbnail: nil, media: .image(image!))
        
        let sessionMessage = MonkeyKing.Message.weChat(.session(info: info))
        
        let weChatSessionActivity = WeChatActivity(
            type: .session,
            message: sessionMessage,
            completionHandler: { success in
                debugPrint("share Image to WeChat Session success: \(success)")
        })
        
        let timelineMessage = MonkeyKing.Message.weChat(.timeline(info: info))
        
        let weChatTimelineActivity = WeChatActivity(
            type: .timeline,
            message: timelineMessage,
            completionHandler: { success in
                debugPrint("share Image to WeChat Timeline success: \(success)")
        })
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: [weChatSessionActivity, weChatTimelineActivity])
        presentVC.present(activityViewController, animated: true, completion: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reloadHTML()
        
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.bouncesZoom = false
        webView.addGestureRecognizer(tapWebView)
        tapWebView.delegate = self
        
        
        
        
        
        let bindTapBack: (ShareModelViewController) -> Void = { [unowned self] modelVC in
            
            modelVC.tapBack
                .bindNext { [unowned self] _ in
                    modelVC.dismissVC(completion: nil)
                    self.popVC()
                }
                .addDisposableTo(self.disposeBag)
            
        }
        
        let bindTapHome: (ShareModelViewController) -> Void = { [unowned self] modelVC in
            
            modelVC.tapHome
                .flatMap(self.inputStore.dispatch.save)
                .bindNext { [unowned self] _ in
                    modelVC.dismissVC(completion: nil)
                    self.presentHomeSegue()
                    
                }
                .addDisposableTo(self.disposeBag)
        }
        
        
        let bindTapShare: (ShareModelViewController) -> Void = { [unowned self] modelVC in
            
            modelVC.tapShare
                .flatMap(self.inputStore.dispatch.save)
                .map { [unowned self] _ in self.webView }
                .map(self.makeImage)
                .map { image in (modelVC, image) }
                .bindNext(self.shareImage)
                .addDisposableTo(self.disposeBag)
            
         
        }

        
        let shareModel: (UITapGestureRecognizer) -> Void = { [unowned self] _ in
            
            guard let modelVC = R.storyboard.share.shareModelViewController() else {
                fatalError("shareModelViewController is nil")
            }
            
            self.presentVC(modelVC)
            bindTapBack(modelVC)
            bindTapHome(modelVC)
            bindTapShare(modelVC)
            
        }
        
        tapWebView.rx.event.bindNext(shareModel)
        .addDisposableTo(disposeBag)

    }
    
    func reloadHTML() {
        
        let htmlPath = Bundle.main.path(forResource: "Template", ofType: "html") ?? ""
        var htmlCont = try! String(contentsOf: URL(fileURLWithPath: htmlPath))
        
        htmlCont = htmlCont.replacingOccurrences(of: "#thingDate#", with: thingsModel.writeDate.replacingOccurrences(of: "-", with: "."))
        htmlCont = htmlCont.replacingOccurrences(of: "#firstThing#", with: thingsModel.firstThing)
        htmlCont = htmlCont.replacingOccurrences(of: "#secondThing#", with: thingsModel.secondThing)
        htmlCont = htmlCont.replacingOccurrences(of: "#threeThing#", with: thingsModel.threeThing)
        
        webView.loadHTMLString(htmlCont, baseURL: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Set the transition animation type for `AnimatableViewController`, used for Present/Dismiss transitions
        if let toViewController = segue.destination as? AnimatableViewController {
            toViewController.transitionAnimationType = .cards(direction: .forward)
        }
    }
    
    func presentHomeSegue() {
        if let toViewController = R.storyboard.home.homeViewController() {
            let segue = PresentCardsSegue(identifier: "PresentCardsSegue", source: self, destination: toViewController)
            prepare(for: segue, sender: self)
            segue.perform()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    

}
