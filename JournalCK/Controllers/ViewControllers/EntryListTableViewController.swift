import UIKit

class EntryListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Reloads rows & sections
        tableView.reloadData()
    }
    
    // MARK: _@Class methods
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                EntryModelController.shared.entryList.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)

        // Use our entry Object
        let entry = EntryModelController.shared.entryList[indexPath.row]
        // Set our subtitle properties in our cell
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.timeStamp.dateRightNow()

        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinatonVC = segue.destination as? EntryDetailViewController else { return }
            
            let entryToSend = EntryModelController.shared.entryList[indexPath.row]
            destinatonVC.entry = entryToSend
        }
    }
}
