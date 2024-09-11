import SceneKit
import UIKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    var scene: SCNScene!
    var spawnTimer: TimeInterval = 1.0
    var lastSpawnTime: TimeInterval = 0.0
    var elapsedTime: TimeInterval = 0.0
    var gameView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the 3D scene
        gameView = SCNView(frame: self.view.frame)
        self.view.addSubview(gameView)
        
        scene = SCNScene()
        gameView.scene = scene
        gameView.allowsCameraControl = true
        gameView.backgroundColor = UIColor.black
        gameView.autoenablesDefaultLighting = true
        
        // Set this class as the scene's renderer delegate
        gameView.delegate = self
        
        // Setup the physics world gravity
        scene.physicsWorld.gravity = SCNVector3(0, -9.8, 0)
        
        // Add a ground plane
        let ground = SCNFloor()
        let groundNode = SCNNode(geometry: ground)
        groundNode.position = SCNVector3(0, -10, 0)
        let groundPhysics = SCNPhysicsBody.static()
        groundNode.physicsBody = groundPhysics
        scene.rootNode.addChildNode(groundNode)
        
        // Add a camera
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 5, 20)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    // Handle touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: gameView)
            
            // Perform a hit-test to detect which cube was tapped
            let hitResults = gameView.hitTest(location, options: nil)
            if let result = hitResults.first {
                let node = result.node
                // Remove cube when tapped
                node.removeFromParentNode()
            }
        }
    }
    
    // SceneKit's per-frame update method
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Calculate the elapsed time since the last update
        if lastSpawnTime == 0.0 {
            lastSpawnTime = time
        }
        elapsedTime += time - lastSpawnTime
        
        // Adjust difficulty every 10 seconds
        if elapsedTime >= 10.0 {
            increaseDifficulty()
            elapsedTime = 0 // Reset elapsed time after difficulty increase
        }
        
        // Spawn cubes at the adjusted spawn rate
        if time - lastSpawnTime > spawnTimer {
            spawnCube()
            lastSpawnTime = time
        }
    }
    
    // Function to spawn a cube
    func spawnCube() {
        let cubeSize: CGFloat = 1.0
        let cubeGeometry = SCNBox(width: cubeSize, height: cubeSize, length: cubeSize, chamferRadius: 0)
        
        let randomX = Float.random(in: -5...5)
        let randomZ = Float.random(in: -5...5)
        
        // Create a cube node
        let cubeNode = SCNNode(geometry: cubeGeometry)
        cubeNode.position = SCNVector3(randomX, 10, randomZ)
        
        // Add physics to the cube
        let physicsBody = SCNPhysicsBody.dynamic()
        cubeNode.physicsBody = physicsBody
        
        scene.rootNode.addChildNode(cubeNode)
    }
    
    // Gradually increase the difficulty
    func increaseDifficulty() {
        // Decrease spawn time to spawn cubes faster
        spawnTimer *= 0.9
        
        // Increase the gravity to make cubes fall faster
        let currentGravity = scene.physicsWorld.gravity
        scene.physicsWorld.gravity = SCNVector3(currentGravity.x, currentGravity.y - 0.5, currentGravity.z)
    }
}
