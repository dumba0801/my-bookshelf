//
//  DetailScrollView.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SnapKit

public final class DetailScrollView: UIScrollView {
    typealias Cell = MemoTableViewCell
    
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
    
    private lazy var memoHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Memo"
        label.font = Font.memoHeaderLabel
        label.isHidden = true
        return label
    }()
    
    private lazy var memoTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        tableView.separatorInset.left = Constant.tableViewLeftSeparatorInset
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constant.tableViewEstimatedHeight
        tableView.isHidden = true
        return tableView
    }()
    
    lazy var addMemoButton: AddMemoButton = {
        let button = AddMemoButton()
        button.isHidden = true
        return button
    }()
    
    private var tableViewHeight: Constraint?
    
    var book: Book? {
        willSet {
            memoHeaderLabel.isHidden = true
            memoTableView.isHidden = true
            addMemoButton.isHidden = true
        }
        didSet {
            changedBook()
            memoHeaderLabel.isHidden = false
            memoTableView.isHidden = false
            addMemoButton.isHidden = false
        }
    }
    
    var memos: [Memo]? {
        didSet {
            onMemos()
        }
    }
    
    var memoDeleted: ControlEvent<Memo> {
        memoTableView.rx.modelDeleted(Memo.self)
    }
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureLayout()
        
        self.memoTableView
            .rx
            .observeWeakly(CGSize.self, "contentSize")
            .observe(on: MainScheduler.asyncInstance)
            .compactMap { $0?.height }
            .distinctUntilChanged()
            .asDriver{ _ in .never() }
            .drive { [weak self] height in
                guard let self = self else { return }
                self.tableViewHeight?.update(offset: height)
            }.disposed(by: self.disposeBag)
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
        contentView.addSubview(memoHeaderLabel)
        contentView.addSubview(memoTableView)
        contentView.addSubview(addMemoButton)
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
            make.leading.trailing.equalToSuperview().inset(Metric.defualtLeadingTrailng)
        }
        
        memoHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(Metric.defualtLeadingTrailng)
        }
        
        memoTableView.snp.makeConstraints { make in
            make.top.equalTo(memoHeaderLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(Metric.defualtLeadingTrailng)
            tableViewHeight = make.height.equalTo(100).constraint
        }
        
        addMemoButton.snp.makeConstraints { make in
            make.top.equalTo(memoTableView.snp.bottom).offset(Metric.defaultTop)
            make.width.equalTo(Metric.addMemoButtonWidth)
            make.height.equalTo(Metric.addMemoButtonHeight)
            make.centerX.bottom.equalToSuperview()
        }
    }
    
    private func changedBook() {
        guard let book = book,
              let authors = book.authors,
              let publisher = book.publisher,
              let language = book.language,
              let pages = book.pages,
              let year = book.year,
              let desc = book.desc
        else { return }
        
        Observable.just(())
            .flatMap { _ in book.imageUrl.image() }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        self.titleLabel.text = book.title
        self.subtitleLabel.text = book.subtitle
        self.authorsLabel.text = "Authros: " + authors
        self.publisherLabel.text = "Publisher: " + publisher
        self.languageLabel.text = "Language: " + language
        self.priceLabel.text = "Price: " + book.price
        self.pagesLabel.text = "Pages: " + pages
        self.yearLabel.text = "Year of publication: " + year
        self.descLabel.text = desc
    }
    
    func onMemos() {
        self.memoTableView.reloadData()
    }
}

extension DetailScrollView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let memos = memos else { return 0 }
        return memos.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell,
            let memos = memos,
            indexPath.row < memos.count
        else {
            return UITableViewCell()
        }
        
        let memo = memos[indexPath.row]
        cell.onData(subject: Observable.just(memo))
        
        return cell
        
    }
}

extension DetailScrollView: UITableViewDelegate {
    
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
        static let addMemoButtonWidth = CGFloat(120)
        static let addMemoButtonHeight = CGFloat(40)
    }
    
    private enum Font {
        static let titleLabel = UIFont.boldSystemFont(ofSize: 20)
        static let subtitleLabel = UIFont.systemFont(ofSize: 16)
        static let memoHeaderLabel = UIFont.boldSystemFont(ofSize: 26)
    }
    
    
    private enum Constant {
        static let titleLabelNumberOfLines = 2
        static let subtittleLabelNumberOfLines = 2
        static let subtitleLabelColor = UIColor.gray
        static let descLabelNumerOfLines = 0
        static let tableViewEstimatedHeight = CGFloat(40)
        static let tableViewLeftSeparatorInset = CGFloat(0)
    }
}
