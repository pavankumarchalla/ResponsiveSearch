//
//  Books.swift
//  ResponsiveSearch
//
//  Created by Pavan Kumar on 27/07/20.
//  Copyright © 2020 Tarkalabs. All rights reserved.
//

import Foundation

struct Book {
  var title: String
  var author: String
}


class Books {
  
  static func getAllBooks() -> [Book] {
    var books = [Book]()
    books.append(Book(title: "Do Androids Dream of Electric Sheep? (Blade Runner, #1)", author: "Philip K. Dick"))
    books.append(Book(title: "The Hitchhiker's Guide to the Galaxy (Hitchhiker's Guide to the Galaxy, #1)", author: "Douglas Adams"))
    books.append(Book(title: "Something Wicked This Way Comes (Green Town, #2)", author: "Ray Bradbury"))
    books.append(Book(title: "Pride and Prejudice and Zombies (Pride and Prejudice and Zombies, #1)", author: "Seth Grahame-Smith"))
    books.append(Book(title: "The Curious Incident of the Dog in the Night-Time", author: "Mark Haddon"))
    books.append(Book(title: "I Was Told There'd Be Cake", author: "Sloane Crosley"))
    books.append(Book(title: "To Kill a Mockingbird", author: "Harper Lee"))
    books.append(Book(title: "The Unbearable Lightness of Being", author: "Milan Kundera"))
    books.append(Book(title: "Eats, Shoots & Leaves: The Zero Tolerance Approach to Punctuation", author: "Lynne Truss"))
    books.append(Book(title: "The Hollow Chocolate Bunnies of the Apocalypse", author: "Robert Rankin"))
    books.append(Book(title: "Are You There, Vodka? It's Me, Chelsea", author: "Chelsea Handler"))
    return books
  }
  
}
