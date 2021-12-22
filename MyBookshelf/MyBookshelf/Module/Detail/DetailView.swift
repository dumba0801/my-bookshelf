//
//  DetailView.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import UIKit
import SnapKit
import RxSwift

protocol DetailViewControllerType: AnyObject {
    var presenter: DetailPresenterType? { get }
    
    func onFetchdedDeatilBook(subject: Observable<DetailBook>)
    func onFetchedMemos(subject: Observable<[Memo]>)
    func onFetchedError(subject: Observable<Error>)
}

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
    private var errorFlag = false
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        guard let presenter = presenter else { return }

        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.tabBarController?.tabBar.isHidden = true
        self.addSubviews()
        self.confiureLayout()
        
        let viewDidLoad = Observable.just(())
        let retry = self.errorView.rx.retry.map { $0 }
        let fetchSubject = Observable.of(viewDidLoad, retry)
                                .merge()
                                .do(onNext: { [weak self] _ in
                                    guard let self = self else {return}
                                    self.activityIndicator.startAnimating()
                                })
        
        presenter.fetchDetailBook(subject: fetchSubject)
        
        presenter.fetchMemos(subject: Observable.just(()))
        
        self.scrollView.rx.addMemo.bind { _ in
            presenter.showMemoModal()
        }.disposed(by: self.disposeBag)
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
    
    private func switchView(error: Bool) {
        guard errorFlag != error else { return }
        
        self.errorView.play = error
        self.errorView.isHidden = !error
        self.scrollView.isHidden = error
        self.errorFlag = error
    }
}

extension DetailViewController: DetailViewControllerType {
    func onFetchdedDeatilBook(subject: Observable<DetailBook>) {
        self.switchView(error: false)
        
        subject
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
            }).bind(to: self.scrollView.rx.book)
            .disposed(by: self.disposeBag)
    }
    
    func onFetchedError(subject: Observable<Error>) {
        self.switchView(error: true)
        
        subject.bind { [weak self] _ in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
        }.disposed(by: self.disposeBag)
    }
    
    func onFetchedMemos(subject: Observable<[Memo]>) {
        subject
            .bind(to: self.scrollView.rx.memos)
            .disposed(by: self.disposeBag)
    }
}
