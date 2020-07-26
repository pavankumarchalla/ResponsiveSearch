//
//  BooksViewController.swift
//  ResponsiveSearch
//
//  Created by Pavan Kumar on 27/07/20.
//  Copyright © 2020 Tarkalabs. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var books = Books.getAllBooks()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.tableFooterView = UIView()
    self.tableView.estimatedRowHeight = UITableView.automaticDimension
  }
  
  //MARK:- UITableview Delegate and Datasource methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return books.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BooksTableViewCell", for: indexPath) as! BooksTableViewCell
    cell.loadData(book: books[indexPath.row])
    return cell
  }
  
  
}

