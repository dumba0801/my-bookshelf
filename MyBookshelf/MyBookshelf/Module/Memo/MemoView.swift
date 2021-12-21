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

protocol MemoViewType: AnyObject {
    
}

final class MemoViewController: UIViewController {
    
    private lazy var titleTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Title"
        return view
    }()
    
    private lazy var bodyTextView : UITextView = {
        let view = UITextView()
        view.text = "Asdfadsfadsf"
        return view
    }()
    
    var presenter: MemoPresenterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "New Memo"
        self.addSubviews()
        self.configureLayout()
    }
    
    private func addSubviews() {
        self.view.addSubview(titleTextField)
        self.view.addSubview(bodyTextView)
    }
    
    private func configureLayout() {
        self.titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        self.bodyTextView.snp.makeConstraints { make in
            make.top.equalTo(self.titleTextField.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(40)
        }
    }
}

extension MemoViewController: MemoViewType {
    
}
