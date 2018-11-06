import UIKit

class LevelSelectViewController : UITableViewController, GameViewControllerDelegate {
    
    var maxLevel = 0
    
    func level(_ level: Int, completed: Bool) {
        if completed && level > maxLevel{
            maxLevel = level - 1
            let defaults = UserDefaults.standard
            defaults.set(level, forKey: "highScore")
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        let defaults = UserDefaults.standard
        maxLevel = defaults.integer(forKey:"highScore")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxLevel+1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier:"Cell")
        cell?.textLabel?.text = "Level \(indexPath.row+1)"
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameViewController = segue.destination as! GameViewController
        gameViewController.level = tableView.indexPathForSelectedRow!.row + 1
        gameViewController.gameViewControllerDelegate = self
    }
}
