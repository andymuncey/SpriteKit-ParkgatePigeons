import UIKit
import SpriteKit

protocol GameViewControllerDelegate{
    func level(_ level: Int, completed: Bool)
}

class GameViewController: UIViewController, PigeonSceneDelegate {

    var gameViewControllerDelegate: GameViewControllerDelegate?
    var level = 1
    
    func level(_ level: Int, completed: Bool) {
        if !completed {
            navigationController?.popViewController(animated: true)
        }
        gameViewControllerDelegate?.level(level, completed: completed)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)

        let scene = GameScene(size: view.bounds.size)
            
            scene.pigeonSceneDelegate = self
            scene.level = level
        
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
        
            scene.scaleMode = .aspectFill           
            skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
