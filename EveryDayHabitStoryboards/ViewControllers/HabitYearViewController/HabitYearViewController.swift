//
//  ViewController.swift
//  EveryDayHabitStoryboards
//
//  Created by Vladislav Dorfman on 14/11/2020.
//

import UIKit

struct HabitContentConfiguration: UIContentConfiguration, Hashable {
    var name: String?
    var nameColor: UIColor?
    var fontWeight: UIFont.Weight?
    
    func makeContentView() -> UIView & UIContentView {
        return HabitContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> HabitContentConfiguration {
        // Perform update on parameters that does not related to cell's data itesm
            
            // Make sure we are dealing with instance of UICellConfigurationState
            guard let state = state as? UICellConfigurationState else {
                return self
            }
            
            // Updater self based on the current state
            var updatedConfiguration = self
            if state.isSelected {
                // Selected state
                updatedConfiguration.nameColor = .systemPink
                updatedConfiguration.fontWeight = .heavy
            } else {
                // Other states
                updatedConfiguration.nameColor = .systemBlue
                updatedConfiguration.fontWeight = .regular
            }

            return updatedConfiguration
    }
}

class HabitContentView: UIView, UIContentView {
    private var currentConfiguration: HabitContentConfiguration!
        var configuration: UIContentConfiguration {
            get {
                currentConfiguration
            }
            set {
                // Make sure the given configuration is of type SFSymbolContentConfiguration
                guard let newConfiguration = newValue as? HabitContentConfiguration else {
                    return
                }
                
                // Apply the new configuration to SFSymbolVerticalContentView
                // also update currentConfiguration to newConfiguration
                apply(configuration: newConfiguration)
            }
        }
    
    let nameLabel = UILabel()
    let symbolImageView = UIImageView()
    
    // We will work on the implementation in a short while.
    
    init(configuration: HabitContentConfiguration) {
        super.init(frame: .zero)
        
        // Create the content view UI
        setupAllViews()
        
        // Apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HabitContentView {
    
    private func setupAllViews() {
        
        // Add stack view to content view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
        
        // Add image view to stack view
        symbolImageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(symbolImageView)
        
        // Add label to stack view
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.2
        
        stackView.addArrangedSubview(nameLabel)
    }
    
    private func apply(configuration: HabitContentConfiguration) {
    
        // Only apply configuration if new configuration and current configuration are not the same
        guard currentConfiguration != configuration else {
            return
        }
        
        // Replace current configuration with new configuration
        currentConfiguration = configuration
        
        // Set data to UI elements
        nameLabel.text = configuration.name
        nameLabel.textColor = configuration.nameColor
        
        // Set font weight
        if let fontWeight = configuration.fontWeight {
            nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font.pointSize,
                                               weight: fontWeight)
        }
    }
}

typealias Snapshot = NSDiffableDataSourceSnapshot<HabitMonth, HabitDay>

class HabitYearViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var year: HabitYear = HabitYear(year: 2017)!
    var dataSource: UICollectionViewDiffableDataSource<HabitMonth, HabitDay>?
    var snapshot: NSDiffableDataSourceSnapshot<HabitMonth, HabitDay>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        self.title = "\(year.year)"
    }
 
    
    private func createLayout() -> UICollectionViewLayout {
        let verticalItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/31))
        
        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/CGFloat(year.months.count)),
            heightDimension: .fractionalHeight(1))
        
        let verticalItem = NSCollectionLayoutItem(layoutSize: verticalItemSize)
        
        let footerHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/CGFloat(year.months.count)),
            heightDimension: .estimated(50.0))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
            config.scrollDirection = .horizontal

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionNumber, env -> NSCollectionLayoutSection? in
            
            guard sectionNumber < self.year.months.count else { return nil }
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: verticalGroupSize,
                subitem: verticalItem,
                count: 31)//self.year.months[sectionNumber].days.count)
            
            verticalGroup.interItemSpacing = .fixed(8)
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.interGroupSpacing = 8
//            section.orthogonalScrollingBehavior = .c
            section.boundarySupplementaryItems = [header]

           return section
        }, configuration: config)
        
        return layout
    }
    

    
    func setupCollectionView() {
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.register(
          HabitMonthSectionHeaderView.self,
          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: HabitMonthSectionHeaderView.reuseIdentifier
        )
        
        
        let dayCellConfig = UICollectionView.CellRegistration<HabitDayCell, HabitDay> { (cell, indexPath, model) in
            cell.model = model
        }
        
        
        dataSource = UICollectionViewDiffableDataSource<HabitMonth, HabitDay>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: HabitDay) -> UICollectionViewCell? in
            
            // Dequeue reusable cell using cell registration (Reuse identifier no longer needed)
            let cell = collectionView.dequeueConfiguredReusableCell(using: dayCellConfig,
                                                                    for: indexPath,
                                                                    item: identifier)
            
            return cell
        }
            
            // Create a snapshot that define the current state of data source's data
        snapshot = Snapshot()
        snapshot?.appendSections(year.months)
        year.months.forEach {
            
            snapshot?.appendItems($0.days, toSection: $0)
        }
        
        dataSource?.apply(snapshot!, animatingDifferences: false)
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
          // 2
          guard kind == UICollectionView.elementKindSectionHeader else {
            return nil
          }
          // 3
          let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HabitMonthSectionHeaderView.reuseIdentifier,
            for: indexPath) as? HabitMonthSectionHeaderView
          // 4
          let section = self.dataSource?.snapshot()
            .sectionIdentifiers[indexPath.section]
            
          view?.titleLabel.text = section?.name
          return view
        }
        
        collectionView.dataSource = dataSource
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return year.months.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return year.months[section].days.count
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        year.months[indexPath.section].days[indexPath.item].isHabitTrained = true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        let alertController = UIAlertController(title: "Change habit for \(year.year) \(year.months[indexPath.section].name) \(year.months[indexPath.section].days[indexPath.item].num)?", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Untrain", style: .destructive, handler: { (action) in
            self.year.months[indexPath.section].days[indexPath.item].isHabitTrained = false
            collectionView.deselectItem(at: indexPath, animated: true)
        }))
        
        if let popoverController = alertController.popoverPresentationController,
           let cell = collectionView.cellForItem(at: indexPath) {
            popoverController.sourceView = self.collectionView
            popoverController.sourceRect = cell.frame
         }
        
        self.present(alertController, animated: true, completion: nil)
        
        return false
    }
}

