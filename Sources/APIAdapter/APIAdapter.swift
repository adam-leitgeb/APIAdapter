//
//  APIAdapter.swift
//
//  Created by Adam Leitgeb on 04/12/2018.
//  Copyright © 2018 Adam Leitgeb. All rights reserved.
//

import Foundation

public class APIAdapter {

    // MARK: - Properties

    private let useResponseWrapper: Bool
    private var jsonDecoder: JSONDecoder
    private var taskHistory: [URLSessionDataTask] = []

    // MARK: - Initialization

    public init(jsonDecoder: JSONDecoder, useResponseWrapper: Bool = true) {
        self.jsonDecoder = jsonDecoder
        self.useResponseWrapper = useResponseWrapper
    }

    // MARK: - Public actions

    public func request<T: Decodable>(_ request: Request, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        self.request(request) { response in
            switch response {
            case .success(let data):
                let parsedResponse = self.parseData(data, into: responseType)
                completion(parsedResponse)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func request(_ request: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        execute(request: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    public func cancelRunningTasks() {
        taskHistory
            .filter { $0.state == .running }
            .forEach { $0.cancel() }
    }

    // MARK: - Logic

    private func execute(request: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request.urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data, response != nil {
                if let error = try? self.jsonDecoder.decode(APIAdapterError.self, from: data), !error.success {
                    completion(.failure(error))
                } else {
                    completion(.success(data))
                }
            } else if let response = response as? HTTPURLResponse, let httpError = HTTPError(rawValue: response.statusCode) {
                completion(.failure(httpError))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(APIAdapterError.unknown))
            }
        }

        taskHistory.append(task)
        task.resume()
    }

    // MARK: - Utilities

    private func parseData<T: Decodable>(_ data: Data, into responseType: T.Type) -> Result<T, Error> {
        do {
            let model = useResponseWrapper
                ? try jsonDecoder.decode(ResponseWrapper<T>.self, from: data).data
                : try jsonDecoder.decode(T.self, from: data)
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
}
