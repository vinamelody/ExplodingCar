//
//  ImmersiveView.swift
//  ExplodingCar
//
//  Created by Vina Melody on 23/4/24.
//

import RealityKit
import SwiftUI

struct ImmersiveView: View {

    @State var car: Entity?
    @State var isDragging = false
    @State var dragStartPosition: SIMD3<Float> = .zero
    @State var animation: AnimationResource? = nil
    @State var animationController: AnimationPlaybackController?
    @State var animationDuration: Double = 0.0
    @State var animationCurrentPosition: Double = 0.0

    var body: some View {
        RealityView { content, attachments in
            do {
                car = try await ModelEntity.load(named: "car") // availableAnimations[0] crash
                // car = try await ModelEntity(named: "car")
                let environment = try await EnvironmentResource(named: "ImageBasedLight")

                if let car {
                    // Position
                    car.position = [0, 0, -1.5]
                    car.transform.rotation *= simd_quatf(angle: .pi / 2,        // 90 degrees
                                                            axis: SIMD3<Float>(0, 1, 0))

                    // Lighting
                    car.components.set(ImageBasedLightComponent(source: .single(environment)))
                    car.components.set(ImageBasedLightReceiverComponent(imageBasedLight: car))

                    // Collision
//                    let carBounds = car.model!.mesh.bounds.extents
//                    car.components.set(CollisionComponent(shapes: [.generateBox(size: carBounds)]))
//                    car.components.set(InputTargetComponent())
//                    car.components.set(GroundingShadowComponent(castsShadow: true))

                    if let attachment = attachments.entity(for: "animation_control") {
                        attachment.position = [0, 1.5, -0.3]
                        car.addChild(attachment, preservingWorldTransform: true)
                    }

                    // Animation
                    animation = car.availableAnimations[0]
                    if let animation {
                        animationController = car.playAnimation(animation, separateAnimatedValue: false, startsPaused: true)
                        animationDuration = animationController?.duration ?? 0.0
                        print("vvv \(animationDuration)")
                    }

                    content.add(car)
                    animate()
                }
            }
            catch {
                print("Error loading the model")
            }
        } update: { content, attachments in

        } attachments: {
            Attachment(id: "animation_control") {
                Slider(value: $animationCurrentPosition, in: 0...animationDuration)
                    .tint(.green)
                    .frame(height: 100)
                    .frame(maxWidth: 200)
            }
        }
        .gesture(dragGesture)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity

                if !isDragging {
                    isDragging = true
                    dragStartPosition = entity.position(relativeTo: nil)
                }

                let translation3D = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)
                let offset = SIMD3<Float>(x: Float(translation3D.x),
                                          y: Float(translation3D.y),
                                          z: Float(translation3D.z))

                entity.setPosition(dragStartPosition + offset, relativeTo: nil)
            }
            .onEnded {_ in
                isDragging = false
                dragStartPosition = .zero
            }
    }

    private func animate() {
        guard let car, let animation else { return }


    }

}

#Preview {
    ImmersiveView()
}
