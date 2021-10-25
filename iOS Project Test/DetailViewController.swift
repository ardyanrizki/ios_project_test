//
//  DetailViewController.swift
//  iOS Project Test
//
//  Created by Ardyan on 24/10/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsAbstract: UILabel!
    
    var model: NewsCollectionViewCellModel?
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        let articleTitle = model?.id
        let urlScheme = "ios-project-test://page=\(articleTitle ?? 0)"
        
        guard let url = URL(string: urlScheme) else {
            return
        }
        
        let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        present(shareSheetVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: model)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure(with: model)
    }
    
    func configure(with viewModel: NewsCollectionViewCellModel?) {
        newsTitle.text = viewModel?.title
        newsAbstract.text = viewModel?.abstract
        
        if let imageUrl = viewModel?.imageURL {
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
