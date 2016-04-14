//
//  FuelLogCell.swift
//  CarCare
//
//  Created by Nick Liu on 16/3/31.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import UIKit

class FuelLogCell: UITableViewCell {
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var totalPriceLabel: UILabel!

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

  func setViewModel(viewModel: FuelLogCellViewModel) {
    
  }
}
