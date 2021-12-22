//
//  MemoView.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class MemoViewController: UIViewController {
    
    private lazy var titleTextField: UITextField = {
        let view = UITextField()
        view.placeholder = Constant.titleTextFieldPlaceHolder
        return view
    }()
    
    private lazy var bodyTextView : UITextView = {
        let view = UITextView()
        view.delegate = self
        return view
    }()
    
    private lazy var bodyTextViewPlaceHolderLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.bodyTextViewPlaceHolder
        label.textColor = Constant.bodyTextViewPlaceHolderColor
        label.font = Font.bodyTextViewPlaceHolderLabel
        return label
    }()
    
    private lazy var rightBarButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.rightBarButtonImage, for: .normal)
        
        return button
    }()
    
    var presenter: MemoPresenterType?
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "New Memo"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        self.addSubviews()
        self.configureLayout()
        
        self.rightBarButton.rx.tap.bind { [weak self] _ in
            guard
                let self = self,
                let presenter = self.presenter
            else {
                return
            }
            
            presenter.saveMemo(title: self.titleTextField.text, body: self.bodyTextView.text)
        }.disposed(by: self.disposeBag)
    }
    
    private func addSubviews() {
        self.view.addSubview(titleTextField)
        self.view.addSubview(bodyTextView)
        self.view.addSubview(bodyTextViewPlaceHolderLabel)
    }
    
    private func configureLayout() {
        self.titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.titleTextFieldTop)
            make.leading.trailing.equalToSuperview().inset(Metric.titleTextFieldLeadingTrailing)
        }
        
        self.bodyTextViewPlaceHolderLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleTextField.snp.bottom)
                .offset(Metric.bodyTextViewPlaceHolderLabelTop)
            make.leading.trailing.equalToSuperview()
                .inset(Metric.bodyTextViewPlaceHolderLabelLeadingTrailing)
        }
        
        self.bodyTextView.snp.makeConstraints { make in
            make.top.equalTo(self.titleTextField.snp.bottom).offset(Metric.bodyTextViewTop)
            make.leading.trailing.bottom.equalToSuperview()
                .inset(Metric.bodyTextViewBottomLeadingTrailing)
        }
    }
}

extension MemoViewController: MemoViewType {
    
}

extension MemoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        bodyTextViewPlaceHolderLabel.isHidden = !textView.text.isEmpty
    }
    
}

extension MemoViewController {
    private enum Metric {
        static let titleTextFieldTop = CGFloat(40)
        static let titleTextFieldLeadingTrailing = CGFloat(40)
        static let bodyTextViewPlaceHolderLabelTop = CGFloat(30)
        static let bodyTextViewPlaceHolderLabelLeadingTrailing = CGFloat(44)
        static let bodyTextViewTop = CGFloat(20)
        static let bodyTextViewBottomLeadingTrailing = CGFloat(40)
    }
    
    private enum Font {
        static let bodyTextViewPlaceHolderLabel = UIFont.systemFont(ofSize: 12)
    }
    
    private enum Constant {
        static let titleTextFieldPlaceHolder = "Title"
        static let bodyTextViewPlaceHolder = "Please fill out the text"
        static let bodyTextViewPlaceHolderColor = UIColor.systemGray
        static let bodyTextViewTextColor = UIColor.label
        static let rightBarButtonImage = UIImage(systemName: "plus.circle")
    }
}
