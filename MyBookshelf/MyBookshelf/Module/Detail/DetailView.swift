//
//  DetailView.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class DetailViewController: UIViewController {
    private lazy var scrollView: DetailScrollView = {
        let scrollView = DetailScrollView()
        scrollView.contentSize = self.view.frame.size
        return scrollView
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.isHidden = true
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    var presenter: DetailPresenterType?
    private var dataRelay = PublishRelay<(Book, [Memo])>()
    private var errorFlag = false
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.tabBarController?.tabBar.isHidden = true
        self.addSubviews()
        self.confiureLayout()
        self.presenter?.prepareViewDidLoad()
        
        self.scrollView
            .rx
            .addMemo
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
            self?.presenter?.didTapedAddMemoButton()
        }.disposed(by: self.disposeBag)
        
        self.dataRelay
            .observe(on: MainScheduler.instance)
            .map { $0.0 }
            .bind(to: self.scrollView.rx.book)
            .disposed(by: self.disposeBag)
        
        self.dataRelay
            .observe(on: MainScheduler.instance)
            .map { $0.1 }
            .bind(to: self.scrollView.rx.memos)
            .disposed(by: self.disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    private func addSubviews() {
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.errorView)
        self.view.addSubview(self.activityIndicator)
    }
    
    private func confiureLayout() {
        self.activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.centerX.width.edges.equalToSuperview()
        }
        
        self.errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DetailViewController: DetailViewControllerType {
    func drawView(with data: (Book, [Memo])) {
        self.switchView(error: false)
        self.dataRelay.accept(data)
    }
    
    func drawErrorView(with error: Error) {
        self.switchView(error: true)
    }
    
    private func switchView(error: Bool) {
        guard errorFlag != error else { return }
        
        self.errorView.play = error
        self.errorView.isHidden = !error
        self.scrollView.isHidden = error
        self.errorFlag = error
    }
}
