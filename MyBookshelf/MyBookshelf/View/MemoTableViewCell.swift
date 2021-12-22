//
//  MemoTableViewCell.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/21.
//

import UIKit
import SnapKit
import RxSwift

final class MemoTableViewCell: UITableViewCell {
    static let identifier = "MemoTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubviews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.bodyLabel)
        self.addSubview(self.dateLabel)
    }
    
    private func configureLayout() {
        self.dateLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Metric.dateLabelTopTrailing)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Metric.titleLabelTopLeading)
            make.trailing.equalTo(self.dateLabel.snp.leading).offset(Metric.titleLabelTrailng)
        }
        
        self.bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.bodyLabelTop)
            make.leading.bottom.equalToSuperview().inset(Metric.bodyLabelLeadingTrailingBottom)
        }
    }
    
    func onData(subject: Observable<Memo>) {
        subject.map { $0.title }
        .bind(to: titleLabel.rx.text)
        .disposed(by: disposeBag)
        
        subject.map { $0.body }
        .bind(to: bodyLabel.rx.text)
        .disposed(by: disposeBag)
    }
}

extension MemoTableViewCell {
    private enum Metric {
        static let dateLabelTopTrailing = CGFloat(20)
        static let titleLabelTopLeading = CGFloat(20)
        static let titleLabelTrailng = CGFloat(20)
        static let bodyLabelTop = CGFloat(20)
        static let bodyLabelLeadingTrailingBottom = CGFloat(20)
    }
}
