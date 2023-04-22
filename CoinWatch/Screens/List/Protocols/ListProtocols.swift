//
//  ListProtocols.swift
//  CoinWatch
//
//  Created by Anıl Kul on 18.04.2023.
//

import Foundation

protocol ListViewModelProtocol: BaseViewModelProtocol, PairListCellDelegate, FavoriteListHorizontalCellDelegate {
    var reloadData: VoidHandler? { get set }
    var routingDelegate: DetailRoutingDelegate? { get set }
    
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func presentationObject(at indexPath: IndexPath) -> BaseCellPresentable
    func requestPairList(_ completion: VoidHandler?)
    func isFavoritesSectionActive() -> Bool
    func willDisplayCell(at indexPath: IndexPath)
}

protocol BaseCellPresentable: AnyObject {
    var type: ItemType { get set }
}

protocol PairFavoritable: BaseCellPresentable {
    var name: String { get }
    var symbol: String { get }
    var last: String { get }
    var dailyPercent: String { get }
    var percentageColorName: String { get }
}

protocol PairPresentable: PairFavoritable {
    var isFavorite: Bool { get set }
    var volume: String { get }
    var numeratorSymbol: String { get }
}

protocol FavoriteListPresentable: BaseCellPresentable {
    var favorites: [PairFavoritable] { get set }
}

// MARK: - Delegates
protocol DetailRoutingDelegate: AnyObject {
    func navigateToDetail(with viewModel: DetailViewModelProtocol)
}

protocol FavoriteListHorizontalCellDelegate: AnyObject {
    func didReceive(action: CellAction, presentationObject: PairFavoritable)
}

protocol FavoriteCellDelegate: AnyObject {
    func didReceive(action: CellAction, presentationObject: PairFavoritable)
}
