//
//  NewsListViewController.swift
//  News
//
//  Created by Gadia, Rohit on 7/31/18.
//  Copyright © 2018 Gadia, Rohit. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyJSON

class NewsListViewController: UITableViewController {
    
    let queryParams : [URLQueryItem] = [URLQueryItem(name : "title", value: searchString), URLQueryItem(name : "language[]", value: "en") ]
    
    var searchResults : [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getNewsArticles(searchKeyword: searchString)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SwiftSpinner.show("Loading your news...")
    }
    
    func getNewsArticles(searchKeyword : String) {
        
        let url = NSURLComponents(string: APIEndpoint)!
        
        if !queryParams.isEmpty {
            url.queryItems = queryParams
        }
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(APIAppID, forHTTPHeaderField: "X-AYLIEN-NewsAPI-Application-ID")
        request.addValue(APIKey, forHTTPHeaderField: "X-AYLIEN-NewsAPI-Application-Key")
        request.timeoutInterval = 15
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                self.showNegativeMessage(message: (error?.localizedDescription)!)
                SwiftSpinner.hide()
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                self.showNegativeMessage(message: "Unable to reach the servers")
                SwiftSpinner.hide()
            }
            
            else{
                SwiftSpinner.hide()
                
                var json = JSON(data)
                
                for (key,subJson):(String, JSON) in json {

                    for (key,subJson) : (String, JSON) in subJson {
                        var article = Article()
       
                        article.id = subJson["id"].stringValue
                        article.title = subJson["title"].stringValue
                        article.body = subJson["body"].stringValue
                        
                        //Try to add the author from the JSON response to the model.
                        
                        
                        article.publishedAt = subJson["published_at"].stringValue

                        self.searchResults.append(article)

                    }
                }
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
                
            }
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : tableCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell

//         Configure the cell...
        
        let dict = self.searchResults[indexPath.row]
        
        cell.articleText.text = dict.title
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func showAlert(backgroundColor:UIColor, textColor:UIColor, message:String)
    {
        var appDelegate: AppDelegate!
        var label: UILabel!
        DispatchQueue.main.async {
            appDelegate = UIApplication.shared.delegate as! AppDelegate
            label = UILabel(frame: CGRect.zero)
            label.textAlignment = NSTextAlignment.center
            label.text = message
            label.font = UIFont(name: "", size: 15)
            label.adjustsFontSizeToFitWidth = true
            
            label.backgroundColor =  backgroundColor //UIColor.whiteColor()
            label.textColor = textColor //TEXT COLOR
            
            label.sizeToFit()
            label.numberOfLines = 4
            label.layer.shadowColor = UIColor.gray.cgColor
            label.layer.shadowOffset = CGSize(width: 4, height: 3)
            label.layer.shadowOpacity = 0.3
            label.frame = CGRect(x: appDelegate.window!.frame.size.width, y: 64, width: appDelegate.window!.frame.size.width, height: 44)
            
            label.alpha = 1
            
            appDelegate.window!.addSubview(label)
            
            var basketTopFrame: CGRect = label.frame;
            basketTopFrame.origin.x = 0;
            
            UIView.animate(withDuration
                :2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                    label.frame = basketTopFrame
            },  completion: {
                (value: Bool) in
                UIView.animate(withDuration:2.0, delay: 2.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    label.alpha = 0
                },  completion: {
                    (value: Bool) in
                    label.removeFromSuperview()
                })
            })
        }
    }
    
    func showPositiveMessage(message:String)
    {
        showAlert(backgroundColor: UIColor.white, textColor: UIColor.green, message: message)
    }
    
    func showNegativeMessage(message:String)
    {
        showAlert(backgroundColor: UIColor.white, textColor: UIColor.red, message: message)
    }

}

class tableCell : UITableViewCell{
    
    @IBOutlet weak var articleText: UITextView!
    
    //Add Author Label in the cell view
}
