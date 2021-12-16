//
//  NewBookCollectionViewCell.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class NewBookCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewBookCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
       var imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = Constant.titleNumberOfLines
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = Constant.subtitleNumberOfLines
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(priceLabel)

    }
    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Metric.titleLabelTop)
            make.leading.trailing.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.subtitleTop)
            make.leading.trailing.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(Metric.priceTop)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func onBookData(subject: Observable<Book>) {
        subject.map { $0.title }
        .bind(to: titleLabel.rx.text)
        .disposed(by: disposeBag)
        
        subject.map{ $0.subtitle }
        .bind(to: subtitleLabel.rx.text)
        .disposed(by: disposeBag)
        
        subject.map{ $0.price }
        .bind(to: priceLabel.rx.text)
        .disposed(by: disposeBag)
        
        subject.compactMap{ $0.image }
        .flatMap { $0.image() }
        .bind(to: imageView.rx.image)
        .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        disposeBag = DisposeBag()
    }
}

extension NewBookCollectionViewCell {
    private enum Metric {
        static let titleLabelTop = CGFloat(10)
        static let subtitleTop = CGFloat(10)
        static let priceTop = CGFloat(10)
    }
    
    private enum Constant {
        static let titleNumberOfLines = 2
        static let subtitleNumberOfLines = 1
    }
}
