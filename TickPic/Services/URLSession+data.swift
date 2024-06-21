import Foundation


enum NetworkError: Error {
  case httpStatusCode(Int)
  case urlRequestError(Error)
  case urlSessionError
}

extension URLSession {
  func objectTask<T: Decodable>(
    for request: URLRequest,
    completion: @escaping (Result<T, Error>) -> Void
  ) -> URLSessionTask {
    let decoder: JSONDecoder = {
          let result = JSONDecoder()
          result.keyDecodingStrategy = .convertFromSnakeCase
          return result
        }()

    let fulfillCompletionOnTheMainThread: (Result<T, Error>) -> Void = { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }

    let task = dataTask(with: request, completionHandler: { data, response, error in
      if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
        if 200 ..< 300 ~= statusCode {
          do {
            let decodedObject = try decoder.decode(T.self, from: data)
            fulfillCompletionOnTheMainThread(.success(decodedObject))
          } catch {
            print("Ошибка декодирования: \(error.localizedDescription), данные: \(String(data: data, encoding: .utf8) ?? "")")
            fulfillCompletionOnTheMainThread(.failure(error))
          }
        } else {
          fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
        }
      } else if let error = error {
        fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
      } else {
        fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
      }
    })

    task.resume()
    return task
  }
}
