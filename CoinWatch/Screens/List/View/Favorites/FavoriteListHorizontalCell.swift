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
    weak var delegate: FavoriteListHorizontalCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        let identifier = String(describing: FavoriteCell.self)
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func populate(presentationObject: FavoriteListPresentable) {
        self.presentationObject = presentationObject
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
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
        cell.delegate = self
        return cell
    }
    
}

extension FavoriteListHorizontalCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ItemType.favorite.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 24, bottom: 0, right: 24)
    }
}

extension FavoriteListHorizontalCell: FavoriteCellDelegate {
    func didReceive(action: CellAction, presentationObject: PairFavoritable) {
        delegate?.didReceive(action: action, presentationObject: presentationObject)
    }
}

protocol FavoriteListHorizontalCellDelegate: AnyObject {
    func didReceive(action: CellAction, presentationObject: PairFavoritable)
}
