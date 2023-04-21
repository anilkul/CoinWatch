//
//  ListProtocols.swift
//  CoinWatch
//
//  Created by Anıl Kul on 18.04.2023.
//

import Foundation

protocol ListViewModelProtocol: PairListCellDelegate, FavoriteListHorizontalCellDelegate {
    var reloadData: VoidHandler? { get set }
    var routingDelegate: DetailRoutingDelegate? { get set }
    
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func presentationObject(at indexPath: IndexPath) -> BaseCellPresentable
    func requestPairList(_ completion: VoidHandler?)
    func isFavoritesSectionActive() -> Bool
    func willDisplayCell(at indexPath: IndexPath)
}
