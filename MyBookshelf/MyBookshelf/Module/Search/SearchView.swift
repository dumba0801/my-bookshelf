//
//  SearchView.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/16.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol SearchViewType: AnyObject {
    var presenter: SearchPresenterType? { get }
    
    func onFetchedSearchBooks(subject: Observable<[Book]>)
    func onFetchedError(subject: Observable<Error>) 
}

final class SearchViewController: UIViewController {
    typealias Cell = BookCollectionViewCell
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        return collectionView
    }()
    
    private lazy var errorView: ErrorView = {
        var view = ErrorView()
        view.isHidden = true
        return view
    }()
    
    var presenter: SearchPresenterType?
    
    private var errorFlag = false

    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        guard let presenter = presenter else { return }
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = Constant.navigationTitle
        addSubviews()
        configureLayout()
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let presenter = self.presenter
                else { return }
                
                let subject = Observable<String?>.just(self.searchBar.text)
                presenter.fetchSearchBook(subject: subject)
                self.searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Book.self)
            .subscribe(onNext: { book in
                guard let isbn13 = book.isbn13 else { return }
                presenter.showDetail(isbn13: isbn13)
            }).disposed(by: disposeBag)
        
        errorView.rx.retry
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                guard
                    let self = self,
                    let presenter = self.presenter
                else { return }
                
                presenter.fetchSearchBook(subject: Observable.just(self.searchBar.text))
                
            }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(errorView)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp_topMargin)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Metric.collectionViewTop)
            make.leading.trailing.equalToSuperview().inset(Metric.collectionViewLeadingTrailng)
            make.bottom.equalToSuperview()
        }
        
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SearchViewController: SearchViewType {
    func onFetchedSearchBooks(subject: Observable<[Book]>) {
        switchView(error: false)
        collectionView.dataSource = nil
        subject
            .bind(to: collectionView.rx.items(cellIdentifier: Cell.identifier,
                                              cellType: Cell.self)) {
                _, book, cell in
                
                let subject = Observable<Book>.just(book)
                cell.onBookData(subject: subject)
                
            }.disposed(by: disposeBag)
    }
    
    func onFetchedError(subject: Observable<Error>) {
        switchView(error: true)
    }
    
    private func switchView(error: Bool) {
        guard errorFlag != error else { return }
        
        errorView.play = error
        errorView.isHidden = !error
        collectionView.isHidden = error
        errorFlag = error
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
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

extension SearchViewController {
    private enum Metric {
        static let collectionViewTop = CGFloat(10)
        static let collectionViewLeadingTrailng = CGFloat(20)
        static let collectionViewWidth = CGFloat(0.4)
        static let collectionViewHeight = CGFloat(0.35)
    }
    
    private enum Constant {
        static let navigationTitle = "Search"
    }
}
