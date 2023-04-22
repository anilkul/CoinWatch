//
//  APIResult.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

enum APIResult<T> {
  case success(T)
  case failure(APIError)
}
