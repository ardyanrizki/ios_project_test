//
//  NewsCollectionViewCell.swift
//  iOS Project Test
//
//  Created by Ardyan on 23/10/21.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsAbstract: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.cellView.layer.cornerRadius = 13.0
            self.cellView.layer.masksToBounds = true
            self.newsImage.contentMode = .scaleAspectFill
        }
    }
    
    func configure(with viewModel: NewsCollectionViewCellModel) {
        newsTitle.text = viewModel.title
        newsAbstract.text = viewModel.abstract
        
        if let data = viewModel.imageData {
            newsImage.image = UIImage(data: data)
        }
        else if let imageUrl = viewModel.imageURL {
            getData(from: imageUrl) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.newsImage.image = UIImage(data: data)
                }
            }
        } else {
            self.newsImage.image = UIImage(named: "fallback_img")
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
