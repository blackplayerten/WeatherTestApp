//
//  ServiceCity.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import Foundation

protocol ServiceCityDescription: AnyObject {
    func loadCity(name: String, completion: @escaping (Result<CityModel, ServiceError>) -> Void)
    func loadForecast(name: String, completion: @escaping (Result<ForecastModel, ServiceError>) -> Void)
}

enum RequestType {
    case searchCity
    case getForecast
}

final class ServiceCity {
    static let shared = ServiceCity()
    private init() {}
}

extension ServiceCity: ServiceCityDescription {
    func loadCity(name: String, completion: @escaping (Result<CityModel, ServiceError>) -> Void) {
        let request = configureRequest(cityName: name, type: .searchCity)
        load(request: request, completion: completion)
    }

    func loadForecast(name: String, completion: @escaping (Result<ForecastModel, ServiceError>) -> Void) {
        let request = configureRequest(cityName: name, type: .getForecast)
        load(request: request, completion: completion)
    }
}

private extension ServiceCity {
    func configureURL(cityName: String, requestType: RequestType) -> URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/"
        urlComponents.queryItems = [URLQueryItem(name: "q", value: "\(cityName)")]

        switch requestType {
        case .searchCity:
            urlComponents.path.append("weather")
        case .getForecast:
            urlComponents.path.append("forecast")
            urlComponents.queryItems?.append( URLQueryItem(name: "cnt", value: "3"))
        }

        urlComponents.queryItems?.append(URLQueryItem(name: "appid", value: "b890d41619df734910457b4be2460f47"))

        return urlComponents.url ?? URL(filePath: "")
    }

    func configureRequest(cityName: String, type: RequestType) -> URLRequest {
        let url = configureURL(cityName: cityName, requestType: type)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }

    func load<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, ServiceError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.unknown))
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let parsedData: T = try JSONDecoder().decode(T.self, from: data)
                completion(.success(parsedData))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}

enum ServiceError: String, Error {
    case invalidURL, unknown = "Unexpected error"
    case invalidResponse = "Failure request"
    case invalidData = "Don't find a city"
}
