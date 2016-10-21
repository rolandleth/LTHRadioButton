//
//  RadioCell.swift
//  RadioButtonDemo
//
//  Created by Roland Leth on 19.10.2016.
//  Copyright © 2016 Roland Leth. All rights reserved.
//

import UIKit

class RadioCell: UITableViewCell {
	
	private let selectedColor   = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
	private let deselectedColor = UIColor.lightGray
	
	private lazy var radioButton: LTHRadioButton = {
		let r = LTHRadioButton()
		self.contentView.addSubview(r)
		
		r.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			r.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
			r.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
			r.heightAnchor.constraint(equalToConstant: r.frame.height),
			r.widthAnchor.constraint(equalToConstant: r.frame.width)]
		)
		
		return r
	}()
	
	func update(with color: UIColor) {
		backgroundColor             = color
		radioButton.selectedColor   = color == .darkGray ? .white : selectedColor
		radioButton.deselectedColor = color == .darkGray ? .lightGray : deselectedColor
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		if selected {
			return radioButton.select(animated: animated)
		}
		
		radioButton.deselect(animated: animated)
	}
}
