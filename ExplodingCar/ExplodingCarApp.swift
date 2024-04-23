//
//  ExplodingCarApp.swift
//  ExplodingCar
//
//  Created by Vina Melody on 23/4/24.
//

import SwiftUI

@main
struct ExplodingCarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
