//
//  StaticsViewController.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 25/7/24.
//

import UIKit

final class StaticsViewController: BaseViewController {
    
    enum StaticsStae {
        case watchList
        case watched
    }
    
    @IBOutlet private weak var watchedButton: UIButton!
    @IBOutlet private weak var watchListButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var numberWatchListLabel: UILabel!
    @IBOutlet private weak var numberWatchedLabel: UILabel!
    @IBOutlet private weak var chartView: PieChartView!
    
    private var state: StaticsStae = .watchList {
        didSet {
            updateUIState()
        }
    }
    
    private var data: [MovieLocalModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        showMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideMenu()
    }
    
    private func setUpUI() {
        state = .watchList
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchItemCell.self)
        tableView.register(EmptyTableViewCell.self)
    }
    
    private func updateUIState() {
        let isWatchList = state == .watchList
        watchListButton.backgroundColor = isWatchList ? .color19BAFF : .clear
        watchListButton.setTitleColor(isWatchList ? .white : .color19BAFF, for: .normal)
        
        let isWatched = state == .watched
        watchedButton.backgroundColor = isWatched ? .color19BAFF : .clear
        watchedButton.setTitleColor(isWatched ? .white : .color19BAFF, for: .normal)
        fetchData()
    }
    
    private func fetchData() {
        data = CoreDataStatistics.shared.fetch(isWatched: state == .watched)
        let numberWatched = CoreDataStatistics.shared.fetch(isWatched: true).count
        let numberWatchList = CoreDataStatistics.shared.fetch(isWatched: false).count
        numberWatchedLabel.text = "\(numberWatched)"
        numberWatchListLabel.text = "\(numberWatchList)"
        chartView.colors = [.color19BAFF, .colorFF0B8F]
        chartView.values = [CGFloat(numberWatched), CGFloat(numberWatchList)]
        reloadData()
    }
    
    private func reloadData() {
        mainAsync { [weak self] in
            self?.tableView.reloadData()
        }
    }

    @IBAction func watchedClick(_ sender: Any) {
        state = .watched
    }
    
    @IBAction func watchListClick(_ sender: Any) {
        state = .watchList
    }
}

extension StaticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return data.isEmpty ? 1 : data.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if data.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier,
                                                           for: indexPath) as? EmptyTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchItemCell.reuseIdentifier,
                                                       for: indexPath) as? SearchItemCell else {
            return UITableViewCell()
        }
        cell.configLocal(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if data.isEmpty {
            return
        }
        let searchItem = SearchModel(movieLocal: data[indexPath.row])
        let vc = MovieDetailViewController(item: searchItem)
        push(vc)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
