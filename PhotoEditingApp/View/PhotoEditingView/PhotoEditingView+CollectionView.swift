import UIKit

extension PhotoEditingView {
    func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout =  UICollectionViewCompositionalLayout { (
            sectionIndex: Int,
            layoutEnv: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 2)
            group.interItemSpacing = .fixed(16)

            let section = NSCollectionLayoutSection(group: group)

            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 16,
                                                            bottom: 0,
                                                            trailing: 16)

            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        layout.configuration = config
        return layout

    }
}
