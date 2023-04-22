//
//  DetailViewModel.swift
//  CoinWatch
//
//  Created by Anıl Kul on 21.04.2023.
//

import Foundation
import Charts

protocol DetailViewModelProtocol: BaseViewModelProtocol {
    func requestChartData(_ completion: @escaping ([ChartDataEntry]) -> Void)
    func navigationBarTitle() -> String
}

final class DetailViewModel: BaseViewModel, DetailViewModelProtocol {
    // MARK: - Variables
    private let dataProvider: DetailViewDataProvidable
    private let symbol: String
    private let name: String
    
    // MARK: - Initialization
    init(name: String, symbol: String, dataProvider: DataProvidable) {
        if let dataProvider = dataProvider as? DetailViewDataProvidable {
            self.dataProvider = dataProvider
        } else {
            self.dataProvider = DataProvider()
        }
        self.symbol = symbol
        self.name = name
    }
    
    func navigationBarTitle() -> String {
        return name + " Chart"
    }
    
    // MARK: - Chart Operations
    func requestChartData(_ completion: @escaping ([ChartDataEntry]) -> Void) {
        dataProvider.fetchChart(for: symbol) { [weak self] response in
            guard let self else {
                return
            }
            switch response {
            case .success(let chartData):
                let entries = self.parsed(chartData)
                completion(entries)
            case .failure(let error):
                self.errorLogger.logError(APIError.apiError(error: error))
            }
        }
    }
    
    private func parsed(_ chartData: ChartDataModel) -> [ChartDataEntry] {
        let entries = zip(chartData.time, chartData.close).map { ChartDataEntry(x: $0, y: $1) }
        return entries
    }
}
