//
//  MovieStore.swift
//  WatchX
//
//  Created by Jehnsen Kane on 31/08/21.
//

import Foundation

class MovieStore: MovieService {
  
    static let shared = MovieStore()
    private init() {}
    private let apiKey = "129f60c147b2ed65b2980c893c9564ee"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
       
    func fetchMovies(from endpoint: MovieListEndPoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: ["append_to_response": "videos,credits"], completion: completion)
    }
    
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: ["language": "en-US",
                                                 "include_adult": "false",
                                                 "region":"US",
                                                 "query": query], //input yang dipake buat search
                              completion: completion)
    }
    
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItemns = [URLQueryItem(name: "api_key", value: apiKey)]
        
        if let params = params {
            queryItemns.append(contentsOf: params.map {URLQueryItem(name: $0.key, value: $0.value)})
        }
                
        urlComponents.queryItems = queryItemns
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) {[weak self] data, response, error in
            guard let self = self else {return}
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                completion(.failure(.apiError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decoderResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decoderResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D,MovieError>, completion: @escaping (Result<D, MovieError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}
