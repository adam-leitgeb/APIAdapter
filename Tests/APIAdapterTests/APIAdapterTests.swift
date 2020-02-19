import XCTest
@testable import APIAdapter

final class APIAdapterTests: XCTestCase {

    // MARK: - Properties

    static var allTests = [
        ("fetchWrappedResponse", fetchWrappedResponse),
        ("fetchResponse", fetchResponse)
    ]

    private var apiAdapter = APIAdapter(jsonDecoder: .init(), useResponseWrapper: false)
    private var apiAdapterWithResponseWrapper = APIAdapter(jsonDecoder: .init(), useResponseWrapper: true)

    // MARK: - Tests: Successfull scenarios

    func fetchWrappedResponse() {
        let expectation = self.expectation(description: "Wrapped user fetch")
        var fetchedUser: User?

        let request = LoadUserRequest(id: 22, useWrapper: true)
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

        let request = LoadUserRequest(id: 22, useWrapper: true)
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

    init(id: Int, useWrapper: Bool) {
        path = String(format: path, id)

        if useWrapper {
            path += "/wrapped"
        }
    }
}
