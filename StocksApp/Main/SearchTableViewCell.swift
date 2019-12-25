//
//  SearchTableViewCell.swift
//  StocksApp
//
//  Created by  E.Tratotul on 07.12.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    private  let color = #colorLiteral(red: 0.4140962362, green: 0.6936558485, blue: 0.8813936114, alpha: 1)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(stock: SearchStockModel){
        detailTextLabel!.text = stock.name
        textLabel?.text = stock.symbol
                      textLabel!.textColor = self.color
                      detailTextLabel!.textColor = self.color
}
}
