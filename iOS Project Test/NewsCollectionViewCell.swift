//
//  NewsCollectionViewCell.swift
//  iOS Project Test
//
//  Created by Ardyan on 23/10/21.
//

import UIKit

class NewsCollectionViewCellViewModel {
    let title: String
    let abstract: String
    let imageURL: URL?
    let imageData: Data? = nil
    
    init (
        title: String,
        abstract: String,
        imageURL: URL?
    ) {
        self.title = title
        self.abstract = abstract
        self.imageURL = imageURL
    }
}

class NewsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewsCollectionViewCell"
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsAbstractLabel: UILabel!
    @IBOutlet weak var newsImageView : UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        self.prepareForReuse()
    }
    
    func configure(with viewModel: NewsCollectionViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        newsAbstractLabel.text = viewModel.abstract
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let imageUrl = viewModel.imageURL {
            getData(from: imageUrl) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.newsImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}
