# APIAdapter

A generic wrapper around URLSession & URLRequest API.

## Usage

````
import APIAdapter

struct LoginRequest: Request {
    var path: String = "/login"
    var method: HTTPMethod = .get
    var requestData: RequestData

    init(email: String, password: String) {
        requestData = .jsonBody([
            "email": email,
            "password": password,
        ], query: nil)
    }
}

let request = LoginRequest(email: "adam@email.com", password: "password")
let apiAdapter = APIAdapter(jsonDecoder: .init())

// NOTE: - Response type has to conform to protocol 'Decodable' and is automatically parsed

apiAdapter.request(request, responseType: String.self) { accessToken in 
    // TODO: - Save AccessToken, display Home
}

````
