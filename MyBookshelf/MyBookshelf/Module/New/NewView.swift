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

final class NewViewController: UIViewController {
    typealias Cell = BookCollectionViewCell
    
    private lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        return collectionView
    }()
    
    private lazy var errorView: ErrorView = {
        var view = ErrorView()
        view.isHidden = true
        return view
    }()
    
    var presenter: NewPresenterType?
    
    private var errorFlag = false
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        guard let presenter = presenter else { return }
        
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = Constant.navigationTitle
        self.addSubviews()
        self.configureLayout()
        
        let viewDidLoad = Observable.just(())
        let retry = self.errorView.rx.retry.map{ $0 }
        let fetchSubject = Observable.of(viewDidLoad, retry).merge()
        
        presenter.fetchNewBooks(subject: fetchSubject)
        
        self.collectionView.rx.modelSelected(Book.self)
            .subscribe(onNext: { book in
                guard let isbn13 = book.isbn13 else { return }
                presenter.showDetail(isbn13: isbn13)
            }).disposed(by: self.disposeBag)
        
        
    }
    
    private func addSubviews() {
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.errorView)
    }
    
    private func configureLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Metric.collectionViewLeadingTrailng)
        }
        
        self.errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension NewViewController: NewViewControllerType {
    func onFetchedNewBooks(subject: Observable<[Book]>) {
        self.switchView(error: false)
        
        subject
            .bind(to: self.collectionView.rx.items(cellIdentifier: Cell.identifier,
                                                   cellType: Cell.self)) {
                _, book, cell in
                
                let subject = Observable<Book>.just(book)
                cell.onBookData(subject: subject)
                
            }.disposed(by: self.disposeBag)
    }
    
    func onFetchedError(subject: Observable<Error>) {
        self.switchView(error: true)
    }
    
    private func switchView(error: Bool) {
        guard errorFlag != error else { return }
        
        self.errorView.play = error
        self.errorView.isHidden = !error
        self.collectionView.isHidden = error
        self.errorFlag = error
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
