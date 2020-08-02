//
//  BooksViewController.swift
//  ResponsiveSearch
//
//  Created by Pavan Kumar on 27/07/20.
//  Copyright © 2020 Tarkalabs. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
  
  @IBOutlet weak var tableView: UITableView!
  
  let searchController = UISearchController(searchResultsController: nil)
  var books = Books.getAllBooks()
  var filteredBooks = [Book]()
  var searchTimer: Timer?
  var searchTask: DispatchWorkItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.searchController.searchResultsUpdater = self
    self.searchController.obscuresBackgroundDuringPresentation = false
    self.searchController.hidesNavigationBarDuringPresentation = false
    
    self.tableView.tableHeaderView = searchController.searchBar
    self.tableView.tableFooterView = UIView()
    self.tableView.estimatedRowHeight = UITableView.automaticDimension
  }
  
  //MARK:- UITableview Delegate and Datasource methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.isActive && searchController.searchBar.text != "" {
      return filteredBooks.count
    }
    return books.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BooksTableViewCell", for: indexPath) as! BooksTableViewCell
    if searchController.isActive && searchController.searchBar.text != "" {
      cell.loadData(book: filteredBooks[indexPath.row])
    } else {
      cell.loadData(book: books[indexPath.row])
    }
    return cell
  }
  
  //MARK:- Search delegate methods
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else { return }
//    applyTimerSearch(searchText: searchText)
    applyDispatchSearch(searchText: searchText)
  }
  
  //MARK:- Custom Methods
  
  private func applyTimerSearch(searchText: String) {
    self.searchTimer?.invalidate()
    /// 0.5 is the wait or idle time for execution of the function applyFilter
    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (timer) in
      self?.applyFilter(with: searchText)
    })
  }
  
  private func applyDispatchSearch(searchText: String) {
    self.searchTask?.cancel()
    
    let task = DispatchWorkItem { [weak self] in
      self?.applyFilter(with: searchText)
    }
    self.searchTask = task
    
    /// 0.5 is the wait or idle time for execution of the function applyFilter
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
  }
  
  /*
   We are implementing a wildcard search so we would split the searchtext into multiple words and search each word in the sentance searchDesc
   */
  private func applyFilter(with searchText: String) {
    /// Making sure the query is not running on the main thread
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let weakself = self else { return }
      let searchWords = searchText.lowercased().split(separator: " ").map({ String($0) })
      weakself.filteredBooks = weakself.books.filter({ (book) -> Bool in
        let searchDesc = "\(book.author) \(book.title)"
        return searchWords.first(where: { !searchDesc.lowercased().contains($0) }) == nil
      })
      
      /// Updating the UI in main thread
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
  }
  
}

