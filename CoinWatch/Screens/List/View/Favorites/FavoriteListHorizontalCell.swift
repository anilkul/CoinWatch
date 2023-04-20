//
//  FavoriteListHorizontalCell.swift
//  CoinWatch
//
//  Created by Anıl Kul on 20.04.2023.
//

import UIKit

class FavoriteListHorizontalCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var presentationObject: FavoriteListPresentable!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let identifier = String(describing: FavoriteCell.self)
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func populate(presentationObject: FavoriteListPresentable) {
        self.presentationObject = presentationObject
        self.collectionView.dataSource = self
    }
}

extension FavoriteListHorizontalCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presentationObject.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FavoriteCell.self), for: indexPath) as? FavoriteCell
        else {
          fatalError()
        }
        let presentationObject = presentationObject.favorites[indexPath.row]
        cell.populate(presentationObject: presentationObject)
        return cell
    }
    
}
