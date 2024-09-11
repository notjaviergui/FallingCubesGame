//
//  FallingCubesGame2App.swift
//  FallingCubesGame2
//
//  Created by Javier Guisasola on 9/10/24.
//

import SwiftUI
import SceneKit

@main
struct FallingCubesGame2App: App {
    var body: some Scene {
        WindowGroup {
            GameViewControllerRepresentable() // Use a UIViewControllerRepresentable to embed the SceneKit view controller
        }
    }
}

struct GameViewControllerRepresentable: UIViewControllerRepresentable {
    
    // Create and return the GameViewController (SceneKit)
    func makeUIViewController(context: Context) -> UIViewController {
        return GameViewController() // This loads your SceneKit game from GameViewController.swift
    }

    // Required by UIViewControllerRepresentable, but we don’t need to modify anything here for now
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Leave empty for now
    }
}

