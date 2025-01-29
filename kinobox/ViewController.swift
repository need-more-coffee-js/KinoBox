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
    let filmButton = UIButton()
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
        searchButton.addTarget(self, action: #selector(getData), for: .touchUpInside)
        // Do any additional setup after loading the view.
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
        
        filmButton.backgroundColor = .systemBlue
        filmButton.setTitle("Популярные фильмы", for: .normal)
        filmButton.layer.cornerRadius = 10
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(searchButton)
        stackView.addArrangedSubview(filmButton)
        stackView.spacing = 20
        stackView.backgroundColor = .cyan
        
        resultView.backgroundColor = .red
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
        
        filmButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(20)
        }
        
        resultView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(150)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    @objc func getData(){
        let userData = URL(string:Api.url + (userTextField.text!))
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
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        //var configuration = cell.defaultContentConfiguration()
        
        if let poster = result[indexPath.row].posterURLPreview , let posterURL = URL(string: poster) {
            cell.imageForCell.kf.setImage(with: posterURL)
        }else{
            cell.imageForCell.image = UIImage(named: "film")
        }
        
        cell.nameFilm.text = result[indexPath.row].nameRu
        //cell.contentConfiguration = configuration
        return cell
    }

}



