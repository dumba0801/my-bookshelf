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

class BookCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = Constant.titleNumberOfLines
        label.font = Font.titleLabel
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = Constant.subtitleNumberOfLines
        label.font = Font.subtitleLabel
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = Font.priceLabel
        label.textColor = Constant.priceLabelColor
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
            make.top.equalToSuperview().inset(-Metric.imageViewTop)
            make.centerX.width.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(-Metric.titleLabelTop)
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
        
        subject.compactMap{ $0.subtitle }
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
    
    func adjustLayout() {
        _ = subtitleLabel.text != nil ? nonEmptySubtitleLabelLayout() : emptySubtitleLabelLayout()
    }
    
    
    private func emptySubtitleLabelLayout() {
        priceLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.priceTop)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func nonEmptySubtitleLabelLayout() {
        priceLabel.snp.remakeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(Metric.priceTop)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        disposeBag = DisposeBag()
    }
}

extension BookCollectionViewCell {
    private enum Metric {
        static let imageViewTop = CGFloat(20)
        static let titleLabelTop = CGFloat(50)
        static let subtitleTop = CGFloat(2)
        static let priceTop = CGFloat(2)
    }

    private enum Font {
        static let titleLabel = UIFont.boldSystemFont(ofSize: 14)
        static let subtitleLabel = UIFont.systemFont(ofSize: 12)
        static let priceLabel = UIFont.systemFont(ofSize: 12)
    }

    private enum Constant {
        static let titleNumberOfLines = 2
        static let subtitleNumberOfLines = 1
        static let priceLabelColor = UIColor.gray
    }
    
}
