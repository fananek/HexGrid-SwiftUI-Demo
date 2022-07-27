import SwiftUI
import HexGrid

struct HexGridView: View {
    @State var cellInfo = "Tap on cell"
    let grid = HexGrid(shape: GridShape.hexagon(3))
    var body: some View {
        VStack {
            Canvas { context, size in
                // initialize a grid, set basic parameters
                let cellSize: Double = 35
                grid.hexSize = HexSize(width: cellSize, height: cellSize)
                grid.origin = Point(x: size.width/2, y: size.height/2)
                
                // set center cell as blocked
                if let blockedCell = try? grid.cellAt(CubeCoordinates(x: 0, y: 0, z: 0)){
                    blockedCell.isBlocked = true
                }
                // render cells
                for cell in grid.cells {
                    let corners = grid.polygonCorners(for: cell)
                    var path = Path()
                    
                    guard let firstPoint = corners.first?.cgPoint else { return }
                    
                    path.move(to: firstPoint)
                    for i in 0..<corners.count {
                        path.addLine(to: corners[i].cgPoint)
                    }
                    path.closeSubpath()
                    
                    context.stroke(path, with: .color(red: 0.65, green: 0.9, blue: 1.0), lineWidth: 3)
                    
                    var cellColor: Color
                    if cell.attributes["isHighlighted"] == true {
                        cellColor = Color(red: 0.0, green: 1.0, blue: 1.0)
                        
                    } else if cell.isBlocked {
                        cellColor = Color(red: 0.5, green: 0.5, blue: 0.5)
                    } else {
                        cellColor = Color(.lightGray)
                    }
                    context.fill(path, with: .color(cellColor))
                }
            }
            .onTapGesture { location in
                if let cell = try? grid.cellAt(location.hexPoint) {
                    if cell.isBlocked {
                        cellInfo = "Cell x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z) is blocked!"
                    } else {
                        cellInfo = "Cell x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z)"
                        cell.toggleHighlight()
                    }
                } else {
                    cellInfo = "There is no cell!"
                }
            }
            
            // show informaiton about tapped cell
            Text(cellInfo)
                .padding()
        }
    }
}

struct HexGridView_Previews: PreviewProvider {
    static var previews: some View {
        HexGridView()
    }
}
