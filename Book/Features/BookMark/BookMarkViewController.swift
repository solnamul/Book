//
//  BookMarkViewController.swift
//  Book
//
//  Created by t2023-m105 on 1/2/25.
//

import UIKit

class BookMarkViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "담은 책 리스트가 여기에 표시됩니다."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
