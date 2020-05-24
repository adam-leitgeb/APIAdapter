import XCTest
@testable import APIAdapter

final class APIAdapterTests: XCTestCase {

    // MARK: - Properties

    static var allTests = [
        ("fetchWrappedResponse", fetchWrappedResponse),
        ("fetchWrappedResponseWithError", fetchWrappedResponseWithError),
        ("fetchResponse", fetchResponse)
    ]

    private var apiAdapter = APIAdapter<APIError>(jsonDecoder: .init(), useResponseWrapper: false)
    private var apiAdapterWithResponseWrapper = APIAdapter<APIError>(jsonDecoder: .init(), useResponseWrapper: true)

    // MARK: - Tests: Successfull scenarios

    func fetchWrappedResponse() {
        let expectation = self.expectation(description: "Wrapped user fetch")
        var fetchedUser: User?

        let request = LoadUserRequest(id: 22, useWrapper: true, returnError: false)
        apiAdapterWithResponseWrapper.request(request, responseType: User.self) { result in
            self.processResult(result, fetchedModel: &fetchedUser)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertNotNil(fetchedUser)
    }

    func fetchWrappedResponseWithError() {
        let expectation = self.expectation(description: "Wrapped user fetch")
        var fetchedUser: User?

        let request = LoadUserRequest(id: 22, useWrapper: true, returnError: true)
        apiAdapterWithResponseWrapper.request(request, responseType: User.self) { result in
            self.processResult(result, fetchedModel: &fetchedUser)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertNotNil(fetchedUser)
    }

    func fetchResponse() {
        let expectation = self.expectation(description: "User fetch")
        var fetchedUser: User?

        let request = LoadUserRequest(id: 22, useWrapper: false, returnError: false)
        apiAdapter.request(request, responseType: User.self) { result in
            self.processResult(result, fetchedModel: &fetchedUser)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertNotNil(fetchedUser)
    }

    // MARK: - Utilities

    private func processResult<T: Decodable>(_ result: Result<T, Error>, fetchedModel: inout T?) {
        switch result {
        case let .success(model):
            fetchedModel = model
        case let .failure(error):
            dump(error)
        }
    }
}

// MARK: - Submodels

enum APIError: Int, ErrorDecodable {
    case testError = 1022

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let code = try container.decode(Int.self, forKey: .code)

        if let error = APIError(rawValue: code) {
            self = error
        } else {
            throw APIAdapterError.parsingError
        }
    }

    enum CodingKeys: String, CodingKey {
        case code
    }
}

struct User: Decodable {
    let id: Int
    let username: String
}

// MARK: - Requests

struct LoadUserRequest: Request {
    let baseURL = URL(string: "https://private-a746b2-unittests1.apiary-mock.com")!
    var path: String = "/users/%d"
    let customHeaders: [String: String] = [:]
    let method: HTTPMethod = .get
    let requestData: RequestData = .none

    init(id: Int, useWrapper: Bool, returnError: Bool) {
        path = String(format: path, id)

        if useWrapper {
            path += "/wrapped"
        }
        if returnError {
            path += "/error"
        }
    }
}
