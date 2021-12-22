//
//  AddMemoButton.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/21.
//

import UIKit

final class AddMemoButton: UIButton {
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        self.backgroundColor = .label
        self.layer.cornerRadius = Constant.cornerRadius
        self.setTitle(Constant.titleText, for: .normal)
        self.setTitleColor(.systemBackground, for: .normal)
        self.titleLabel?.font = Font.titleLabel
        self.setImage(Constant.buttonImage, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        
    }
}

extension AddMemoButton {
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    private enum Constant {
        static let buttonImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: .systemBackground))
        static let cornerRadius = CGFloat(10)
        static let titleText = "Add Memo"
    }
}
