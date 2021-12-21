//
//  RetryButton.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/21.
//

import UIKit

final class RetryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        create()
    }
    
    private func create() {
        backgroundColor = .label
        layer.cornerRadius = Constant.cornerRadius
        setTitle(Constant.titleText, for: .normal)
        setTitleColor(.systemBackground, for: .normal)
        titleLabel?.font = Font.titleLabel
        setImage(Constant.buttonImage, for: .normal)
        imageView?.contentMode = .scaleAspectFit
    }
}

extension RetryButton {
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    private enum Constant {
        static let buttonImage = UIImage(systemName: "arrow.clockwise", withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: .systemBackground))
        static let cornerRadius = CGFloat(10)
        static let titleText = "Retry"
    }
}