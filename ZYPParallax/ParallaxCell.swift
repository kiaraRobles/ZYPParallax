//
//  ParallaxCell.swift
//  ZYPParallax
//
//  Created by Kiara Robles on 2/6/16.
//  Copyright © 2016 kiaraRobles. All rights reserved.
//

import UIKit

class ParallaxCell: UITableViewCell
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var constraintTopImage: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomImage: NSLayoutConstraint!
    
    let imageParallaxConstant: CGFloat = 30
    var imageTop: CGFloat!
    var imageBottom: CGFloat!
    
    var model: CustomCell!
    {
        didSet {
            self.updateCellView()
        }
    }
    
    override func awakeFromNib()
    {
        self.clipsToBounds = true
        self.constraintBottomImage.constant -= imageParallaxConstant * 2
        self.imageTop = self.constraintTopImage.constant
        self.imageBottom = self.constraintBottomImage.constant
    }
    
    func updateCellView()
    {
        self.cellImageView.image = self.model.image
        self.label.text = self.model.title
    }
    
    func imageOffset(offset:CGFloat)
    {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1 - boundOffset) * imageParallaxConstant * 2
        self.constraintTopImage.constant = self.imageTop - pixelOffset
        self.constraintBottomImage.constant = self.imageBottom + pixelOffset
    }
}

