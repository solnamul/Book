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
    let contents: String
    let thumbnail: String
}

class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "책 제목을 입력하세요"
        return searchBar
    }()
    private var searchResults: [Book] = [] // 검색 결과를 저장하는 배열
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBarInNavigationBar()
        configureActions()
    }
    
    private func setSearchBarInNavigationBar() {
        searchBar.delegate = self
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
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
                        let content = dict["contents"] as? String,
                        let thumbnail = dict["thumbnail"] as? String,
                        let price = dict["price"] as? Int
                    else { return nil }
                    
                    return Book(
                        title: title,
                        author: author.joined(separator: ", "), // 저자 여러 명을 쉼표로 구분
                        price: "\(price)원",
                        contents: content,
                        thumbnail: thumbnail
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

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        print("검색 버튼 클릭: \(query)")
        fetchBooks(query: query)
        searchBar.resignFirstResponder()
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
        let selectedBook = searchResults[indexPath.item]
        let detailVC = DetailViewController() // 상세 화면 인스턴스 생성
        detailVC.book = selectedBook // 선택된 책 데이터 전달
        detailVC.modalPresentationStyle = .pageSheet // 모달 형식 설정
        present(detailVC, animated: true, completion: nil) // 상세 화면 표시
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 40 // 좌우 여백 포함
        return CGSize(width: width, height: 100)
    }
}

// MARK: - DetailViewController
class BookDetailViewController: UIViewController {
    
    var book: Book? // 선택된 책 데이터
    
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let priceLabel = UILabel()
    private let addButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        titleLabel.font = .boldSystemFont(ofSize: 20)
        authorLabel.font = .systemFont(ofSize: 16)
        priceLabel.font = .systemFont(ofSize: 16)
        priceLabel.textColor = .gray
        
        addButton.setTitle("담기", for: .normal)
        addButton.backgroundColor = .green
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.addTarget(self, action: #selector(addToBookmark), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, priceLabel, addButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func configureUI() {
        guard let book = book else { return }
        titleLabel.text = book.title
        authorLabel.text = book.author
        priceLabel.text = book.price
    }
    
    @objc private func addToBookmark() {
        print("책 담기: \(book?.title ?? "알 수 없음")")
        dismiss(animated: true, completion: nil)
    }
}
