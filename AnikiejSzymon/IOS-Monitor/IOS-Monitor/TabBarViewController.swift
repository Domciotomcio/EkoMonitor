//
//  TabBarViewController.swift
//  IOS-Monitor
//
//  Created by stud on 12/12/2024.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    private var lastSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Map Tab
        let mapVC = UINavigationController(rootViewController: MapViewController())
        mapVC.view.backgroundColor = .systemBlue
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)

        // Home Tab
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        let homeNavVC = UINavigationController(rootViewController: homeVC)

        // Settings Tab
        let settingsVC = SettingsViewController()
        settingsVC.view.backgroundColor = .systemGray
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 2)
        let settingsNavVC = UINavigationController(rootViewController: settingsVC)

        // Tab Bar Controller
        viewControllers = [mapVC, homeNavVC, settingsNavVC]
        selectedIndex = 1 // Start with Home
    }
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard let fromIndex = viewControllers?.firstIndex(of: fromVC),
              let toIndex = viewControllers?.firstIndex(of: toVC) else {
            return nil
        }
        
        let direction: CGFloat = toIndex > fromIndex ? 1 : -1
        return FadingTransitionAnimator(direction: direction)

    }

}
