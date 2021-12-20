//
//  DetailScrollView.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import UIKit
import RxSwift
import RxCocoa

public final class DetailScrollView: UIScrollView {
    
    private lazy var contentView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = Constant.titleLabelNumberOfLines
        label.font = Font.titleLabel
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = Constant.subtittleLabelNumberOfLines
        label.font = Font.subtitleLabel
        label.textColor = Constant.subtitleLabelColor
        return label
    }()
    
    private lazy var authorsLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    private lazy var publisherLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    private lazy var languageLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    private lazy var pagesLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = Constant.descLabelNumerOfLines
        return label
    }()
    
    var book: DetailBook? {
        didSet {
            changedBook()
        }
    }
    
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
        addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(authorsLabel)
        contentView.addSubview(publisherLabel)
        contentView.addSubview(languageLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(pagesLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(descLabel)
    }
    
    private func configureLayout() {
        contentView.snp.makeConstraints { make in
            make.width.centerX.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(-Metric.imageViewTop)
            make.width.equalToSuperview().multipliedBy(Metric.imageViewWidth)
            make.height.equalTo(imageView.snp.width).multipliedBy(Metric.imageViewHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(-Metric.titleLabelTop)
            make.leading.trailing.equalToSuperview().inset(Metric.defualtLeadingTrailng)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.subtitleLabelTop)
            make.leading.trailing.equalToSuperview().inset(Metric.defualtLeadingTrailng)
        }
        
        authorsLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(Metric.defaultTop)
            make.leading.trailing.equalToSuperview().inset(Metric.defualtLeadingTrailng)
        }
        
        publisherLabel.snp.makeConstraints { make in
            make.top.equalTo(authorsLabel.snp.bottom).offset(Metric.defaultTop)
            make.leading.trailing.equalToSuperview().inset(Metric.defualtLeadingTrailng)

        }
        
        languageLabel.snp.makeConstraints { make in
            make.top.equalTo(publisherLabel.snp.bottom).offset(Metric.defaultTop)
            make.leading.trailing.equalToSuperview().inset(Metric.defualtLeadingTrailng)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(languageLabel.snp.bottom).offset(Metric.defaultTop)
            make.leading.trailing.equalToSuperview().inset(Metric.defualtLeadingTrailng)
        }
        
        pagesLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(Metric.defaultTop)
            make.leading.trailing.equalToSuperview().inset(Metric.defualtLeadingTrailng)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(pagesLabel.snp.bottom).offset(Metric.defaultTop)
            make.leading.trailing.equalToSuperview().inset(Metric.defualtLeadingTrailng)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(Metric.defaultTop)
            make.leading.trailing.bottom.equalToSuperview().inset(Metric.defualtLeadingTrailng)
        }
    }
    
    private func changedBook() {
        guard let book = book else { return }

        Observable.just(())
            .flatMap { _ in book.imageUrl!.image() }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        self.titleLabel.text = book.title
        self.subtitleLabel.text = book.subtitle
        self.authorsLabel.text = "Authros: " + book.authors
        self.publisherLabel.text = "Publisher: " + book.publisher
        self.languageLabel.text = "Language: " + book.language
        self.priceLabel.text = "Price: " + book.price
        self.pagesLabel.text = "Pages: " + book.pages
        self.yearLabel.text = "Year of publication: " + book.year
        self.descLabel.text = book.desc
    }
}

extension DetailScrollView {
    private enum Metric {
        static let imageViewTop = CGFloat(100)
        static let imageViewWidth = CGFloat(0.8)
        static let imageViewHeight = CGFloat(1.5)
        static let titleLabelTop = CGFloat(80)
        static let subtitleLabelTop = CGFloat(0)
        static let defualtLeadingTrailng = CGFloat(10)
        static let defaultTop = CGFloat(20)
    }
    
    private enum Font {
        static let titleLabel = UIFont.boldSystemFont(ofSize: 20)
        static let subtitleLabel = UIFont.systemFont(ofSize: 16)
    }
    
    private enum Constant {
        static let titleLabelNumberOfLines = 2
        static let subtittleLabelNumberOfLines = 2
        static let subtitleLabelColor = UIColor.gray
        static let descLabelNumerOfLines = 0
    }
}
