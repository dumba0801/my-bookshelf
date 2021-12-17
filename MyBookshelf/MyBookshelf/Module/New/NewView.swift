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
        navigationItem.title = "New"
        tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        addSubviews()
        configureLayout()
        presenter.fetchNewBooks(subject: Observable.just(()))
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.4
        let height = collectionView.bounds.height * 0.35
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Cell else { return }
        cell.adjustLayout()
    }
}

