//
//  SearchViewController.swift
//  Book
//
//  Created by t2023-m105 on 1/2/25.
//

import UIKit

struct Book {
    let title: String
    let author: String
    let price: String
}

class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    private var searchResults: [Book] = [] // 검색 결과를 저장하는 배열
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActions()
    }
    
    private func configureActions() {
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
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
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("API 호출 에러: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("데이터 없음")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let documents = json?["documents"] as? [[String: Any]] ?? []
                
                self?.searchResults = documents.prefix(3).compactMap { dict -> Book? in
                    guard
                        let title = dict["title"] as? String,
                        let author = dict["authors"] as? [String],
                        let price = dict["price"] as? Int
                    else { return nil }
                    
                    return Book(
                        title: title,
                        author: author.joined(separator: ", "), // 저자 여러 명을 쉼표로 구분
                        price: "\(price)원"
                    )
                }
                
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            } catch {
                print("JSON 파싱 에러: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func updateUI() {
        searchView.resultsLabel.text = searchResults.isEmpty ? "검색 결과가 없습니다." : "검색 결과"
        searchView.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        let book = searchResults[indexPath.item]
        cell.configure(with: book)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = searchResults[indexPath.item]
        print("선택된 책: \(book.title), \(book.author), \(book.price)")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 40 // 좌우 여백 포함
        return CGSize(width: width, height: 100)
    }
}
