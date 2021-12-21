//
//  ErrorView + Rx.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/20.
//

import RxSwift
import RxCocoa

extension Reactive where Base: ErrorView {
    var retry: ControlEvent<Void> {
        base.retryButton.rx.tap
    }
}

