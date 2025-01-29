//
//  APIManager.swift
//  kinobox
//
//  Created by Денис Ефименков on 29.01.2025.
//

//import Foundation
//import UIKit
//
//class APIManager: ViewController{
//    
//    
//    static let shared = APIManager()
//    
//    func getData(keyword:String)->FilmElement{
//        let userData = URL(string: Api.url + (ViewController().userTextField.text!))
//        var request = URLRequest(url:userData!)
//        
//        request.httpMethod = "GET"
//        request.setValue(Api.key, forHTTPHeaderField: Api.header)
//        
//        let task = URLSession.shared.dataTask(with: request){ data, response, error in
//            if let error = error {
//                print(error)
//            }else{
//                if let data = data , let _ = try? JSONSerialization.jsonObject(with: data, options: []){
//                    _ = String(data: data , encoding: .utf8)
//                    let film: Film = try! JSONDecoder().decode(Film.self, from: data)
//                }
//            }
//        }
//        task.resume()
//    }
//}
