//
//  CompositionRoot.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import UIKit

struct AppDependency {
    let window: UIWindow
}

final class CompositionRoot {
    static func resolve() -> AppDependency {
        
        // Window
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        // Service
        let mockRepository = MockProductRepository()
        let likedProductRepository = LikedProductRepository.shared
        
        // Reactor
        let homeListViewReactor = HomeListViewReactor(
            productRepository: mockRepository,
            likedProductRepository: likedProductRepository
        )
        let likeListReactor = LikeListViewReactor(likedProductRepository: likedProductRepository)
        
        // ViewController
        let homeListVC = HomeListViewController(reactor: homeListViewReactor)
        homeListVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "iconHome"), tag: 0)
        
        let homeListNaviVC = UINavigationController()
        homeListNaviVC.setViewControllers([homeListVC], animated: true)
        
        let likeListVC = LikeListViewController(reactor: likeListReactor)
        likeListVC.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(named: "iconZzim"), tag: 1)
        
        let likeListNaviVC = UINavigationController()
        likeListNaviVC.setViewControllers([likeListVC], animated: true)

        
        // TabBar
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .regular)], for: .normal)
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = Palette.watermelon
        tabBarController.tabBar.unselectedItemTintColor = Palette.brownishGray
        tabBarController.setViewControllers([homeListNaviVC, likeListNaviVC], animated: true)
        
        window.rootViewController = tabBarController
        
        return AppDependency(window: window)
    }
}
