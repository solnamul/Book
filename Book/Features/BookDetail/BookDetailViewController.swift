//
//  BookDetailViewController.swift
//  Book
//
//  Created by t2023-m105 on 1/2/25.
//

import UIKit
import CoreData
import SnapKit

class DetailViewController: UIViewController {
    
    // 선택된 책 정보
    var book: Book? {
        didSet {
            configureData()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .systemGreen
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.textColor = .darkGray
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("담기", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 20
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureData()
    }
    
    private func setupUI() {
        // Close Button
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        
        // Thumbnail ImageView
        view.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(280)
        }
        
        // Title Label
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Author Label
        view.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Price Label
        view.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Description Label
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Add Button
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        addButton.addTarget(self, action: #selector(addToBookmark), for: .touchUpInside)
    }
    
    private func configureData() {
        guard let book = book else { return }
        titleLabel.text = book.title
        authorLabel.text = book.author
        priceLabel.text = book.price
        descriptionLabel.text = book.contents
        
        // 썸네일 이미지 로드
        if let url = URL(string: book.thumbnail) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    @objc private func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addToBookmark() {
        guard let book = book else { return }
        
        // Core Data에 저장
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "BookEntity", in: context) else {
            print("엔티티를 찾을 수 없습니다.")
            return
        }
        
        let newBook = NSManagedObject(entity: entity, insertInto: context)
        
        newBook.setValue(book.title, forKey: "title")
        newBook.setValue(book.author, forKey: "author")
        newBook.setValue(book.price, forKey: "price")
        newBook.setValue(book.contents, forKey: "contents")
        newBook.setValue(book.thumbnail, forKey: "thumbnail")
        
        do {
            try context.save()
            print("책이 북마크에 저장되었습니다.")
            dismiss(animated: true, completion: nil) // 모달 닫기
        } catch {
            print("Core Data 저장 실패: \(error.localizedDescription)")
        }
    }
}
