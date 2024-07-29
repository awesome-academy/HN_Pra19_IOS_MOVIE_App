//
//  BaseService.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 12/11/2023.
//

import Foundation
import Alamofire

class APIService {
    
    static let shared = APIService()
    
    private var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/x-www-form-urlencoded")
        return headers
    }
    
    static let baseURL = "https://api.themoviedb.org/3"
    static let baseImage = "https://image.tmdb.org/t/p/w500"
    static let API_KEY = Environment.apiKey
    
    private var alamofireManager: Alamofire.Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        alamofireManager = Alamofire.Session(configuration: configuration)
    }
    
    func request<T: Decodable>(_ path: String,
                               _ method: HTTPMethod,
                               parameters: Parameters? = nil,
                               of: T.Type,
                               encoding: ParameterEncoding = URLEncoding.default,
                               success: @escaping (T) -> Void,
                               failure: @escaping (_ code: Int, _ message: String) -> Void) {
        
        alamofireManager.request(path,
                                 method: method,
                                 parameters: parameters,
                                 encoding: encoding,
                                 headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case let .success(data):
                success(data)
            case let .failure(error):
                print(error.localizedDescription)
                let code = error.responseCode ?? 0
                let message = error.localizedDescription
                failure(code, message)
            }
        }
    }
}

extension APIService {

    func getSearch(page: Int,
                   query: String,
                   success: @escaping (SearchResultModel) -> Void,
                   failure: @escaping (String) -> Void) {
        let params: [String : Any] = ["api_key": APIService.API_KEY,
                                      "page": page,
                                      "query": query]
        request(APIPath.search.getURL(),
                .get,
                parameters: params,
                of: SearchResultModel.self) { value in
            success(value)
        } failure: { code, mesage in
            failure(mesage)
        }
    }
    
    func getCredits(movieId: Int,
                    type: MediaType,
                    success: @escaping (CreditsModel) -> Void,
                    failure: @escaping (String) -> Void) {
        let params: [String : Any] = ["api_key": APIService.API_KEY]
        let path = type == .movie 
        ? APIPath.creditMovie(id: movieId)
        : APIPath.creditTV(id: movieId)
        
        request(path.getURL(),
                .get,
                parameters: params,
                of: CreditsModel.self) { result in
            success(result)
        } failure: { code, message in
            failure(message)
        }
    }
    
    func getPosters(movieId: Int,
                    type: MediaType,
                    success: @escaping (ImagesModel) -> Void,
                    failure: @escaping (String) -> Void) {
        let params: [String : Any] = ["api_key": APIService.API_KEY]
        let path = type == .movie
        ? APIPath.imagesMovie(id: movieId)
        : APIPath.imagesTV(id: movieId)
        
        request(path.getURL(),
                .get,
                parameters: params,
                of: ImagesModel.self) { result in
            success(result)
        } failure: { code, message in
            failure(message)
        }
    }
    
    func getVideoTrailer(id: Int,
                         type: MediaType,
                         success: @escaping ([VideoModel]) -> Void,
                         failure: @escaping (String) -> Void) {
        let params: [String : Any] = ["api_key": APIService.API_KEY]
        let path = type == .movie 
        ? APIPath.videosMovie(id: id)
        : APIPath.videosTV(id: id)
        
        request(path.getURL(),
                .get,
                parameters: params,
                of: VideosTrailerModel.self) { value in
            success(value.results)
        } failure: { code, mesage in
            failure(mesage)
        }
    }
    
    func getActorDetail(id: Int,
                        success: @escaping (ActorModel) -> Void,
                        failure: @escaping (String) -> Void) {
        let params: [String : Any] = ["api_key":
                                        APIService.API_KEY]
        request(APIPath.peopleDetail(id: id).getURL(),
                .get,
                parameters: params,
                of: ActorModel.self) { value in
            success(value)
        } failure: { code, mesage in
            failure(mesage)
        }
    }
    
    func getActors(page: Int,
                   success: @escaping (ActorResultModel) -> Void,
                   failure: @escaping (String) -> Void) {
        
        let params: [String : Any] = ["api_key": APIService.API_KEY,
                                      "page": page]
        
        request(APIPath.peoplePopular.getURL(),
                .get,
                parameters: params,
                of: ActorResultModel.self) { value in
            success(value)
        } failure: { code, mesage in
            failure(mesage)
        }
    }
    
    func getConbineCredit(id: Int,
                          success: @escaping ([SearchModel]) -> Void,
                          failure: @escaping (String) -> Void) {
          let params: [String : Any] = ["api_key": APIService.API_KEY]
          request(APIPath.combinedCredit(id: id).getURL(), .get, parameters: params, of: CombinedCreditModel.self) { value in
              success(value.cast)
          } failure: { code, mesage in
              failure(mesage)
          }
      }
    
    func getMovie(page: Int,
                   success: @escaping (SearchResultModel) -> Void,
                   failure: @escaping (String) -> Void) {
        let params: [String : Any] = ["api_key": APIService.API_KEY,
                                      "page": page]
        request(APIPath.popularMovie.getURL(), .get, parameters: params, of: SearchResultModel.self) { value in
            success(value)
        } failure: { code, mesage in
            failure(mesage)
        }
    }
    
    func getTV(page: Int,
               success: @escaping (SearchResultModel) -> Void,
               failure: @escaping (String) -> Void) {
        let params: [String : Any] = ["api_key": APIService.API_KEY,
                                      "page": page]
        
        request(APIPath.popularTV.getURL(),
                .get,
                parameters: params,
                of: SearchResultModel.self) { value in
            success(value)
        } failure: { code, mesage in
            failure(mesage)
        }
    }
}
