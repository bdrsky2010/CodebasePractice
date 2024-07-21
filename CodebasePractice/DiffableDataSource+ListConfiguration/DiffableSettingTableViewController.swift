//
//  DiffableSettingTableViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/18/24.
//

import UIKit

import SnapKit

fileprivate struct KakaoSetting: Hashable, Identifiable {
    let id = UUID()
    let title: String
}

fileprivate enum SettingCategory: CaseIterable {
    case entire
    case personal
    case etc
    
    var title: String {
        switch self {
        case .entire:
            return "전체 설정"
        case .personal:
            return "개인 설정"
        case .etc:
            return "기타"
        }
    }
    
    var detail: [KakaoSetting] {
        switch self {
        case .entire:
            return [
                KakaoSetting(title: "공지사항"),
                KakaoSetting(title: "실험실"),
                KakaoSetting(title: "버전 정보")
            ]
        case .personal:
            return [
                KakaoSetting(title: "개인/보안"),
                KakaoSetting(title: "알림"),
                KakaoSetting(title: "채팅"),
                KakaoSetting(title: "멀티프로필")
            ]
        case .etc:
            return [
                KakaoSetting(title: "고객센터/도움말")
            ]
        }
    }
}

final class DiffableSettingTableViewController: BaseViewController {
    private let settingCollectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.backgroundColor = .black
        configuration.headerMode = .supplementary
        configuration.separatorConfiguration.color = .darkGray
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    // <섹션을 구분해 줄 데이터 타입, 셀에 들어가는 데이터 타입>
    private var dataSource: UICollectionViewDiffableDataSource<SettingCategory, KakaoSetting>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(settingCollectionView)
        settingCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        configureDataSource()
        updateSnapshot()
    }
    
    private func configureDataSource() {
        var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, KakaoSetting>
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            // CollectionView SystemCell
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.textProperties.color = .white
            content.textProperties.font = .systemFont(ofSize: 12)
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .clear
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: settingCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        let headerRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell>
        headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self else { return }
            let headerITem = dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            
            var config = supplementaryView.defaultContentConfiguration()
            config.text = headerITem?.title
            config.textProperties.font = .systemFont(ofSize: 16)
            config.textProperties.color = .systemGray
            supplementaryView.contentConfiguration = config
        }
        
        dataSource?.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    private func updateSnapshot() {
        let settingCategories = SettingCategory.allCases
        
        // 1. snapshot 생성
        var snapshot = NSDiffableDataSourceSnapshot<SettingCategory, KakaoSetting>()
        
        // 2. section 추가
        snapshot.appendSections(settingCategories)
        
        // 3. 어떤 section에 어떤 data를 보여줄 것인가?
        settingCategories.forEach { snapshot.appendItems($0.detail, toSection: $0) }
        
        // 4. 사용할 데이터를 dataSource에 전달
        dataSource?.apply(snapshot)
    }
}
