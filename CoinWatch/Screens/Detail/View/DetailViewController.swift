//
//  DetailViewController.swift
//  CoinWatch
//
//  Created by Anıl Kul on 21.04.2023.
//

import UIKit
import Charts

final class DetailViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet private weak var lineChartView: LineChartView!
    
    // MARK: - Variables
    var viewModel: DetailViewModelProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        fetchChart()
    }
    
    // MARK: - UI Operations
    private func setupNavigationBar() {
        title = viewModel.navigationBarTitle()
        let yourBackImage = UIImage(systemName: "arrow.backward")
        navigationController?.navigationBar.backIndicatorImage = yourBackImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationController?.navigationBar.topItem?.title = .empty
        navigationController?.navigationBar.tintColor = UIColor(named: "MainLabelColor")
    }
    
    private func fetchChart() {
        showActivityIndicator()
        viewModel.requestChartData { [weak self] entries in
            guard let self else {
                return
            }
            self.hideActivityIndicator()
            DispatchQueue.main.async {
                self.setupChartView(data: entries)
            }
        }
    }
    
    private func setupChartView(data: [ChartDataEntry]) {
        let dataSet = LineChartDataSet(entries: data, label: "Time-Close")
        dataSet.lineWidth = 2.0
        dataSet.setColor(NSUIColor(named: "ChartLineColor")!)
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        
        let gradientColors = [NSUIColor(named: "ChartLineColor")!.cgColor,
                              NSUIColor(named: "ChartBackgroundColor")!.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: [1.0, 0.0])!
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        
        let chartData = LineChartData(dataSet: dataSet)
        lineChartView.data = chartData
        
        lineChartView.rightAxis.labelTextColor = NSUIColor(named: "MainLabelColor")!
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.extraTopOffset = 15
        lineChartView.extraBottomOffset = 20
        lineChartView.minOffset = 0
        lineChartView.legend.enabled = false
        lineChartView.backgroundColor = NSUIColor(named: "ChartBackgroundColor")!

        lineChartView.notifyDataSetChanged()
    }
}
