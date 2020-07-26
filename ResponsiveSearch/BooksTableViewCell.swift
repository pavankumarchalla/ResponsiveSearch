//
//  BooksTableViewCell.swift
//  ResponsiveSearch
//
//  Created by Pavan Kumar on 27/07/20.
//  Copyright © 2020 Tarkalabs. All rights reserved.
//

import UIKit

class BooksTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var authorNameLabel: UILabel!
  
  func loadData(book: Book) {
    self.titleLabel.text = book.title
    self.authorNameLabel.text = book.author
  }
  
}
