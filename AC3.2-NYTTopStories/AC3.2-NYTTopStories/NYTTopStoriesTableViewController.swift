//
//  NYTTopStoriesTableViewController.swift
//  AC3.2-NYTTopStories
//
//  Created by Kadell on 11/19/16.
//  Copyright © 2016 Kadell. All rights reserved.
//

import UIKit


class NYTTopStoriesTableViewController: UITableViewController, UITextFieldDelegate {
    var allArticles = [Article]()
    var articles = [Article]()
    var allData: [Article] = []
    let endPoint = "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=12cad604bf9f4e179e59464f10aeb6d2"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        navigationItem.title = "Home"
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func loadData() {
        
        APIRequestManager.manager.getData(endPoint: endPoint)
        {( data: Data?) in
            if let validData = data,
                let validNews = Article.newsArticles(from: validData) {
                self.allData = validNews
                
                self.articles = self.allArticles
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
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
        return allData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsIdentifier", for: indexPath) as? NewsTableViewCell
        
        let path = allData[indexPath.row]
        cell?.titleLabel.text = path.title
        cell?.authorLabel.text = path.authors + " \n " + path.published
        cell?.summaryLabel.text = path.summary
        
        
        return cell!
    }
    
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: allData[indexPath.row].url)
        UIApplication.shared.open(url!)
        
    }
    
    func applyPredicate(search: String) {
        let predicate = NSPredicate(format:"ANY per_facet contains[c] %@", search)
        self.articles = self.allArticles.filter { predicate.evaluate(with: $0) }
        self.tableView.reloadData()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if text.characters.count > 0 {
                applyPredicate(search: text)
            }
            else {
                self.articles = self.allArticles
                self.tableView.reloadData()
            }
        }
        return true
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
