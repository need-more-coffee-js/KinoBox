//
//  ViewController.swift
//  kinobox
//
//  Created by Денис Ефименков on 28.01.2025.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userTextField = UITextField()
    let stackView = UIStackView()
    let searchButton = UIButton()
    let topFilmButton = UIButton()
    let resultView = UITableView()
    var result: [FilmElement] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        addElementsOnView()
        configure()
        constraintsConfigure()
        resultView.dataSource = self
        resultView.delegate = self
        resultView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        searchButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        topFilmButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    func addElementsOnView(){
        view.addSubview(userTextField)
        view.addSubview(stackView)
        view.addSubview(resultView)
    }
    
    func configure(){
        view.backgroundColor = .white
        
        userTextField.layer.cornerRadius = 10
        userTextField.layer.borderWidth = 1
        
        searchButton.backgroundColor = .systemBlue
        searchButton.setTitle("Поиск", for: .normal)
        searchButton.layer.cornerRadius = 10
        
        topFilmButton.backgroundColor = .systemBlue
        topFilmButton.setTitle("Популярные фильмы", for: .normal)
        topFilmButton.layer.cornerRadius = 10
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(searchButton)
        stackView.addArrangedSubview(topFilmButton)
        stackView.spacing = 20
        
        resultView.rowHeight = 150
    }
    
    func constraintsConfigure(){
        userTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.centerX.equalTo(view)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(userTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(35)
        }
        
        searchButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(80)
        }
        
        topFilmButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(20)
        }
        
        resultView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(150)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
     func getData(api: String)->[FilmElement]{
         let userData: URL?
         
         if (userTextField.text?.isEmpty)!{
              userData = URL(string: Api.urlTopFilm)
         }else{
             userData = URL(string:Api.urlKeyword + (userTextField.text!))
         }
         
        var request = URLRequest(url: userData!)
        
        request.httpMethod = "GET"
        request.setValue(Api.key, forHTTPHeaderField: Api.header)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }else{
                if let data = data {
                    let film: Film = try! JSONDecoder().decode(Film.self, from: data)
                    DispatchQueue.main.async {
                        film.films?.forEach({ filmElement in
                            self.result.append(filmElement)
                        })
                        self.resultView.reloadData()
                    }
                }
            }
            
        }
        task.resume()
        return result
    }

    @objc func buttonTapped(_ sender: UIButton){
        if sender == searchButton && (userTextField.text?.isEmpty)! {
            getData(api: Api.urlKeyword)
        }else if sender == topFilmButton {
            getData(api: Api.urlTopFilm)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        if let poster = result[indexPath.row].posterURLPreview , let posterURL = URL(string: poster) {
            cell.imageForCell.kf.setImage(with: posterURL)
        }else{
            cell.imageForCell.image = UIImage(named: "film")
        }
        
        cell.nameFilm.text = result[indexPath.row].nameRu
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let filmDetailVC = DetailFilmViewController()
        let film = result[indexPath.row]
        
        filmDetailVC.movieTitle = film.nameRu
        filmDetailVC.originalTitle = film.nameEn
        filmDetailVC.posterURL = film.posterURL
        filmDetailVC.descriptionText = film.description
        filmDetailVC.ratingsText = film.rating
        filmDetailVC.yearText = film.year
        filmDetailVC.durationText = film.filmLength

        present(filmDetailVC, animated: true, completion: nil)
    }
    
    // MARK: - Alert Message
        func alert(title:String,message:String){
            let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }

}



