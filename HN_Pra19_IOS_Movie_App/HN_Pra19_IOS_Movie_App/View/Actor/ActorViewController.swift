//
//  ActorViewController.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 25/7/24.
//

import UIKit

final class ActorViewController: BaseViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var page: Int = 0
    private var totalPages: Int = 1
    private var isLoadMore: Bool = false
    private var canLoadMore: Bool = false
    
    private var data: [ActorModel] = []
    
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
        colums = isIphone() ? 2 : 4
        spacing = isIphone() ? 20 : 40
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ActorItemCell.self)
        
        getActors()
    }
    
    private func getActors() {
        guard totalPages >= page + 1 else {
            return
        }
        page += 1
        APIService.shared.getActors(page: page) { [weak self] result in
            guard let self else { return }
            self.data.append(contentsOf: result.results)
            self.page = result.page
            self.totalPages = result.totalPages
            
            self.canLoadMore = result.totalPages >= result.page + 1
            self.isLoadMore = false
            self.reloadData()
        } failure: { [weak self] msg in
            guard let self else { return }
            self.isLoadMore = false
            ToastView.showToast(message: msg, type: .failed)
        }
    }
    
    private func reloadData() {
        mainAsync {
            self.collectionView.reloadData()
        }
    }
}

extension ActorViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorItemCell.reuseIdentifier, 
                                                      for: indexPath) as! ActorItemCell
        
        cell.config(data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Int((getWindowSize().width - 2 * padding - (colums - 1) * spacing) / colums)
        
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.canShowLoadmore,
           canLoadMore,
           !isLoadMore {
            isLoadMore = true
            getActors()
        }
    }
}
