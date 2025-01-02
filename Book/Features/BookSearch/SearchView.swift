//
//  SearchView.swift
//  Book
//
//  Created by t2023-m105 on 1/2/25.
//

import UIKit
import SnapKit

class SearchView: UIView {
    
    // UI 요소 정의
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "책 제목을 입력하세요"
        return searchBar
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
        backgroundColor = .white
        
        // 검색 바
        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
