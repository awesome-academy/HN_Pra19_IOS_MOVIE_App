//
//  PlayTraillerViewController.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khanh Vu on 05/12/2023.
//

import UIKit
import WebKit

final class PlayTraillerViewController: BaseViewController {

    @IBOutlet private weak var webView: WKWebView!
    
    private let embedURL = Constants.EMBED_URL
    private var id: Int
    private var type: MediaType
    
    init(id: Int, type: MediaType) {
        self.id = id
        self.type = type
        super.init(nibName: "PlayTraillerViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        getTrailers()
    }

    private func getTrailers() {
        Utils.showLoading()
        APIService.shared.getVideoTrailer(id: id, type: type) { [weak self] videos in
            guard let self,
                  let key = videos.first?.key else {
                ToastView.showToast(message: "No Video!", type: .failed)
                return
            }
            self.loadVideo(youtubeID: key)
            Utils.hideLoading()
        } failure: { msg in
            Utils.hideLoading()
            ToastView.showToast(message: msg, type: .failed)
        }
    }
    
    private func loadVideo(youtubeID: String) {
        if let youtubeURL = URL(string: embedURL + youtubeID) {
            let request = URLRequest(url: youtubeURL)
            DispatchQueue.main.async {
                self.webView.load(request)
            }
        }
    }

    @IBAction func backClick(_ sender: Any) {
        pop()
    }
}

extension PlayTraillerViewController: WKUIDelegate {
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        if !(navigationAction.targetFrame?.isMainFrame ?? false) {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
