//
//  ExplodingCarApp.swift
//  ExplodingCar
//
//  Created by Vina Melody on 23/4/24.
//

import SwiftUI

@main
struct ExplodingCarApp: App {

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    
    var body: some Scene {
        WindowGroup {
            EmptyView()
                .task {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                }
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
