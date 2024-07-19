//
//  ViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/4/24.
//

import UIKit
import SnapKit

fileprivate struct NetflixTab {
    let defaultImage: UIImage?
    let selectedImage: UIImage?
    let title: String
    
    static let nexflixTabList: [NetflixTab] = [
        NetflixTab(defaultImage: UIImage(systemName: "house"),
                   selectedImage: UIImage(systemName: "house.fill"),
                   title: "홈"),
        NetflixTab(defaultImage: UIImage(systemName: "play.rectangle.on.rectangle"),
                   selectedImage: UIImage(systemName: "play.rectangle.on.rectangle.fill"),
                   title: "NEW & HOT"),
        NetflixTab(defaultImage: UIImage(systemName: "arrow.down.circle"),
                   selectedImage: UIImage(systemName: "arrow.down.circle.fill"),
                   title: "저장한 콘텐츠 목록")
    ]
}

final class ViewController: UIViewController {

    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let titleList = ["넷플릭스", "로또", "일간 박스오피스", "TMDB Movie Trend", "날씨봇", "NASA", "미리 알림", "Diffable + ListConfiguration"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "코드베이스"
        
        configureHierarchy()
        configureLayout()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewControllerList = [
            UITabBarController(), LottoViewController(), BoxOfficeViewController(), MediaViewController(),
            WeatherBotViewController(), RandomNasaImageViewController(), ReminderMainViewController(), DiffableTabBarController()
        ]
        
        let index = indexPath.row
        
        let viewController = viewControllerList[index]
        
        if index == 0, let tabBarController = getConfiguredTabBar(viewController) {
            
            navigationController?.pushViewController(tabBarController, animated: true)
            navigationController?.navigationBar.tintColor = .white
        } else {
            navigationController?.navigationBar.tintColor = .label
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func getConfiguredTabBar(_ viewController: UIViewController) -> UITabBarController? {
        
        let tabBarController = viewController as! UITabBarController
        
        tabBarController.tabBar.backgroundColor = .darkGray
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.barTintColor = .white
        
        tabBarController.setViewControllers([
            HomeViewController(), NewAndHotViewController(), SaveContentsViewController()
        ],
                                            animated: true)
        guard let items = tabBarController.tabBar.items else { return nil }
        
        NetflixTab.nexflixTabList.enumerated().forEach {
            let index = $0.offset
            let item = $0.element
            
            items[index].image = item.defaultImage
            items[index].selectedImage = item.selectedImage
            items[index].title = item.title
        }
        
        return tabBarController
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        cell.textLabel?.text = titleList[indexPath.row]
        return cell
    }
}
