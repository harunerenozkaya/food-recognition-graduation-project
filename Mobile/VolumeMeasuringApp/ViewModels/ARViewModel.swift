import Foundation
import RealityKit

class ARViewModel: ObservableObject {
    @Published var basePoints: [Point] = []
    @Published var roofPoints: [Point] = []
    @Published var calculatedBaseArea: Float?
    @Published var calculatedRoofArea: Float?
    @Published var calculatedVolume: Float?
    @Published var rootAnchor: AnchorEntity?
    @Published var isAreaClosed: Bool = false
    @Published var isRoofCreated: Bool = false
    @Published var areaHeight : Double = 0 {
        didSet {
            if (rootAnchor == nil) {
                return
            }

            for entity in rootAnchor!.children {
                if (entity.name == "roofPoint" || entity.name == "roofLine") {
                    entity.position.y = Float(areaHeight / 100)
                    print("Roof point height : \(entity.position.y)")

                    // Update local position and world position of item in roofPoints array
                    let index = roofPoints.firstIndex(where: { $0.id == entity.id })
                    if let index = index {
                        // Update local position of item in roofPoints array
                        roofPoints[index].localPosition = entity.position;

                        // Calculate world position according to root anchor
                        let worldPosition = rootAnchor!.convert(position: roofPoints[index].localPosition, from: nil)
                        roofPoints[index].worldPosition = worldPosition;

                        // Update initial world position
                        roofPoints[index].initialLocalPosition.y = entity.position.y
                        print("Initial local : \(roofPoints[index].initialLocalPosition)")

                    }   
                }
            }

            // Update vertical lines by traversing vertical lines
            let verticalLines = rootAnchor!.children.filter { $0.name == "verticalLine" }
            for (index, verticalLine) in verticalLines.enumerated(){
                let basePoint = basePoints[index]
                let roofPoint = roofPoints[index]
                let distance = simd_distance(basePoint.localPosition, roofPoint.localPosition)
                let direction = normalize(roofPoint.localPosition - basePoint.localPosition)
                verticalLine.position = (basePoint.localPosition + roofPoint.localPosition) / 2
                verticalLine.orientation = simd_quaternion(SIMD3<Float>(0, 1, 0), direction)
                (verticalLine as! ModelEntity).scale = SIMD3<Float>(1, distance / 0.001, 1)
            }
            
            calculateVolume()
        }
    }

    @Published var roofAreaScale: Float = 0 {
        didSet {
            if (rootAnchor == nil) {
                return
            }

            // Detect center of roof points
            let roofPointEntities = rootAnchor!.children.filter { $0.name == "roofPoint" }
            let center = roofPointEntities.reduce(SIMD3<Float>(0, 0, 0)) { $0 + $1.position } / Float(roofPointEntities.count)
            
            // Store updated positions to update vertical lines later
            var updatedRoofPositions: [SIMD3<Float>] = []
            
            for roofPoint in roofPointEntities {
                // Find initial position of roof point by traversing in roofPoints array
                let initialPosition = roofPoints.first(where: { $0.id == roofPoint.id })?.initialLocalPosition
                
                // Get direction vector from center to roof point
                let directionVector = roofPoint.position - center

                // Move roof point in direction of normal vector
                roofPoint.position = initialPosition! + directionVector * roofAreaScale/100
                
                // Store updated position
                updatedRoofPositions.append(roofPoint.position)

                // Update local position and world position of item in roofPoints array
                let index = roofPoints.firstIndex(where: { $0.id == roofPoint.id })
                if let index = index {
                    roofPoints[index].localPosition = roofPoint.position
                    
                    // Calculate world position according to root anchor
                    let worldPosition = rootAnchor!.convert(position: roofPoint.position, from: nil)
                    roofPoints[index].worldPosition = worldPosition
                }
            }
            
            // Remove all roof lines
            let roofLines = rootAnchor!.children.filter { $0.name == "roofLine" }
            for roofLine in roofLines {
                roofLine.removeFromParent()
            }

            // Create new roof lines
            for i in 0..<updatedRoofPositions.count {
                let start = updatedRoofPositions[i]
                let end = updatedRoofPositions[(i + 1) % updatedRoofPositions.count]
                let line = createLineModel(from: start, to: end, color: .green , name: "roofLine")
                rootAnchor!.addChild(line)
            }
            
            // Update vertical lines
            let verticalLines = rootAnchor!.children.filter { $0.name == "verticalLine" }
            for (index, verticalLine) in verticalLines.enumerated() {
                guard index < basePoints.count && index < updatedRoofPositions.count else { continue }
                
                let basePosition = basePoints[index].localPosition
                let roofPosition = updatedRoofPositions[index]
                
                // Update vertical line position and scale
                let distance = simd_distance(basePosition, roofPosition)
                let direction = normalize(roofPosition - basePosition)
                
                // Update position to midpoint
                verticalLine.position = (basePosition + roofPosition) / 2
                
                // Update orientation
                let up = SIMD3<Float>(0, 1, 0)
                verticalLine.orientation = simd_quaternion(up, direction)
                
                // Update scale for length
                (verticalLine as! ModelEntity).scale = SIMD3<Float>(1, distance / 0.001, 1)
            }
            
            calculateVolume()
        }
    }
    
