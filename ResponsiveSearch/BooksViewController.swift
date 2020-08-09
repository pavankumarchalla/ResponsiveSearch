//
//  BooksViewController.swift
//  ResponsiveSearch
//
//  Created by Pavan Kumar on 27/07/20.
//  Copyright © 2020 Tarkalabs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, SearchTypeSelection {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var booksSearchTypeHeightConstraint: NSLayoutConstraint!
  
  let searchController = UISearchController(searchResultsController: nil)
  var books = Books.getAllBooks()
  var filteredBooks = [Book]()
  var searchTimer: Timer?
  var searchTask: DispatchWorkItem?
  let disposeBag = DisposeBag()
  var searchType = SearchTypes.timer
  var searchMenuTableViewController: SearchTypeTableViewController?

  lazy var blurView: UIView = {
    let view = UIView(frame: self.tableView.frame)
    view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
    let tap = UITapGestureRecognizer(target: self, action: #selector(hideFilterMenu))
    view.addGestureRecognizer(tap)
    return view
  }()

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
    
    switch searchType {
      case .timer:
      applyTimerSearch(searchText: searchText)
      
      case .dispatchQueue:
      applyDispatchSearch(searchText: searchText)
      
      case .rxswift:
      applyRxSwiftSearch(searchText: searchText)
      
      case .combine:
      applyCombineSearch(searchText: searchText)
    }
  }
  
  //MARK:- SearchType methods
  
  func didSelectSearchAction(type: SearchTypes) {
    searchType = type
  }
  
  //MARK:- IBAction methods
  
  @IBAction func menuBtnClicked(_ sender: UIBarButtonItem) {
    if booksSearchTypeHeightConstraint.constant == 0 {
      showFilterMenu()
    } else {
      hideFilterMenu()
    }
  }
  
  //MARK:- Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SearchMenuEmbedSegue" {
      if let _ = self.searchMenuTableViewController {
        return
      }
      
      if let searchTVC = segue.destination as? SearchTypeTableViewController {
        searchTVC.delegate = self;
        searchTVC.mainContainer = self;
        self.searchMenuTableViewController = searchTVC
      }
    }
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
    
  private func applyRxSwiftSearch(searchText: String) {
    searchController.searchBar
    .rx.text // Observable property thanks to RxCocoa
    .debounce(.milliseconds(500), scheduler: MainScheduler.instance) // Wait 0.5 for changes.
    .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value
      self.applyFilter(with: "\(query ?? "")")
    })
    .disposed(by: disposeBag)
  }
  
  private func applyCombineSearch(searchText: String) {
//    var searchstr = ""
//    let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
//    publisher
//      .map {
//        ($0.object as! UISearchTextField).text
//    }
//    .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//    .sink(receiveValue: { (str) in
//      searchstr.append(str ?? "")
//    })
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
  
  func showFilterMenu() {
    if self.booksSearchTypeHeightConstraint.constant == 0 {
      booksSearchTypeHeightConstraint.constant = 176
      self.view.insertSubview(self.blurView, aboveSubview: self.tableView)
      UIView.animate(withDuration: 0.2, animations: { () -> Void in
        self.view.layoutIfNeeded()
      }, completion: { (Bool) -> Void in
        // complete
      })
    }
  }
  
  @objc func hideFilterMenu() {
    if self.booksSearchTypeHeightConstraint.constant != 0 {
      booksSearchTypeHeightConstraint.constant = 0
      self.blurView.removeFromSuperview()
      UIView.animate(withDuration: 0.2, animations: { () -> Void in
        self.view.layoutIfNeeded()
      }, completion: { (Bool) -> Void in
        // complete
      })
    }
  }
  
}
