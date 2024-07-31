//
//  HomeViewController.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 25/7/24.
//

import UIKit

final class HomeViewController: BaseViewController {
    enum HomeState {
        case movie
        case tvshow
    }
    
    @IBOutlet weak var tvShowButton: UIButton!
    @IBOutlet weak var movieButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var state: HomeState = .movie {
        didSet {
            updateUIState()
        }
    }
    
    private var movies: [SearchModel] = []
    private var tvs: [SearchModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideMenu()
    }
    
    private func setUpUI() {
        state = .movie
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HomeItemCell.nibClass,
                                forCellWithReuseIdentifier: HomeItemCell.reuseIdentifier)
    }
    
    private func updateUIState() {
        movieButton.backgroundColor = state == .movie ? .color19BAFF : .clear
        movieButton.setTitleColor(state == .movie ? .white : .color19BAFF, for: .normal)
        
        tvShowButton.backgroundColor = state == .tvshow ? .color19BAFF : .clear
        tvShowButton.setTitleColor(state == .tvshow ? .white : .color19BAFF, for: .normal)
        
        switch state {
        case .movie:
            movies.isEmpty ? getMovies() : reloadData()
        case .tvshow:
            tvs.isEmpty ? getTV() : reloadData()
        }
    }
    
    private func getMovies() {
        Utils.showLoading()
        APIService.shared.getMovie(page: 1) { [weak self] result in
            guard let self else { return }
            Utils.hideLoading()
            self.movies = result.results
            self.reloadData()
        } failure: { msg in
            ToastView.showToast(message: msg, type: .failed)
            Utils.hideLoading()
        }
    }
    
    private func getTV() {
        Utils.showLoading()
        APIService.shared.getTV(page: 1) { [weak self] result in
            guard let self else { return }
            Utils.hideLoading()
            self.tvs = result.results
            self.reloadData()
        } failure: { msg in
            ToastView.showToast(message: msg, type: .failed)
            Utils.hideLoading()
        }
    }
    
    private func reloadData() {
        mainAsync { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
            switch self.state {
            case .movie:
                if !self.movies.isEmpty {
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                     at: .left,
                                                     animated: false)

                }
            case .tvshow:
                if !self.tvs.isEmpty {
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                     at: .left,
                                                     animated: false)
                }
            }
        }
    }
    
    @IBAction func movieClick(_ sender: Any) {
        state = .movie
    }
    
    @IBAction func tvShowClick(_ sender: Any) {
        state = .tvshow
    }
    
    @IBAction func searchClick(_ sender: Any) {
        
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return state == .movie 
        ? movies.count
        : tvs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeItemCell.reuseIdentifier, for: indexPath) as? HomeItemCell else {
            return UICollectionViewCell()
        }
        let item = state == .movie ? movies[indexPath.item] : tvs[indexPath.item]
        cell.config(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: getWindowSize().width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
