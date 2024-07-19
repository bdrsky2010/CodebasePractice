//
//  DiffableTabBarController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/18/24.
//

import UIKit

final class DiffableTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let diffableSettingTableViewController = DiffableSettingTableViewController()
        let diffableTravelTalkViewController = DiffableTravelTalkViewController()
        
        diffableSettingTableViewController.tabBarItem = UITabBarItem(
            title: "설정",
            image: UIImage(systemName: "gearshape.fill"),
            tag: 0)
        diffableTravelTalkViewController.tabBarItem = UITabBarItem(
            title: "트래블톡",
            image: UIImage(systemName: "message.fill"),
            tag: 0)
        
        setViewControllers([diffableSettingTableViewController, diffableTravelTalkViewController], animated: true)
    }
}
