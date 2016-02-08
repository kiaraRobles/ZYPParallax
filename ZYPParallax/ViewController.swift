//
//  ViewController.swift
//  ZYPParallax
//
//  Created by Kiara Robles on 2/6/16.
//  Copyright © 2016 kiaraRobles. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var models: [CustomCell] = []
    var thumbnails = [Thumbnail?]()
    
    
    // MARK: View Lifecyle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.rowHeight = 250
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading..."
        
        self.getSetParameter { (result) -> Void in 
            for var index = 0; index < result.count; ++index
            {
                let currentThumbnail = result[index]
                
                var title: String
                var image: UIImage
                if (currentThumbnail?.title != nil) {
                    title = currentThumbnail!.title
                    image = currentThumbnail!.image
                }
                else {
                    title = "Nil"
                    image = UIImage(named: "image0")!
                }
                self.models.append(CustomCell(title: title, image: image))
                self.tableview.reloadData()
            }
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            self.tableview.backgroundColor = UIColor.blackColor()
        }
    }

    
    // MARK: Tableview Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == 0) {
            return self.models.count
        }
        return 0
    }
    func modelAtIndexPath(indexPath: NSIndexPath) -> CustomCell
    {
        return self.models[indexPath.row % self.models.count]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ParallaxCell") as! ParallaxCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.model = self.modelAtIndexPath(indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let imageCell = cell as! ParallaxCell
        self.setCellImageOffset(imageCell, indexPath: indexPath)
    }
    
    
    // MARK: API Methods
    
    func getSetParameter(completion: (result: Array<Thumbnail?>) -> Void)
    {
        var thumbnails = [Thumbnail?]()
        let param = ["format":"json"]
        let jsonUrl: String! = "http://api.stg-jkay.zype.com/videos/?api_key=D5BkNoOibALG3frYyyLH8Q"
        
        let manager: AFHTTPSessionManager = AFHTTPSessionManager()
        manager.GET(jsonUrl, parameters: param, success:
            {
                (task: NSURLSessionDataTask!, JSONResponse: AnyObject!) in
                
                let responseDictionary = JSONResponse as! NSDictionary
                let responseArray = responseDictionary.objectForKey("response") as! NSArray
                for thumbnailsOnVideoDictionary in responseArray
                {
                    let title = thumbnailsOnVideoDictionary.objectForKey("title") as! String
                    let thumbnailsOnVideoArray = thumbnailsOnVideoDictionary.objectForKey("thumbnails") as! NSArray
                    
                    if thumbnailsOnVideoArray.count == 0 {
                        thumbnails.append(nil)
                    }
                    else {
                        let smallThumbnail = thumbnailsOnVideoArray[1];
                        let url: String = (smallThumbnail.objectForKey("url") as! String)
                        let newThumbnail = Thumbnail(title: title, url: url)
                        thumbnails.append(newThumbnail)
                    }
                }
                
                completion(result: thumbnails)
                print("API Success")
            }, failure: {(task: NSURLSessionDataTask?, error: NSError!) in
                print("API Failure")
        })
    }
    
    
    // MARK: Scroll Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if (scrollView == self.tableview) {
            for indexPath in self.tableview.indexPathsForVisibleRows!
            {
                self.setCellImageOffset(self.tableview.cellForRowAtIndexPath(indexPath) as! ParallaxCell, indexPath: indexPath)
            }
        }
    }
    
    func setCellImageOffset(cell: ParallaxCell, indexPath: NSIndexPath)
    {
        let cellFrame = self.tableview.rectForRowAtIndexPath(indexPath)
        let cellFrameInTable = self.tableview.convertRect(cellFrame, toView:self.tableview.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = self.tableview.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        cell.imageOffset(cellOffsetFactor)
    }
    
    
    // MARK: Status Bar Method
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
