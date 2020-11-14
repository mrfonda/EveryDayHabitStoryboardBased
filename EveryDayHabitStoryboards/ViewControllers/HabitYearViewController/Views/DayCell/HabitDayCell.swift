//
//  HabitDayCell.swift
//  EveryDayHabitStoryboards
//
//  Created by Vladislav Dorfman on 14/11/2020.
//

import UIKit


class HabitDayCell: UICollectionViewCell {
    var model: HabitDay?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let model = model else { return }
        isSelected = model.isHabitTrained
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
            
        // Create new configuration object and update it base on state
        var newConfiguration = HabitContentConfiguration().updated(for: state)
        
        // Update any configuration parameters related to data item
        newConfiguration.name = "\(model!.num)"
        
        var newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        newBgConfiguration.backgroundColor = state.isSelected ? .systemGreen : .systemBackground
        
        backgroundConfiguration = newBgConfiguration
        
        // Set content configuration in order to update custom content view
        contentConfiguration = newConfiguration
        
    }
}
