//
//  DetailFilmViewController.swift
//  kinobox
//
//  Created by Денис Ефименков on 02.02.2025.
//

import UIKit
import Kingfisher

class DetailFilmViewController: UIViewController {
    
    var filmID: Int?
    var movieTitle: String?
    var originalTitle: String?
    var posterURL: String?
    var descriptionText: String?
    var ratingsText: String?
    var yearText: String?
    var durationText: String?
    
//MARK: - UI ELEMENTS
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let originalTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let ratingsLabel = UILabel()
    private let yearLabel = UILabel()
    private let durationLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateUI()
    }
    
    private func updateUI() {
        titleLabel.text = movieTitle
        originalTitleLabel.text = originalTitle
        descriptionLabel.text = descriptionText
        ratingsLabel.text = "Рейтинг: " + (ratingsText ?? "no info")
        yearLabel.text = "Год производства: " + (yearText ?? "Нет информации")
        durationLabel.text = "Продолжительность: " + (durationText ?? "Нет информации")
        
        if let posterURLString = posterURL, let url = URL(string: posterURLString) {
            posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "film"))
        } else {
            posterImageView.image = UIImage(named: "film") // Заглушка, если URL нет
        }
    }
//MARK: - SETUP UI ELEMENTS
    private func setupUI() {
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true

        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.numberOfLines = 0

        originalTitleLabel.font = UIFont.systemFont(ofSize: 24)
        originalTitleLabel.textColor = .gray
        originalTitleLabel.numberOfLines = 0

        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.numberOfLines = 0

        ratingsLabel.font = UIFont.systemFont(ofSize: 20)
        ratingsLabel.numberOfLines = 0

        yearLabel.font = UIFont.systemFont(ofSize: 20)
        yearLabel.textColor = .gray

        durationLabel.font = UIFont.systemFont(ofSize: 20)
        durationLabel.textColor = .gray

        let topStackView = UIStackView(arrangedSubviews: [posterImageView, ratingsLabel])
        topStackView.axis = .horizontal
        topStackView.spacing = 16
        topStackView.alignment = .top

        let mainStackView = UIStackView(arrangedSubviews: [topStackView,  createTitleStackView(),descriptionLabel, yearLabel, durationLabel])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16

        view.addSubview(mainStackView)

        mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(150)
        }
    }

    private func createTitleStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, originalTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }
}
