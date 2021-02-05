//
//  YakListTableViewController.swift
//  YikyYak
//
//  Created by Devin Flora on 2/4/21.
//

import UIKit

class YakListTableViewController: UITableViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchYaks()
    }
    
    //MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchYaks()
    }
    
    @IBAction func composeButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add a Yak!", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Put your quote here..."
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Author"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let postAction = UIAlertAction(title: "Post", style: .default) { [weak self] (_) in
            guard let text = alertController.textFields?[0].text,
                  let author = alertController.textFields?[1].text,
                  !text.isEmpty, !author.isEmpty else {return}
            YakController.shared.createYakWith(text: text, author: author) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response)
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(postAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Methods
    func fetchYaks() {
        YakController.shared.fetchAllYaks { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YakController.shared.yaks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "yakCell", for: indexPath) as? YakTableViewCell else {return UITableViewCell()}
        let yak = YakController.shared.yaks[indexPath.row]
        
        cell.yak = yak
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let yakToDelete = YakController.shared.yaks[indexPath.row]
            guard let index = YakController.shared.yaks.firstIndex(of: yakToDelete) else {return}
            YakController.shared.deleteYak(yak: yakToDelete) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response)
                        YakController.shared.yaks.remove(at: index)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(let error):
                        print(error.errorDescription)
                    }
                }
            }
        }
    }
}//End of Class
