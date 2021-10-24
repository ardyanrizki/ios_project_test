//
//  ViewController.swift
//  iOS Project Test
//
//  Created by Ardyan on 22/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var newsModel = [NewsCollectionViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Most Viewed News"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        
        NewsArticleAPI.shared.getMostViewed { [weak self] result in
            switch result {
            case .success(let articles):
                self?.newsModel = articles.compactMap({
                    var image = ""
                    if $0.media.count > 0 {
                        image = $0.media[0]?.mediaMetadata?[0].url ?? ""
                    }
                    return NewsCollectionViewCellViewModel(
                        title: $0.title,
                        abstract: $0.abstract ?? "No abstract",
                        imageURL: URL(string: image)
                    )
                })

                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }


}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewsCollectionViewCell.identifier,
            for: indexPath
        ) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: newsModel[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsModel.count
    }
}

