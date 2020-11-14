//
//  HabitMonthSectionHeaderView.swift
//  EveryDayHabitStoryboards
//
//  Created by Vladislav Dorfman on 14/11/2020.
//

import UIKit

class HabitMonthSectionHeaderView: UICollectionReusableView {
    static var reuseIdentifier: String {
       return String(describing: HabitMonthSectionHeaderView.self)
     }

     // 2
     lazy var titleLabel: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.font = UIFont.systemFont(
         ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize,
         weight: .bold)
       label.adjustsFontForContentSizeCategory = true
       label.textColor = .label
       label.textAlignment = .left
       label.numberOfLines = 1
       label.setContentCompressionResistancePriority(
         .defaultHigh,
         for: .horizontal)
       return label
     }()
     
    
    func commonInit() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                                            titleLabel.leadingAnchor.constraint(
                                                equalTo: leadingAnchor,
                                                constant: 5),
                                            titleLabel.trailingAnchor.constraint(
                                                lessThanOrEqualTo: trailingAnchor,
                                                constant: -5)])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(
                    equalTo: readableContentGuide.leadingAnchor),
                titleLabel.trailingAnchor.constraint(
                    lessThanOrEqualTo: readableContentGuide.trailingAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10)
        ])
    }
    

     override init(frame: CGRect) {
       super.init(frame: frame)
       commonInit()
     }
 
     
     required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
     }
}
