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


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchTextFieldDelegate{
    
    let userTextField = UITextField()
    let stackView = UIStackView()
    let searchButton = UIButton()
    let topFilmButton = UIButton()
    let clearButton = UIButton()
    let resultView = UITableView()
    var resultKeywordTopFilm: [FilmElement] = []
    
    var isSubscribedToTextFieldChanges = false // флаг для отслеживания подписки


    override func viewDidLoad() {
        super.viewDidLoad()
        userTextField.delegate = self
        addElementsOnView()
        configure()
        constraintsConfigure()
        resultView.dataSource = self
        resultView.delegate = self
        resultView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        searchButton.addTarget(self, action: #selector(searchByKeyword), for: .touchUpInside)
        topFilmButton.addTarget(self, action: #selector(searchTopFilm), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearTable), for: .touchUpInside)
    }
//MARK: - UI Configure
    func addElementsOnView(){
        view.addSubview(userTextField)
        view.addSubview(clearButton)
        view.addSubview(stackView)
        view.addSubview(resultView)
    }
    
    func configure(){
        view.backgroundColor = .white
        
        userTextField.layer.cornerRadius = 10
        userTextField.layer.borderWidth = 1
        userTextField.clearButtonMode = .always
        userTextField.placeholder = " Введите название фильма"
        
        clearButton.isHidden = true
        clearButton.backgroundColor = .systemRed
        clearButton.layer.cornerRadius = 10
        clearButton.setImage(UIImage(systemName: "trash"), for: .normal)
        
        
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
            make.leading.trailing.equalToSuperview().inset(20)
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
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(clearButton.snp.leading).offset(-5)
        }
        clearButton.snp.makeConstraints { make in
            make.centerY.equalTo(topFilmButton)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        resultView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(150)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.left.right.equalToSuperview().inset(20)
        }
    }
//MARK: - Clear function for topFilmButton
    @objc func clearTable(){
        clearButton.isHidden = true
        resultKeywordTopFilm.removeAll()
        resultView.reloadData()
    }
//MARK: - Function search by keyword
     @objc func searchByKeyword(){
         if (userTextField.text?.isEmpty)!{
              alert(title: "Пустой запрос", message: "Пожалуйства,введите название фильма")
         }
         
        let userData = URL(string:Api.urlKeyword + (userTextField.text!))
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
                            self.resultKeywordTopFilm.append(filmElement)
                            print(film)
                        })
                        self.resultView.reloadData()
                    }
                }
            }
            
        }
        task.resume()
        subscribeToTextFieldChanges()
    }
//MARK: - Function search top films
    @objc func searchTopFilm(){
       clearButton.isHidden = false

       let userData = URL(string:Api.urlTopFilm)
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
                           self.resultKeywordTopFilm.append(filmElement)
                           print(film)
                       })
                       self.resultView.reloadData()
                   }
               }
           }
           
       }
       task.resume()
   }
//MARK: - Getting notified when UITextField begin editing
    func subscribeToTextFieldChanges() {
        if !isSubscribedToTextFieldChanges {
            userTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            isSubscribedToTextFieldChanges = true
        }
    }

    func unsubscribeFromTextFieldChanges() {
        if isSubscribedToTextFieldChanges {
            userTextField.removeTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            isSubscribedToTextFieldChanges = false
            print("Подписка на изменения текста отключена")
        }
    }
    
    @objc func textFieldDidChange() {
        if userTextField.text?.isEmpty ?? true {
            clearTableData()
        }
    }
//MARK: - CLEAR TABLE DATA
    func clearTableData() {
        resultKeywordTopFilm.removeAll()
        resultView.reloadData()

        unsubscribeFromTextFieldChanges()
    }
//MARK: - Table view logic
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultKeywordTopFilm.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        if let poster = resultKeywordTopFilm[indexPath.row].posterURLPreview , let posterURL = URL(string: poster) {
            cell.imageForCell.kf.setImage(with: posterURL)
        }else{
            cell.imageForCell.image = UIImage(named: "film")
        }
        
        cell.nameFilm.text = resultKeywordTopFilm[indexPath.row].nameRu
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        func searchFilmByID(){
            let filmDetailVC = DetailFilmViewController()
            let film = resultKeywordTopFilm[indexPath.row]
            let url = URL(string: Api.urlFilmId + String(describing: film.filmID!))

            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.setValue(Api.key, forHTTPHeaderField: Api.header)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    if let data = data {
                        let filmByID: FilmSearchByID = try! JSONDecoder().decode(FilmSearchByID.self, from: data)
                        DispatchQueue.main.async {
                            filmDetailVC.movieTitle = filmByID.nameRu
                            filmDetailVC.originalTitle = filmByID.nameOriginal
                            filmDetailVC.posterURL = filmByID.posterURL
                            filmDetailVC.descriptionText = filmByID.description
                            filmDetailVC.ratingsText = {
                                if let rating = filmByID.ratingKinopoisk {
                                    return String(describing: rating)
                                } else {
                                    return "no info"
                                }
                            }()

                            filmDetailVC.yearText = {
                                if let year = filmByID.year {
                                    return String(describing: year)
                                } else {
                                    return "no info"
                                }
                            }()

                            filmDetailVC.durationText = {
                                if let duration = filmByID.filmLength {
                                    return String(describing: duration)
                                } else {
                                    return "no info"
                                }
                            }()
                            print(filmByID)
                            self.resultView.reloadData()
                            self.present(filmDetailVC, animated: true, completion: nil)
                        }
                    }
                }
            }
            task.resume()
        }
        searchFilmByID()
        
    }

    // MARK: - Alert Message
        func alert(title:String,message:String){
            let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }

}



