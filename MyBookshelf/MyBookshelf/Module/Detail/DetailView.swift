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
}

final class DetailViewController: UIViewController {
    private lazy var scrollView: DetailScrollView = {
        let scrollView = DetailScrollView()
        scrollView.contentSize = self.view.frame.size
        return scrollView
    }()
    
    var presenter: DetailPresenterType?
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        guard let presenter = presenter else { return }

        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBarController?.tabBar.isHidden = true
        presenter.fetchDetailBook(subject: Observable.just(()))
        addSubviews()
        confiureLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
    }
    
    private func confiureLayout() {
        scrollView.snp.makeConstraints { make in
            make.centerX.width.edges.equalToSuperview()
        }
    }
}

extension DetailViewController: DetailViewControllerType {
    func onFetchdedDeatilBook(subject: Observable<DetailBook>) {
        subject.bind(to: scrollView.rx.book)
            .disposed(by: disposeBag)
    }
}
