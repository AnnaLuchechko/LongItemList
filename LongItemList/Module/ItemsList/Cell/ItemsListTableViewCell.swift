//
//  ListItemTableViewCell.swift
//  LongItemList
//
//  Created by Anna Luchechko on 02.04.2021.
//

import UIKit

class ItemsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
      super.prepareForReuse()
      
      configure(with: .none)
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()

      indicatorView.hidesWhenStopped = true
    }
    
    func configure(with item: ListItemModel?) {
        if let item = item {
            nameLabel.text = item.name
            descriptionLabel.text = item.desription
            nameLabel.alpha = 1
            descriptionLabel.alpha = 1
            indicatorView.stopAnimating()
        } else {
            nameLabel.alpha = 0
            descriptionLabel.alpha = 0
            indicatorView.startAnimating()
        }
    }
    
}
