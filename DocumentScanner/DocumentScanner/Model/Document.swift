//
//  Document.swift
//  DocumentScanner
//
//  Created by 엄기철 on 1/14/25.
//

import SwiftUI
import SwiftData

@Model
class Document {
  var name: String
  var createdAt: Date = Date()
  @Relationship(deleteRule: .cascade, inverse: \DocumentPage.document)
  var pages: [DocumentPage]?
  var isLocked: Bool = false
  // For Zoom Transition
  var uniqueViewID: String = UUID().uuidString

  /*
   Ensure that you've included the"cascade" delete rule for the document.This rule will ensure that all theassociated pages are deleted when thedocument is deleted.
   */
  init(name: String, pages: [DocumentPage]? = nil) {
    self.name = name
    self.createdAt = createdAt
    self.pages = pages
  }
}
