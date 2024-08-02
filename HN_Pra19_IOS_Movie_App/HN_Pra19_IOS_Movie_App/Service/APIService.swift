//
//  BaseService.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 12/11/2023.
//

import Foundation
import UIKit

class APIService {
    
    static let shared = APIService()
    
    static let baseURL = Constants.BASE_URL
    static let baseImage = Constants.BASE_IMAGE
    static let API_KEY = Environment.apiKey
    
    func request<T: Decodable>(_ path: String,
                               parameters: [String: Any]? = nil,
                               of type: T.Type,
                               success: @escaping (T) -> Void,
                               failure: @escaping (_ message: String) -> Void) {
        
        guard var urlComponents = URLComponents(string: path) else {
            failure("Invalid URL")
            return
        }

        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        guard let url = urlComponents.url else {
            failure("Invalid URL after adding parameters")
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                let message = error.localizedDescription
                failure(message)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                failure("Server error or invalid response")
                return
            }
            
            guard let data = data else {
                failure("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(T.self, from: data)
                success(responseData)
            } catch {
                failure("Decoding error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
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
                parameters: params,
                of: SearchResultModel.self) { value in
            success(value)
        } failure: { mesage in
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
                parameters: params,
                of: CreditsModel.self) { result in
            success(result)
        } failure: { message in
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
                parameters: params,
                of: ImagesModel.self) { result in
            success(result)
        } failure: { message in
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
                parameters: params,
                of: VideosTrailerModel.self) { value in
            success(value.results)
        } failure: { mesage in
            failure(mesage)
        }
    }
    
    func getActorDetail(id: Int,
                        success: @escaping (ActorModel) -> Void,
                        failure: @escaping (String) -> Void) {
        let params: [String : Any] = ["api_key":
                                        APIService.API_KEY]
        request(APIPath.peopleDetail(id: id).getURL(),
                parameters: params,
                of: ActorModel.self) { value in
            success(value)
        } failure: { mesage in
            failure(mesage)
        }
    }
    
    func getActors(page: Int,
                   success: @escaping (ActorResultModel) -> Void,
                   failure: @escaping (String) -> Void) {
        
        let params: [String : Any] = ["api_key": APIService.API_KEY,
                                      "page": page]
        
        request(APIPath.peoplePopular.getURL(),
                parameters: params,
                of: ActorResultModel.self) { value in
            success(value)
        } failure: { mesage in
            failure(mesage)
        }
    }
    
    func getConbineCredit(id: Int,
                          success: @escaping ([SearchModel]) -> Void,
                          failure: @escaping (String) -> Void) {
          let params: [String : Any] = ["api_key": APIService.API_KEY]
          request(APIPath.combinedCredit(id: id).getURL(),
                  parameters: params,
                  of: CombinedCreditModel.self) { value in
              success(value.cast)
          } failure: { mesage in
              failure(mesage)
          }
      }
    
    func getMovie(page: Int,
                   success: @escaping (SearchResultModel) -> Void,
                   failure: @escaping (String) -> Void) {
        let params: [String : Any] = ["api_key": APIService.API_KEY,
                                      "page": page]
        request(APIPath.popularMovie.getURL(),
                parameters: params,
                of: SearchResultModel.self) { value in
            success(value)
        } failure: { mesage in
            failure(mesage)
        }
    }
    
    func getTV(page: Int,
               success: @escaping (SearchResultModel) -> Void,
               failure: @escaping (String) -> Void) {
        let params: [String : Any] = ["api_key": APIService.API_KEY,
                                      "page": page]
        
        request(APIPath.popularTV.getURL(),
                parameters: params,
                of: SearchResultModel.self) { value in
            success(value)
        } failure: { mesage in
            failure(mesage)
        }
    }
}
