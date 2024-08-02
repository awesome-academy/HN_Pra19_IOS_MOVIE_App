//
//  ActorDetailViewController.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 8/6/24.
//

import UIKit

final class ActorDetailViewController: BaseViewController {
    @IBOutlet private weak var collectionView: UICollectionView!

    private var item: ActorModel?
    private var knownFor: [SearchModel] = []
    private var actorId: Int
    private var group = DispatchGroup()
    
    init(id: Int) {
        self.actorId = id
        super.init(nibName: "ActorDetailViewController", bundle: nil)
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
        collectionView.register(ActorDetailInfoItemCell.self)
        collectionView.register(PhotoItemCell.self)
        collectionView.register(EmptyItemCell.self)

        Utils.showLoading()
        getActorDetail()
        getKnowFors()
        
        group.notify(queue: .main) {
            Utils.hideLoading()
            self.reloadData()
        }
    }
    
    private func getActorDetail() {
        group.enter()
        APIService.shared.getActorDetail(id: actorId) { [weak self] data in
            guard let self else { return }
            self.item = data
            self.group.leave()
        } failure: { [weak self] msg in
            guard let self else { return }
            self.group.leave()
            ToastView.showToast(message: msg, type: .failed)
        }
    }
    
    private func getKnowFors() {
        group.enter()
        APIService.shared.getConbineCredit(id: actorId) { [weak self] value in
            self?.knownFor = value
            self?.group.leave()
        } failure: { msg in
            self.group.leave()
            ToastView.showToast(message: msg, type: .failed)
        }
    }
    
    private func reloadData() {
        mainAsync {
            self.collectionView.reloadData()
        }
    }
}

extension ActorDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return knownFor.isEmpty ? 1 : knownFor.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorDetailInfoItemCell.reuseIdentifier,
                                                                for: indexPath) as? ActorDetailInfoItemCell else {
                return UICollectionViewCell()
            }
            cell.config(item)
            cell.onBackClick = { [weak self] in
                guard let self else { return }
                self.pop()
            }
            return cell
            
        default:
            if knownFor.isEmpty {
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
            cell.configActor(knownFor[indexPath.row])
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
            dummyLabel.text = item?.biography
            let size = dummyLabel.sizeThatFits(CGSize(width: width,
                                                      height: CGFloat.greatestFiniteMagnitude))
            let heigh = 320 + size.height
            return .init(width: getWindowSize().width, height: heigh)
        }
        
        let width = Int((getWindowSize().width - 2 * padding - (colums - 1) * spacing) / colums)
        let heigh = Int(width * 157 / 113) + 30
        
        return knownFor.isEmpty == true 
        ? .init(width: getWindowSize().width - 2 * padding, height: 100)
        : .init(width: width, height: heigh)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .zero
        }
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
    
    func collectionView(_ collectionView: UICollectionView, 
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = MovieDetailViewController(item: knownFor[indexPath.row])
            push(vc)
        }
    }
}

extension MovieDetailViewController {
    private func handlePop() {
        pop()
    }
}
