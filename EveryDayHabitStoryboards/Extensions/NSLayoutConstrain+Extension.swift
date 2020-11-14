//
//  NSLayoutConstrain+Extension.swift
//  EveryDayHabitStoryboards
//
//  Created by Vladislav Dorfman on 14/11/2020.
//

import UIKit

extension UIView {
    @discardableResult
    @objc func constrainToTopOfSuperView(_ padding: CGFloat) -> [NSLayoutConstraint] {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[item]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["padding" : padding], views: ["item" : self])
        self.superview?.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    @objc func constrainToLeftOfSuperView(_ padding: CGFloat) -> [NSLayoutConstraint] {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[item]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["padding" : padding], views: ["item" : self])
        self.superview?.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    @objc func constrainToBottomOfSuperView(_ padding: CGFloat) -> [NSLayoutConstraint] {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[item]-padding-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["padding" : padding], views: ["item" : self])
        self.superview?.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    func constrainToBottomOfSuperView(_ padding: CGFloat, priority: UILayoutPriority) -> [NSLayoutConstraint] {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[item]-padding-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["padding" : padding], views: ["item" : self])
        constraints.first!.priority = priority
        self.superview?.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    @objc func constrainToRightOfSuperView(_ padding: CGFloat) -> [NSLayoutConstraint] {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[item]-padding-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["padding" : padding], views: ["item" : self])
        self.superview?.addConstraints(constraints)
        return constraints
    }
    
    func addSubviewAndAlignByConstrains(_ view: UIView, on edges: UIRectEdge = .all, with insets: UIEdgeInsets = .zero) {
        view.addAsSubviewAndAlignByConstrains(in: self, on: edges, with: insets)
    }
    
    func addAsSubviewAndAlignByConstrains(in superView: UIView, on edges: UIRectEdge = .all, with insets: UIEdgeInsets = .zero) {
        superView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if edges.contains(.top) || edges.contains(.all) {
            constrainToTopOfSuperView(insets.top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            constrainToLeftOfSuperView(insets.left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            constrainToRightOfSuperView(insets.right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            constrainToBottomOfSuperView(insets.bottom)
        }
    }
}
