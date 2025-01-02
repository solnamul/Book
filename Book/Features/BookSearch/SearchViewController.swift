//
//  SearchViewController.swift
//  Book
//
//  Created by t2023-m105 on 1/2/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    
    override func loadView() {
        // SearchView를 뷰 컨트롤러의 루트 뷰로 설정
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true) // 검색창이 겹쳐 네비게이션 바 숨기기
    }
    
    private func configureActions() {
        searchView.searchBar.delegate = self
    }
    
    private func fetchBooks(query: String) {
        guard !query.isEmpty else { return }
        
        let urlString = "https://dapi.kakao.com/v3/search/book?query=\(query)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("잘못된 URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization": "KakaoAK eb904a41e2e463eb85dadb0eaca5517c"]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API 호출 에러: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("데이터 없음")
                return
            }
            
            // JSON 데이터 출력
            if let jsonString = String(data: data, encoding: .utf8) {
                print("API 결과: \(jsonString)")
            }
            
            // 필요한 경우 데이터를 파싱해서 UI에 반영 가능
        }.resume()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        print("검색 버튼 클릭: \(query)")
        fetchBooks(query: query) // API 호출
        searchBar.resignFirstResponder() // 키보드 닫기
    }
}
