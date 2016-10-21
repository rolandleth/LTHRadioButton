//
//  ViewController.swift
//  RadioButtonDemo
//
//  Created by Roland Leth on 19.10.2016.
//  Copyright © 2016 Roland Leth. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}
	
	
	// MARK: - Cells

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
		                                         for: indexPath) as! RadioCell
		cell.selectionStyle = .none
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		(cell as? RadioCell)?.update(with: indexPath.row % 4 == 0 ? .darkGray : .white)
	}
	
	
	// MARK: - Selection
	
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
		return indexPath
	}
	
	override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
		tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
		return indexPath
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let top = UIApplication.shared.statusBarFrame.height
		tableView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
		tableView.allowsMultipleSelection = false
		tableView.register(RadioCell.self, forCellReuseIdentifier: "cell")
	}
}

