//
//  IOS_MonitorApp.swift
//  IOS-Monitor
//
//  Created by stud on 12/12/2024.
//

import SwiftUI

@main
struct IOS_MonitorApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarWrapper()
        }
    }
}

struct TabBarWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return TabBarViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // later
    }
}
