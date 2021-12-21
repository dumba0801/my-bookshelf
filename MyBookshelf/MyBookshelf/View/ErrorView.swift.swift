//
//  ErrorView.swift.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/20.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa
import SnapKit
import WebKit

class ErrorView: UIView {
    private lazy var disconnectAnimationView: AnimationView = {
        let view = AnimationView(name: Lottie.disconnected)
        view.loopMode = .repeat(Constant.animationRepeatTime)
        return view
    }()
    
    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.text = Text.firstLabel
        return label
    }()

    private lazy var secondLabel : UILabel = {
       let label = UILabel()
        label.text = Text.secondLabel
        return label
    }()
    
    lazy var retryButton: RetryButton = {
        let button = RetryButton()
        return button
    }()
    
    var play = false {
        didSet {
            playAnimation(flag: play)
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        configurationLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func addSubviews() {
        addSubview(disconnectAnimationView)
        addSubview(firstLabel)
        addSubview(secondLabel)
        addSubview(retryButton)
    }
    
    private func configurationLayout() {
        disconnectAnimationView.snp.makeConstraints { view in
            view.centerX.equalTo(firstLabel.snp.centerX)
            view.bottom.equalTo(firstLabel.snp.top).offset(-Metric.disconnectedAnimationViewBottom)
        }
        
        firstLabel.snp.makeConstraints { label in
            label.center.equalToSuperview()
        }
        
        secondLabel.snp.makeConstraints { label in
            label.centerX.equalTo(firstLabel.snp.centerX)
            label.top.equalTo(firstLabel.snp.bottom).offset(Metric.secondLabelTop)
        }
        
        retryButton.snp.makeConstraints { button in
            button.centerX.equalTo(secondLabel)
            button.top.equalTo(secondLabel.snp.bottom).offset(Metric.retryButtonTop)
            button.height.equalTo(Metric.retryButtonHeight)
            button.width.equalTo(Metric.retryButtonWidth)
        }
    }
    
    private func playAnimation(flag: Bool) {
        guard flag else { return }
        disconnectAnimationView.play()
    }
    
}

extension ErrorView {
    private enum Metric {
        static let disconnectedAnimationViewBottom = CGFloat(20)
        static let secondLabelTop = CGFloat(20)
        static let retryButtonTop = CGFloat(20)
        static let retryButtonWidth = CGFloat(100)
        static let retryButtonHeight = CGFloat(40)
    }
    
    private enum Text {
        static let firstLabel = "Oops!, An error has occurred"
        static let secondLabel = "Press the button below to try again."
    }
    
    private enum Lottie {
        static let disconnected = "disconnected"
    }
    
    private enum Constant {
        static let animationRepeatTime = Float(2)
    }
}
