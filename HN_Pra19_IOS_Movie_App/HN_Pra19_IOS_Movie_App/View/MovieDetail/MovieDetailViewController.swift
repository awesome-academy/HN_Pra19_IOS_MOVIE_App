//
//  MovieDetailViewController.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 7/6/24.
//

import UIKit

final class MovieDetailViewController: BaseViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    private var posters: [BackdropModel] = []
    private var billCasts: [CastModel] = []
    private var item: SearchModel
    
    var state: HeaderDetailState = .billCast {
        didSet {
            updateState()
        }
    }
    
    init(item: SearchModel) {
        self.item = item
        super.init(nibName: "MovieDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    private func setUpUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ActorItemCell.self)
        collectionView.register(MovieDetailInfoItemCell.self)
        collectionView.register(PhotoItemCell.self)
        collectionView.register(EmptyItemCell.self)
        collectionView.register(MovieDetailHeaderView.self,
                                supplementaryViewType: UICollectionView.elementKindSectionHeader,
                                bundle: nil)
        state = .billCast
    }
    
    private func updateState() {
        switch state {
        case .billCast:
            if billCasts.isEmpty {
                getBillCast()
            } else {
                reloadData()
            }
        case .poster:
            if posters.isEmpty {
                getPoster()
            } else {
                reloadData()
            }
        }
    }
    
    private func reloadData() {
        mainAsync {
            self.collectionView.reloadData()
        }
    }
    
    private func reloadInfo() {
        let firstCellIndex = IndexPath(row: 0, section: 0)
        guard let cell = self.collectionView.cellForItem(at: firstCellIndex) as? MovieDetailInfoItemCell else {
            return
        }
        cell.updateState()
    }
    
    private func getBillCast() {
        Utils.showLoading()
        APIService.shared.getCredits(movieId: item.id,
                                     type: item.getType()) { [weak self] data in
            guard let self else { return }
            self.billCasts = data.cast
            
            Utils.hideLoading()
            self.reloadData()
        } failure: { msg in
            Utils.hideLoading()
            ToastView.showToast(message: msg, type: .failed)
        }
    }
    
    private func getPoster() {
        Utils.showLoading()

        APIService.shared.getPosters(movieId: item.id,
                                     type: item.getType()) { [weak self] data in
            guard let self else { return }
            self.posters = data.posters
            
            Utils.hideLoading()
            self.reloadData()
        } failure: { msg in
            Utils.hideLoading()
            ToastView.showToast(message: msg, type: .failed)
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        switch state {
        case .billCast:
            return billCasts.isEmpty ? 1 : billCasts.count
        case .poster:
            return posters.isEmpty ? 1 : posters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailInfoItemCell.reuseIdentifier,
                                                                for: indexPath) as? MovieDetailInfoItemCell else {
                return UICollectionViewCell()
            }
            cell.config(item)
            cell.onBackClick = { [weak self] in
                self?.handlePop()
            }
            
            cell.onPlayTrailerClick = { [weak self] in
                self?.handlePlayTrailer()
            }
            
            cell.onWatchedClick = { [weak self] in
                self?.handleWathchedClick()
            }
            
            cell.onWatchListClick = { [weak self] in
                self?.handleWatchListClick()
            }
            
            return cell
        } else if state == .billCast {
            if billCasts.isEmpty {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyItemCell.reuseIdentifier,
                                                                    for: indexPath) as? EmptyItemCell else {
                    return UICollectionViewCell()
                }
                return cell
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorItemCell.reuseIdentifier,
                                                                for: indexPath) as? ActorItemCell else {
                return UICollectionViewCell()
            }
            cell.config(billCasts[indexPath.row])
            return cell
        } else {
            if posters.isEmpty {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyItemCell.reuseIdentifier,
                                                                    for: indexPath) as? EmptyItemCell else {
                    return UICollectionViewCell()
                }
                return cell
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.reuseIdentifier,
                                                                for: indexPath) as? PhotoItemCell else {
                return UICollectionViewCell()
            }
            cell.config(posters[indexPath.row].backdropURL)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = getWindowSize().width - 30
            let dummyLabel = UILabel()
            dummyLabel.numberOfLines = 0
            dummyLabel.font = .systemFont(ofSize: 16, weight: .medium)
            dummyLabel.text = item.overview
            let size = dummyLabel.sizeThatFits(CGSize(width: width,
                                                      height: CGFloat.greatestFiniteMagnitude))
            let heigh = 230 + size.height
            return .init(width: getWindowSize().width, height: heigh)
        }
        
        let width = Int((getWindowSize().width - 2 * padding - (colums - 1) * spacing) / colums)
        let heigh = state == .billCast ? width : Int(width * 157 / 113)
        
        switch state {
        case .billCast:
            return billCasts.isEmpty 
            ? .init(width: getWindowSize().width - 2 * padding, height: 100)
            : .init(width: width, height: heigh)
        case .poster:
            return posters.isEmpty 
            ? .init(width: getWindowSize().width - 2 * padding, height: 100)
            : .init(width: width, height: heigh)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 1 {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier,
                                                                                   for: indexPath) as? MovieDetailHeaderView else {
                    return UICollectionReusableView()
                }
                header.onPosterClick = { [weak self] in
                    self?.state = .poster
                }
                
                header.onBillCastClick = { [weak self] in
                    self?.state = .billCast
                }
                return header
            }
            else {
                fatalError("Unexpected element kind")
            }
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 1
        ? .init(width: getWindowSize().width, height: 50)
        : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .zero
        }
        return .init(top: 0,
                     left: padding,
                     bottom: padding,
                     right: padding)
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
    
    func collectionView(_ collectionView: UICollectionView, 
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && state == .billCast {
            let vc = ActorDetailViewController(id: billCasts[indexPath.row].id)
            push(vc)
        }
    }
}

extension MovieDetailViewController {
    private func handlePop() {
        pop()
    }
    
    private func handlePlayTrailer() {
        let vc = PlayTraillerViewController(id: item.id, type: item.getType())
        push(vc)
    }
    
    private func handleWathchedClick() {
        let watched = CoreDataStatistics.shared.fetch(isWatched: true)
        if watched.contains(where: { $0.id == item.id }) {
            CoreDataStatistics.shared.delete(item: item, isWatched: true)
        } else {
            CoreDataStatistics.shared.save(item: item, isWatched: true)
        }
        reloadInfo()
    }
    
    private func handleWatchListClick() {
        let watchList = CoreDataStatistics.shared.fetch(isWatched: false)
        if watchList.contains(where: { $0.id == item.id }) {
            CoreDataStatistics.shared.delete(item: item, isWatched: false)
        } else {
            CoreDataStatistics.shared.save(item: item, isWatched: false)
        }
        reloadInfo()
    }
}
