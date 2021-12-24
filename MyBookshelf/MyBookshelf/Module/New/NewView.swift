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
    
    //MARK: - View
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
    
    private var booksRelay = PublishRelay<[BookInfo]>()
    private var errorFlag = false
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = Constant.navigationTitle
        self.addSubviews()
        self.configureLayout()
        self.presenter?.prepareViewDidLoad()
        
        self.collectionView
            .rx
            .modelSelected(BookInfo.self)
            .subscribe(onNext: { [weak self] book in
                self?.presenter?.didTapedBookCell(isbn13: book.isbn13)
            }).disposed(by: self.disposeBag)
        
        self.booksRelay
            .bind(to: collectionView.rx.items(cellIdentifier: Cell.identifier,
                                                    cellType: Cell.self)
        ) { _, book, cell in
            
            cell.onBook(with: book)
        }.disposed(by: self.disposeBag)
        
        self.errorView
            .rx
            .retry
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.presenter?.didTapedRetryButton()
            }
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
        
    func drawView(with books: [BookInfo]) {
        self.switchView(error: false)
        self.booksRelay.accept(books)
    }
    
    func drawErrorView(with error: Error) {
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
