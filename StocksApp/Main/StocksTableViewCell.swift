//
//  StrocksTableViewCell.swift
//  StocksApp
//
//  Created by  E.Tratotul on 28.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import UIKit

class StocksTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var subtitleText: UILabel!
    @IBOutlet weak var stockValueText: UILabel!
    @IBOutlet weak var changeText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(stock: StockDTO){
        titleText.text = stock.symbol
        stockValueText.text = stock.currentValue
        
        guard let change = Double(stock.change) else {
            changeText.backgroundColor = .white
            changeText.text = stock.change
            return
        }
        changeText.backgroundColor = change < 0 ? .red : .green
        changeText.text = String(format: "%.2lf", change)
    }
}
