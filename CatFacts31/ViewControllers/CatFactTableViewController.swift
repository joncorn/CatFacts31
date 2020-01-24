//
//  CatFactTableViewController.swift
//  CatFacts31
//
//  Created by Jon Corn on 1/23/20.
//  Copyright © 2020 jdcorn. All rights reserved.
//

import UIKit

class CatFactTableViewController: UITableViewController {
    
    // MARK: - Properties
    var facts = [CatFact]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var currentPage = 0
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFacts()
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentPostAlert()
    }
    
    // MARK: - Private Methods
    private func fetchFacts() {
        CatFactController.fetchCatFacts(page: currentPage + 1) { (result) in
            switch result {
            case .success(let facts):
                self.facts += facts
            case .failure(let error):
                self.presentErrorToUser(localizedError: error)
            }
        }
    }
    
    private func presentPostAlert() {
        let alert = UIAlertController(title: "Add fact", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        // Create cancel button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Create add button
        let addButton = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let factName = alert.textFields?[0].text, factName != "" else { return }
            CatFactController.postCatFact(details: factName) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let fact):
                        self.facts.append(fact)
                    case .failure(let error):
                        self.presentErrorToUser(localizedError: error)
                    }
                }
            }
        }
        // adding them to alertcontroller
        alert.addAction(cancelButton)
        alert.addAction(addButton)
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "factCell", for: indexPath)

        let fact = facts[indexPath.row]
        cell.textLabel?.text = fact.details

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
