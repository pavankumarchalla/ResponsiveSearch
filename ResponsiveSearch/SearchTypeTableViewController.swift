//
//  SearchTypeTableViewController.swift
//  ResponsiveSearch
//
//  Created by Pavan Kumar on 09/08/20.
//  Copyright © 2020 Tarkalabs. All rights reserved.
//

import UIKit

enum SearchTypes: Int {
  case timer, dispatchQueue, rxswift, combine
  
  var displayString: String {
    switch self {
    case .timer: return "Timer"
    case .dispatchQueue: return "Dispatch Queue"
    case .rxswift: return "RxSwift"
    case .combine: return "Combine"
    }
  }
}

protocol SearchTypeSelection: class {
  func didSelectFilterAction(_ filter: SearchTypes)
}

class SearchTypeTableViewController: UITableViewController {
  
  weak var delegate: SearchTypeSelection?
  weak var mainContainer: BooksViewController?
  
  var actions: [SearchTypes] = [.timer, .dispatchQueue, .rxswift, .combine]
  
  var currentFilter: SearchTypes?
  
  var selectedBackgroundView: UIView
  
  required init?(coder aDecoder: NSCoder) {
    let view = UIView()
    view.backgroundColor = UIColor(red: 75.0/255, green: 90.0/255, blue: 102.0/255, alpha: 1)
    self.selectedBackgroundView = view
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchActionCell")
  }
  
  //MARK:- Tableview delegate & datasource methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return actions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchActionCell", for: indexPath)
    let action = actions[indexPath.row]
    cell.textLabel?.text = action.displayString
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let action = actions[indexPath.row]
    self.currentFilter = action
    delegate?.didSelectFilterAction(action)
    mainContainer?.hideFilterMenu()
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = UIColor.clear
    cell.selectedBackgroundView = self.selectedBackgroundView
  }
  
}
