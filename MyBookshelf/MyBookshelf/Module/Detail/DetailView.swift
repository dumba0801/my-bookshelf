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
    
    var presenter: DetailPresenterType?
    private var errorFlag = false
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        guard let presenter = presenter else { return }
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBarController?.tabBar.isHidden = true
        presenter.fetchDetailBook(subject: Observable.just(()))
        addSubviews()
        confiureLayout()
        
        errorView.rx.retry
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                guard
                    let self = self,
                    let presenter = self.presenter
                else { return }
                
                presenter.fetchDetailBook(subject: Observable.just(()))
                
            }.disposed(by: disposeBag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(errorView)
    }
    
    private func confiureLayout() {
        scrollView.snp.makeConstraints { make in
            make.centerX.width.edges.equalToSuperview()
        }
        
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func switchView(error: Bool) {
        guard errorFlag != error else { return }
        
        errorView.play = error
        errorView.isHidden = !error
        scrollView.isHidden = error
        errorFlag = error
    }
}

extension DetailViewController: DetailViewControllerType {
    func onFetchdedDeatilBook(subject: Observable<DetailBook>) {
        switchView(error: false)
        
        subject.bind(to: scrollView.rx.book)
            .disposed(by: disposeBag)
    }
    
    func onFetchedError(subject: Observable<Error>) {
        switchView(error: true)
    }
}
