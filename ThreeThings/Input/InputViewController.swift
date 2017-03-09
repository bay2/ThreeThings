//
//  InputViewController.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/1/28.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import IBAnimatable



class InputViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var toolbarBottom: NSLayoutConstraint!
    @IBOutlet weak var inputTextView: AnimatableTextView!
    @IBOutlet weak var lastBtn: AnimatableButton!
    @IBOutlet weak var nextBtn: AnimatableButton!
    @IBOutlet weak var dateLab: UILabel!
    fileprivate var inputStore = InputStore()
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textScrollView: UIScrollView!
    
    let labelAndTextViewTitle = [("Ⅰ", "一"), ("Ⅱ", "二"), ("Ⅲ", "三")];
    
    override func viewWillAppear(_ animated: Bool) {
        
        inputTextView.becomeFirstResponder()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        dateLab.text = Date().toString(format: "yyyy-MM-dd")
        
        let moveToolbar: (CGFloat) -> Void = { [unowned self] keyboardVisibleHeight in
            self.view.setNeedsLayout()
            UIView.animate(withDuration: 0.3) {
                self.toolbarBottom.constant = keyboardVisibleHeight
                self.view.layoutIfNeeded()
            }
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: moveToolbar)
            .addDisposableTo(disposeBag)
        
        
        inputStore.getter.currentPageIndex.map { [unowned self] index -> String in
            return "写下您今天的第\(self.labelAndTextViewTitle[index].1)件事..."
        }
        .bindTo(self.inputTextView.rx.placeholderText)
        .addDisposableTo(disposeBag)
        
        
        inputStore.getter.currentPageIndex.map { [unowned self] index -> String in
             return self.labelAndTextViewTitle[index].0
        }
        .bindTo(self.titleLab.rx.text)
        .addDisposableTo(disposeBag)
        
        // 第一页则隐藏 Last 按钮
        inputStore.getter.isFirstPage.asObservable()
            .bindTo(lastBtn.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        // 输入文字后则建 Next 按钮使能
        inputTextView
            .rx
            .text
            .map { $0?.lengthOfBytes(using: .utf8) ?? 0 > 0 ? true : false }
            .bindTo(nextBtn.rx.isEnabled)
            .addDisposableTo(disposeBag)
        

        inputStore.getter.pageInfo
            .bindTo(inputTextView.rx.text)
            .addDisposableTo(disposeBag)
        
        // 最后一页 Next -> Done
        inputStore.getter.isLastPage.asObservable()
            .map { $0 ? "Done" : "Next" }
            .bindTo(nextBtn.rx.title(for: .normal))
            .addDisposableTo(disposeBag)
        
        
        // MARK: 点击事件处理
        let isNext: (()) -> Bool = { [weak nextBtn = self.nextBtn] _ in nextBtn?.titleLabel?.text == "Next" }
        let isDone: (()) -> Bool = { _ in !isNext() }
        let mapTextViewText: (()) -> String = { [weak textView = self.inputTextView] _ in textView?.text ?? "" }
        
        nextBtn.rx.controlEvent(.touchUpInside)
            .filter (isNext)
            .map (mapTextViewText)
            .flatMap(inputStore.dispatch.next)
            .bindNext { [unowned self]  index in
                guard let vc = R.storyboard.input.inputViewController() else { fatalError("inputViewController is nil") }
                guard let navigationController = self.navigationController as? AnimatableNavigationController else { fatalError("AnimatableNavigationController type error") }
                navigationController.transitionAnimationType = .slide(to: .left, isFade: false)
                vc.inputStore = InputStore(index)
                self.pushVC(vc)
            }
            .addDisposableTo(disposeBag)
        
        nextBtn.rx.controlEvent(.touchUpInside)
            .filter(isDone)
            .map(mapTextViewText)
            .flatMap(inputStore.dispatch.done)
            .bindNext { [unowned self] model in
                guard let vc = R.storyboard.share.shareViewController() else { fatalError("shareViewController is nil") }
                guard let navigationController = self.navigationController as? AnimatableNavigationController else { fatalError("AnimatableNavigationController type error") }
                navigationController.transitionAnimationType = .systemFlip(from: .left)
                vc.thingsModel = model
                self.pushVC(vc)
            }
            .addDisposableTo(disposeBag)
        
        lastBtn.rx.controlEvent(.touchUpInside)
            .map(mapTextViewText)
            .flatMap(inputStore.dispatch.last)
            .bindNext { [unowned self] _ in
                guard let navigationController = self.navigationController as? AnimatableNavigationController else { fatalError("AnimatableNavigationController type error") }
                navigationController.transitionAnimationType = .slide(to: .left, isFade: false)
                self.popVC()
            }
            .addDisposableTo(disposeBag)
        
        inputTextView.rx.text
            .map { [unowned self] _ in
                return self.inputTextView.sizeThatFits(CGSize(width: self.inputTextView.size.width, height: CGFloat.infinity)).height
            }
            .bindNext { [unowned self] height in
                self.heightConstraint.constant = height + 8
                
                let offsetSize = self.textScrollView.contentSize.height - self.textScrollView.bounds.height
                if (offsetSize > 0) {
                    self.textScrollView.setContentOffset(CGPoint(x: 0, y: offsetSize), animated: true)
                }
                
            }
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

