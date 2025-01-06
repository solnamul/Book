//
//  BookMarkViewController.swift
//  Book
//
//  Created by t2023-m105 on 1/2/25.
//

import UIKit
import CoreData

class BookMarkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var bookmarkedBooks: [NSManagedObject] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchBookmarkedBooks()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchBookmarkedBooks() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookEntity")
        
        do {
            bookmarkedBooks = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Core Data 불러오기 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        let book = bookmarkedBooks[indexPath.row]
        cell.textLabel?.text = book.value(forKey: "title") as? String
        return cell
    }
}
