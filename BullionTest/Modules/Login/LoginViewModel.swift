//
//  LoginViewModel.swift
//  BullionTest
//
//  Created by Naela Fauzul Muna on 12/06/24.
//

import Foundation

class LoginViewModel {
    
    var email: String = ""
    var password: String = ""
    
    var onLoginSuccess: ((User) -> Void)?
    var onLoginError: ((String) -> Void)?
    
    func login() {
        guard let url = URL(string: "https://api-test.bullionecosystem.com/api/v1/auth/login") else {
            self.onLoginError?("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.onLoginError?(error.localizedDescription)
                return
            }
            
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                self.onLoginError?("Invalid response from server")
                return
            }

            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("Response JSON: \(jsonResponse)")
            }
            
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                print("Login success:", apiResponse)
                self.onLoginSuccess?(apiResponse.data)
            } catch {
                self.onLoginError?("Failed to decode response: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

struct APIResponse: Codable {
    let status: Int
    let iserror: Bool
    let message: String
    let data: User
}
