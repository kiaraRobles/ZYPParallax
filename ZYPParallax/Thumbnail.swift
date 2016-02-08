//
//  Thumbnail.swift
//  ZYPParallax
//
//  Created by Kiara Robles on 2/6/16.
//  Copyright © 2016 kiaraRobles. All rights reserved.
//

import UIKit

class Thumbnail: NSObject
{
    var title: String = ""
    var url: String = ""
    var image: UIImage
    
    init(title: String, url: String) {
        self.title = title
        self.url = url

        let nsurl = NSURL(string: url)
        let data = NSData(contentsOfURL:nsurl!)
        self.image = UIImage(data: data!)!
    }
}

