//
//  DiffableTravelTalkViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/18/24.
//

import UIKit

import SnapKit

fileprivate struct ChatRoom: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let chat: String
    let chatDate: String
    
    static let list: [ChatRoom] = [
        ChatRoom(name: "Hue", chat: "왜요? 요즘 코딩이 대세인데", chatDate: "24.01.12"),
        ChatRoom(name: "Jack", chat: "깃허브는 푸시하셨나여?", chatDate: "24.01.12"),
        ChatRoom(name: "Bran", chat: "과제 화이팅!", chatDate: "24.01.11"),
        ChatRoom(name: "Den", chat: "벌써 퇴근하세여?ㅎㅎㅎㅎㅎ", chatDate: "24.01.10"),
        ChatRoom(name: "내옆자리의앞자리에개발잘하는친구", chat: "내일 모닝콜 해주실분~~", chatDate: "24.01.09"),
        ChatRoom(name: "심심이", chat: "아닛 주말과제라닛", chatDate: "24.01.08")
    ]
}

final class DiffableTravelTalkViewController: BaseViewController {
    private let chatCollectionView: UICollectionView = {
        // 1. systemCell 형태의 Cell 구성
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        configuration.showsSeparators = false
        // 2. layout 설정
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        // 3. collectionView 생성
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<String, ChatRoom>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(chatCollectionView)
        chatCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        configureDataSource()
        updateSnapshot()
    }
    
    private func configureDataSource() {
        // 1. 셀 구성
        var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ChatRoom>
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.image = UIImage(named: itemIdentifier.name)
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            content.imageProperties.reservedLayoutSize = CGSize(width: 50, height: 50)
            content.imageProperties.cornerRadius = content.imageProperties.reservedLayoutSize.width / 2
            
            content.text = itemIdentifier.name
            content.textProperties.font = .boldSystemFont(ofSize: 16)
            
            content.secondaryText = itemIdentifier.chat
            content.secondaryTextProperties.font = .boldSystemFont(ofSize: 14)
            content.secondaryTextProperties.color = .systemGray
            content.prefersSideBySideTextAndSecondaryText = false
            
            cell.contentConfiguration = content
        }
        
        // 셀 사용
        dataSource = UICollectionViewDiffableDataSource(collectionView: chatCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    private func updateSnapshot() {
        // 1. snapshot 생성
        var snapshot = NSDiffableDataSourceSnapshot<String, ChatRoom>()
        
        // 2. section 추가
        snapshot.appendSections(["first"])
        
        // 3. section에 어떤 데이터 보여줄 것인지 추가
        snapshot.appendItems(ChatRoom.list, toSection: "first")
        
        // 4. 사용할 데이터를 dataSource에 전달
        dataSource?.apply(snapshot)
    }
}
