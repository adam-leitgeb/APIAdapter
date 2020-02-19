//
//  Request.swift
//
//  Created by Adam Leitgeb on 04/12/2018.
//  Copyright © 2018 Adam Leitgeb. All rights reserved.
//

import Foundation

public protocol Request {
    var baseURL: URL { get }
    var customHeaders: [String: String] { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var requestData: RequestData { get }
}

// MARK: - URLRequest

extension Request {
    var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        customHeaders.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        switch requestData {
        case .query(let parameters):
            var urlComponents = urlRequest.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: true) }
            urlComponents?.queryItems = parameters.queryItems
            urlRequest.url = urlComponents?.url
        case let .jsonBody(body, query):
            urlRequest.url = urlRequest.url.flatMap { query?.url(from: $0) } ?? urlRequest.url
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        case let .rawData(data):
            urlRequest.httpBody = data
        case .none:
            break
        }

        return urlRequest
    }
}
