//
//  ViewController.swift
//  Book
//
//  Created by t2023-m105 on 1/2/25.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        // 첫 번째 탭 (검색 화면)
        let searchVC = SearchViewController()
        let searchNavController = UINavigationController(rootViewController: searchVC)
        searchNavController.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        // 두 번째 탭 (담은 책 리스트 화면)
        let savedBooksVC = BookMarkViewController()
        let savedBooksNavController = UINavigationController(rootViewController: savedBooksVC)
        savedBooksNavController.tabBarItem = UITabBarItem(title: "담은 책", image: UIImage(systemName: "bookmark"), tag: 1)
        
        // 탭바에 추가
        viewControllers = [searchNavController, savedBooksNavController]
    }
}
