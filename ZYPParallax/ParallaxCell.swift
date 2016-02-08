//
//  ImageCell.swift
//  ZYPParallax
//
//  Created by Kiara Robles on 2/6/16.
//  Copyright © 2016 kiaraRobles. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgBackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgBackBottomConstraint: NSLayoutConstraint!
    
    let imageParallaxFactor: CGFloat = 20
    var imgBackTopInitial: CGFloat!
    var imgBackBottomInitial: CGFloat!
    
    var model: CustomCell!
    {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib()
    {
        self.clipsToBounds = true
        self.imgBackBottomConstraint.constant -= 2 * imageParallaxFactor
        self.imgBackTopInitial = self.imgBackTopConstraint.constant
        self.imgBackBottomInitial = self.imgBackBottomConstraint.constant
    }
    
    func updateView()
    {
        self.imgBack.image = self.model.image
        self.lblTitle.text = self.model.title
    }
    
    func setBackgroundOffset(offset:CGFloat)
    {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1 - boundOffset) * 2 * imageParallaxFactor
        self.imgBackTopConstraint.constant = self.imgBackTopInitial - pixelOffset
        self.imgBackBottomConstraint.constant = self.imgBackBottomInitial + pixelOffset
    }
}

