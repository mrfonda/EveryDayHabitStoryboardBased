//
//  CalendarLayout.swift
//  EveryDayHabitStoryboards
//
//  Created by Vladislav Dorfman on 14/11/2020.
//

import UIKit

class CalendarLayout: UICollectionViewLayout {

}

class RulesLayout: UICollectionViewLayout {

let CELL_HEIGHT = 30.0
let CELL_WIDTH = 100.0

let horizontalSpacing = 5.0
let verticalSpaing = 5.0
let headerSpacing = 40.0

let STATUS_BAR = UIApplication.shared.statusBarFrame.height

var portrait_Ypos : Double = 0.0

var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
var contentSize = CGSize.zero

var dataSourceDidUpdate = true

override var collectionViewContentSize : CGSize {
    return self.contentSize
}


override func prepare() {

    dataSourceDidUpdate = false

    if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    {
        if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
            for section in 0...sectionCount-1 {

                let xPos = (Double(section) * CELL_WIDTH) + (Double(section) * horizontalSpacing)
                var yPos : Double = 0.0
                if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
                    for item in 0...rowCount-1 {

                        let cellIndex = IndexPath(item: item, section: section)

                        if item == 0
                        {
                            portrait_Ypos = headerSpacing
                        }
                        else
                        {
                            portrait_Ypos = portrait_Ypos + CELL_HEIGHT + verticalSpaing
                        }

                        yPos = portrait_Ypos

                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)

                        // Determine zIndex based on cell type.
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        cellAttrsDictionary[cellIndex] = cellAttributes

                    }

                }

            }
        }

        let contentWidth = Double(collectionView!.numberOfSections) * CELL_WIDTH + (Double(collectionView!.numberOfSections - 1) * horizontalSpacing)
        let contentHeight = Double(collectionView!.numberOfSections) * CELL_HEIGHT
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)

        print("self.contentSizeself.contentSize     ", self.contentSize)
    }
    else
    {
        if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {

            for section in 0...sectionCount-1 {

                let xPos = (Double(UIScreen.main.bounds.width) - CELL_WIDTH) / 2.0

                if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
                    for item in 0...rowCount-1 {

                        let cellIndex = IndexPath(item: item, section: section)
                        if section != 0
                        {
                            if item == 0
                            {
                                portrait_Ypos = portrait_Ypos + CELL_HEIGHT + headerSpacing
                            }
                            else
                            {

                                portrait_Ypos = portrait_Ypos + CELL_HEIGHT + verticalSpaing
                            }
                        }
                        else
                        {
                            if item == 0
                            {
                                portrait_Ypos = headerSpacing
                            }
                            else
                            {
                                portrait_Ypos = portrait_Ypos + CELL_HEIGHT + verticalSpaing
                            }
                        }


                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: portrait_Ypos, width: CELL_WIDTH, height: CELL_HEIGHT)


                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        cellAttrsDictionary[cellIndex] = cellAttributes

                    }

                }

            }
        }

        let contentWidth = UIScreen.main.bounds.width
        let contentHeight = CGFloat(portrait_Ypos) + CGFloat(CELL_HEIGHT)
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)

        print("sPort.contentSize     ", self.contentSize)
    }



}

override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    var attributesInRect = [UICollectionViewLayoutAttributes]()

    for cellAttributes in cellAttrsDictionary.values {
        if rect.intersects(cellAttributes.frame) {

            attributesInRect.append(cellAttributes)

            let celIndPth = cellAttributes.indexPath

            if celIndPth.item == 0
            { // YOU HAVE TO ADD SUPPLEMENTARY HEADER TO THIS LAYOUT ATTRIBUTES
                if let supplementaryAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: cellAttributes.indexPath) {
                        attributesInRect.append(supplementaryAttributes)
                }

            }

        }
    }

    return attributesInRect
}

override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

    return cellAttrsDictionary[indexPath]!

}



override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
}


override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

    if elementKind == UICollectionView.elementKindSectionHeader {

        let atts = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)

        if let itemAttributes = layoutAttributesForItem(at: indexPath) { // HERE WE HAVE TO SET FRAME FOR SUPPLEMENTARY VIEW

            atts.frame = CGRect(x: itemAttributes.frame.origin.x,
                                y: itemAttributes.frame.origin.y - CGFloat(headerSpacing),width:  itemAttributes.frame.width,height: CGFloat(headerSpacing))

            return atts
        }
    }

    return nil
}

}
