//
//  BookCell.swift
//  Book
//
//  Created by t2023-m105 on 1/2/25.
//

import UIKit

class BookCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .blue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = .white
    }
    
    func configure(with book: Book) {
        let maxCharacters = 15 // 최대 글자 수
        let truncatedTitle = book.title.count > maxCharacters
            ? String(book.title.prefix(maxCharacters)) + "..."
            : book.title
            
        titleLabel.text = " \(truncatedTitle)"
        authorLabel.text = " \(book.author)"
        priceLabel.text = " \(book.price)"
    }
}
