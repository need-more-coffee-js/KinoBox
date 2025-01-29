//
//  CustomCell.swift
//  kinobox
//
//  Created by Денис Ефименков on 28.01.2025.
//

import UIKit
import SnapKit

class CustomCell: UITableViewCell {
    
    //var imageForCell: UIImageView!
    //var nameFilm: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameFilm: UILabel = {
        let name = UILabel()
        return name
    }()
    let imageForCell: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .center
        //sv.spacing = 20
        return sv
    }()

    
    func setupUI(){
        addSubview(stackView)
        stackView.addArrangedSubview(imageForCell)
        stackView.addArrangedSubview(nameFilm)
        addSubview(imageForCell)
        addSubview(nameFilm)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        imageForCell.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.top)
            make.left.equalTo(stackView.snp.left)
        }
    }
}
