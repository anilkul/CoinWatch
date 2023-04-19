//
//  ListViewModel.swift
//  CoinWatch
//
//  Created by Anıl Kul on 18.04.2023.
//

import Foundation

final class ListViewModel: ListViewModelProtocol {
    private let dataProvider: ListViewDataProvidable
    private var dataSource: [[PairPresentationObject]] = []
    private let pageSize: Int = 20
    
    init(dataProvider: ListViewDataProvidable) {
        self.dataProvider = dataProvider
        dataProvider.requestPairs { [weak self] response in
            switch response {
            case .success(let contentList):
                self?.parse(contentList)
            case .failure(let error):
                #if DEBUG
                print(APIError.apiError(error: error))
                #endif
            }
        }
    }
    
    private func parse(_ list: PairList) {
        dataSource.append(list.data.map { PairPresentationObject(pair: $0) })
    }
}
