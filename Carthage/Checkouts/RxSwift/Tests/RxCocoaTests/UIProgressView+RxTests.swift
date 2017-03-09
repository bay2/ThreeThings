//
//  UIProgressView+RxTests.swift
//  Tests
//
//  Created by Krunoslav Zaher on 11/26/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxTest
import XCTest

class UIProgressViewTests: RxTest {

}

extension UIProgressViewTests {
    func testProgressView_HasWeakReference() {
        ensureControlObserverHasWeakReference(UIProgressView(), { (progressView: UIProgressView) -> AnyObserver<Float> in progressView.rx.progress.asObserver() }, { Variable<Float>(0.0).asObservable() })
    }

    func testProgressView_NextElementsSetsValue() {
        let subject = UIProgressView()
        let progressSequence = Variable<Float>(0.0)
        let disposable = progressSequence.asObservable().bindTo(subject.rx.progress)
        defer { disposable.dispose() }

        progressSequence.value = 1.0
        XCTAssert(subject.progress == progressSequence.value, "Expected progress to have been set")
    }
}
