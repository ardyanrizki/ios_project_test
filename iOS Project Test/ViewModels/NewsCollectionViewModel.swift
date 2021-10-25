//
//  NewsCollectionViewModel.swift
//  iOS Project Test
//
//  Created by Ardyan on 25/10/21.
//

import UIKit

class NewsCollectionViewCellModel {
    let id: Int
    let title: String
    let abstract: String
    let imageURL: URL?
    let imageData: Data? = nil
    
    init (
        id: Int,
        title: String,
        abstract: String,
        imageURL: URL?
    ) {
        self.id = id
        self.title = title
        self.abstract = abstract
        self.imageURL = imageURL
    }
}
