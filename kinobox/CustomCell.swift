//
//  CustomCell.swift
//  kinobox
//
//  Created by Денис Ефименков on 28.01.2025.
//

import UIKit
import SnapKit

class CustomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        name.numberOfLines = 0
        name.textAlignment = .left
        return name
    }()
    let imageForCell: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()

    
    func setupUI(){
        addSubview(stackView)
        stackView.addArrangedSubview(imageForCell)
        stackView.addArrangedSubview(nameFilm)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        imageForCell.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(stackView.snp.height)
        }
        
        nameFilm.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(50)
            make.top.bottom.equalToSuperview()
        }
    }
}
