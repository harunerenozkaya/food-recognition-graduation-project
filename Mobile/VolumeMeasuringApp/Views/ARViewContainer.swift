import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    let arViewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Setup AR session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(arViewModel: arViewModel)
    }
    
    class Coordinator: NSObject {
        let arViewModel: ARViewModel
        
        init(arViewModel: ARViewModel) {
            self.arViewModel = arViewModel
        }

        func createRoof() {
            let initialHeight : Float = 0.0001
            var roofPointPositionList : [SIMD3<Float>] = [] 
            // Create roof points above base points little bit higher
            for basePoint in arViewModel.basePoints {
                let roofPoint = ModelEntity(mesh: .generateBox(size: [0.001, 0.001, 0.001]),
                                            materials: [SimpleMaterial(color: .magenta, isMetallic: false)])
                roofPoint.name = "roofPoint"
                roofPoint.position = basePoint.localPosition
                roofPoint.position.y += initialHeight
                roofPointPositionList.append(roofPoint.position)
                arViewModel.rootAnchor!.addChild(roofPoint)
                arViewModel.addRoofPoint(id:roofPoint.id,worldPosition: roofPoint.position, localPosition: roofPoint.position, initialWorldPosition: roofPoint.position, initialLocalPosition: roofPoint.position)
            }

            // Create vertical lines between corresponding base and roof points
            for i in 0..<arViewModel.basePoints.count {
                let basePointPosition = arViewModel.basePoints[i].localPosition
                let roofPointPosition = roofPointPositionList[i]
                let verticalLine = arViewModel.createLineModel(from: basePointPosition, to: roofPointPosition, color: .blue, name:"verticalLine")
                arViewModel.rootAnchor!.addChild(verticalLine)
            }

            // Create lines between roof points as cloning base lines
            for i in 0..<arViewModel.rootAnchor!.children.count {
                let modelEntity = arViewModel.rootAnchor!.children[i] as! ModelEntity
                if (modelEntity.name == "baseLine") {
                    let roofLine = modelEntity.clone(recursive: true)
                    roofLine.model?.materials = [SimpleMaterial(color: .green, isMetallic: false)]
                    roofLine.name = "roofLine"
                    roofLine.position.y += initialHeight
                    arViewModel.rootAnchor!.addChild(roofLine)
                }
            }


            arViewModel.isRoofCreated = true
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            var newPointPosition : SIMD3<Float> = SIMD3()
            guard let arView = gesture.view as? ARView else { return }
            let location = gesture.location(in: arView)
            
            if (arViewModel.isAreaClosed){
                return;
            }
            
            // Perform ray-cast
            guard let raycastResult = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first else { return }
            
            // Create a sphere to mark the point
            let basePoint = ModelEntity(mesh: .generateBox(size: [0.001, 0.001, 0.001]),
                                   materials: [SimpleMaterial(color: .red, isMetallic: false)])
            basePoint.name = "basePoint"
            
            if arViewModel.rootAnchor == nil {
                arViewModel.rootAnchor = AnchorEntity(world: raycastResult.worldTransform)
                arView.scene.addAnchor(arViewModel.rootAnchor!)
                newPointPosition = arViewModel.rootAnchor!.position;
            }
            else {
                // Position the sphere according to root anchor
                let worldRealityKitTransform = Transform(matrix: raycastResult.worldTransform)
                let localTransform = arViewModel.rootAnchor!.convert(transform: worldRealityKitTransform, from: nil as Entity?)
        
                basePoint.position = localTransform.translation;
                newPointPosition = basePoint.position;
            }
                        
            // Check if area is closed
            let isAreaClosed = arViewModel.checkAreaIsClosed(newPointPosition)
            
            if (!isAreaClosed){
                // Add point to scene
                let anchor = arViewModel.rootAnchor
                anchor!.addChild(basePoint)
                
                // Add point to view model
                let worldPosition = SIMD3<Float>(raycastResult.worldTransform.columns.3.x,
                                          raycastResult.worldTransform.columns.3.y,
                                          raycastResult.worldTransform.columns.3.z)
                
                let localPosition = basePoint.position;
                arViewModel.addBasePoint(id: basePoint.id, worldPosition: worldPosition, localPosition: localPosition, initialWorldPosition: worldPosition, initialLocalPosition: localPosition)
                
                // Add line between last two points
                let pointCount = arViewModel.basePoints.count;
                if (pointCount > 1) {
                    let lastPoint : Point = arViewModel.basePoints.last!;
                    let previousPoint : Point = arViewModel.basePoints[pointCount - 2];
                    let edgeEntity : ModelEntity = arViewModel.createLineModel(from: previousPoint.localPosition, to: lastPoint.localPosition, color: .red, name: "baseLine");
                    arViewModel.rootAnchor!.addChild(edgeEntity)
                }
            }
            else {

                // Equal all base points height with deepest point
                let deepestPoint = arViewModel.basePoints.min(by: { $0.localPosition.y < $1.localPosition.y })
                for i in 0..<arViewModel.basePoints.count {
                    // Update the point in the array
                    var updatedPoint = arViewModel.basePoints[i]
                    updatedPoint.worldPosition.y = deepestPoint!.worldPosition.y
                    updatedPoint.localPosition.y = deepestPoint!.localPosition.y
                    arViewModel.basePoints[i] = updatedPoint
                }

                // Traverse all base point entities with name "basePoint"
                for basePoint in arViewModel.rootAnchor!.children {
                    if basePoint.name == "basePoint" {
                        basePoint.position.y = deepestPoint!.localPosition.y
                    }
                }

                // Remove all base lines and generate new ones between base points
                for baseLine in arViewModel.rootAnchor!.children {
                    if baseLine.name == "baseLine" {
                        baseLine.removeFromParent()
                    }
                }

                // Generate new base lines between base points
                for i in 0..<arViewModel.basePoints.count {
                    let basePoint = arViewModel.basePoints[i]
                    let nextPoint = arViewModel.basePoints[(i + 1) % arViewModel.basePoints.count]
                    let line = arViewModel.createLineModel(from: basePoint.localPosition, to: nextPoint.localPosition, color: .red, name: "baseLine")
                    arViewModel.rootAnchor!.addChild(line)
                }
                
                // If area is closed, create roof if not created
                if (arViewModel.isRoofCreated == false){
                    createRoof()
                }
            }
            
        }
    }
}