    func addBasePoint(id : UInt64,worldPosition: SIMD3<Float>, localPosition: SIMD3<Float>, initialWorldPosition: SIMD3<Float>, initialLocalPosition: SIMD3<Float>) {
        print("Base point world position : \(worldPosition)")
        print("Base point local position : \(localPosition)")
        let point = Point(id:id ,localPosition: localPosition, worldPosition: worldPosition, initialWorldPosition: initialWorldPosition, initialLocalPosition: initialLocalPosition)
        basePoints.append(point)
    }

    func addRoofPoint(id : UInt64, worldPosition: SIMD3<Float>, localPosition: SIMD3<Float>, initialWorldPosition: SIMD3<Float>, initialLocalPosition: SIMD3<Float>) {
        print("Roof point world position : \(worldPosition)")
        print("Roof point local position : \(localPosition)")
        let point = Point(id:id ,localPosition: localPosition, worldPosition: worldPosition, initialWorldPosition: initialWorldPosition, initialLocalPosition: initialLocalPosition)
        
        roofPoints.append(point)
    }
    
    func reset() {
        // Remove root anchor from the scene if it exists
        if let anchor = rootAnchor {
            anchor.removeFromParent()
        }
        
        // Clear points array
        basePoints.removeAll()
        roofPoints.removeAll()

        // Reset calculated area
        calculatedBaseArea = nil
        calculatedRoofArea = nil
        calculatedVolume = nil

        // Set root anchor to nil
        rootAnchor = nil

        // Reset isAreaClosed
        isAreaClosed = false
        isRoofCreated = false
        
        areaHeight = 0
        roofAreaScale = 0
    }
    
    func calculateVolume() {
        // Break down the calculation into steps
        let baseArea = calculateBaseAreaLocalPositions()
        let roofArea = calculateRoofAreaLocalPositions()
        let height = Float(areaHeight)
        
        // Calculate base volume
        calculatedVolume = ((baseArea + roofArea) / 2) * height
        
        print("Base Area: \(baseArea) cm^2")
        print("Roof Area: \(roofArea) cm^2")
        print("Height: \(height) cm")
        print("Calculated Volume: \(calculatedVolume ?? 0) cm^3")
    }
    
    
    func calculateBaseAreaLocalPositions() -> Float {
        print("Calculating base area with \(basePoints.count) points")

        guard basePoints.count >= 3 else {
            calculatedBaseArea = 0
            return 0;
        }

        // Calculate area using shoelace formula
        var area: Float = 0
        for i in 0..<basePoints.count {
            let j = (i + 1) % basePoints.count
            let point1 = basePoints[i].localPosition
            let point2 = basePoints[j].localPosition
            
            area += point1.x * point2.z - point2.x * point1.z
        }  

        calculatedBaseArea = abs(area) / 2
        print("Calculated base area : \(calculatedBaseArea ?? 00)")

        return calculatedBaseArea!
    }

    func calculateRoofAreaLocalPositions() -> Float {
        print("Calculating area with \(roofPoints.count) points")

        guard roofPoints.count >= 3 else {
            calculatedRoofArea = 0
            return 0;
        }

        // Calculate area using shoelace formula
        var area: Float = 0 
        for i in 0..<roofPoints.count {
            let j = (i + 1) % roofPoints.count
            let point1 = roofPoints[i].localPosition
            let point2 = roofPoints[j].localPosition
            
            area += point1.x * point2.z - point2.x * point1.z
        }   

        calculatedRoofArea = abs(area) / 2
        print("Calculated roof area : \(calculatedRoofArea ?? 0) cm^2")

        return calculatedRoofArea!
    }
    
    func checkAreaIsClosed(_ newPointPosition : SIMD3<Float>) -> Bool {
        let pointCount = basePoints.count;
        if (pointCount >= 2) {
            let firstPoint = basePoints[0].localPosition
            let distanceToFirstPoint = simd_distance(firstPoint, newPointPosition)
            
            if (distanceToFirstPoint < 0.01) {
                isAreaClosed = true
                print("Area is closed")
                return true
            }
        }
        return false
    }
    
    public func createLineModel(from start: SIMD3<Float>, to end: SIMD3<Float>, color:SimpleMaterial.Color, name:String) -> ModelEntity {
        // 1. Calculate distance and direction
        let distance = simd_distance(start, end)
        let direction = normalize(end - start)
        
        // 2. Create a thin box (along the Z-axis in local coordinates)
        let thickness: Float = 0.001
        let boxMesh = MeshResource.generateBox(size: [thickness, thickness, distance])
        let material = SimpleMaterial(color: color, isMetallic: false)
        let lineEntity = ModelEntity(mesh: boxMesh, materials: [material])
        
        // 3. Rotate the line so its local +Z axis aligns with the direction from start to end.
        //    Using RealityKit’s simd_quatf(from:to:) helps us avoid manual rotation matrix math.
        let forward = SIMD3<Float>(0, 0, 1)
        lineEntity.orientation = simd_quaternion(forward, direction)
        
        // 4. Finally, find the midpoint between start and end
        let midpoint = (start + end) / 2
        
        // 5. Finally, position the entire line entity at the global "start" coordinate
        //    so it extends toward the "end" coordinate.
        lineEntity.position = midpoint
        
        lineEntity.name = name
        
        return lineEntity
    }
}
