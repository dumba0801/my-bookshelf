//
//  NewView.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol NewViewControllerType: AnyObject {
    var presenter: NewPresenterType? { get }
    func onFetchedNewBooks(subject: Observable<[Book]>)
}

final class NewViewController: UIViewController {
    typealias Cell = BookCollectionViewCell
    
    var presenter: NewPresenterType?
    
    private lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        return collectionView
    }()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        guard let presenter = presenter else { return }
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = Constant.navigationTitle
        addSubviews()
        configureLayout()
        presenter.fetchNewBooks(subject: Observable.just(()))
        
        collectionView.rx.modelSelected(Book.self)
            .subscribe(onNext: { book in
                guard let isbn13 = book.isbn13 else { return }
                presenter.showDetail(isbn13: isbn13)
            }).disposed(by: disposeBag)
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Metric.collectionViewLeadingTrailng)
        }
    }
}

extension NewViewController: NewViewControllerType {
    func onFetchedNewBooks(subject: Observable<[Book]>) {
        subject
            .bind(to: collectionView.rx.items(cellIdentifier: Cell.identifier,
                                              cellType: Cell.self)) {
                _, book, cell in
                
                let subject = Observable<Book>.just(book)
                cell.onBookData(subject: subject)
                
            }.disposed(by: disposeBag)
    }
}

extension NewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width * Metric.collectionViewWidth
        let height = view.bounds.height * Metric.collectionViewHeight
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Cell else { return }
        cell.adjustLayout()
    }
}

extension NewViewController {
    private enum Metric {
        static let collectionViewLeadingTrailng = CGFloat(20)
        static let collectionViewWidth = CGFloat(0.4)
        static let collectionViewHeight = CGFloat(0.35)
    }
    
    private enum Constant {
        static let navigationTitle = "New"
    }
}
