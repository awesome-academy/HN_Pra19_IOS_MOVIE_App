//
//  SearchViewController.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 7/6/24.
//

import UIKit

final class SearchViewController: BaseViewController {
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchIcon: UIImageView!
    
    private var page: Int = 0
    private var totalPages: Int = 1
    private var isLoadMore: Bool = false
    private var canLoadMore: Bool = false
    private var query: String = ""
    private var data: [SearchModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTextField.resignFirstResponder()
    }
    
    private func setUpUI() {
        searchTextField.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchItemCell.self)
        tableView.showLoadMore()
        
        searchIcon.addTapGestureRecognizer { [weak self] _ in
            self?.searchTextField.endEditing(true)
        }
    }
    
    private func getData() {
        guard totalPages >= page + 1, query != "" else {
            return
        }
        page += 1
        
        APIService.shared.getSearch(page: page, query: query) { [weak self] result in
            guard let self = self else { return }
            self.page = result.page
            self.totalPages = result.totalPages
            self.data.append(contentsOf:  result.results)
            
            self.canLoadMore = result.totalPages >= result.page + 1
            self.isLoadMore = false
            self.reloadData()
        } failure: { [weak self] msg in
            guard let self = self else { return }
            self.isLoadMore = false
            ToastView.showToast(message: msg, type: .failed)
        }
    }
    
    private func reloadData() {
        mainAsync {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backClick(_ sender: Any) {
        pop()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.query = textField.text ?? ""
        page = 0
        totalPages = 1
        data = []
        getData()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchItemCell.reuseIdentifier,
                                                       for: indexPath) as? SearchItemCell else {
            return UITableViewCell()
        }
        cell.config(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController(item: data[indexPath.row])
        push(vc)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.canShowLoadmore, canLoadMore, !isLoadMore {
            isLoadMore = true
            getData()
        }
    }
}
