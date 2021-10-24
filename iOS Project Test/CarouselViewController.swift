//
//  ViewController.swift
//  iOS Project Test
//
//  Created by Ardyan on 22/10/21.
//

import UIKit

class CarouselViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    @IBOutlet weak var loadingProgresBar: UIProgressView!
    @IBOutlet weak var loadingStackView: UIStackView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    private var viewModels = [NewsCollectionViewCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Popular News"
        loadingActivityIndicator.startAnimating()
        loadingProgresBar.isHidden = true
        loadingProgresBar.progress = 0
        newsCollectionView.register(UINib.init(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionViewCell")
        
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 60.0, height: newsCollectionView.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 0.8
        flowLayout.sideItemAlpha = 1.0
        flowLayout.spacingMode = .fixed(spacing: 5.0)
        newsCollectionView.collectionViewLayout = flowLayout
        
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        
        NewsArticleAPI.shared.getMostViewed { [weak self] result in
            switch result {
            case .success(let articles):
                self?.viewModels = articles.compactMap({
                    var image = ""
                    if $0.media.count > 0 {
                        for media in $0.media[0]?.mediaMetadata ?? [] {
                            if media.format == "mediumThreeByTwo440" {
                                image = media.url ?? ""
                            }
                        }
                    }
                    return NewsCollectionViewCellModel(
                        id: $0.id ?? 0,
                        title: $0.title,
                        abstract: $0.abstract ?? "No abstract",
                        imageURL: URL(string: image)
                    )
                })

                DispatchQueue.main.async {
                    self?.loadingStackView.isHidden = true
                    self?.newsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - UICollectionVIew Delegates and DataSource
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = newsCollectionView.dequeueReusableCell(
            withReuseIdentifier: "NewsCollectionViewCell",
            for: indexPath
        ) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let selectedVC = storyboard?.instantiateViewController(withIdentifier: "detail_vc") as? DetailViewController else {
            return
        }
        selectedVC.model = viewModels[indexPath.row]
        self.navigationController?.pushViewController(selectedVC, animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.newsCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }

    fileprivate var currentPage: Int = 0 {
        didSet {
//            print("page at centre = \(currentPage)")
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.newsCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
