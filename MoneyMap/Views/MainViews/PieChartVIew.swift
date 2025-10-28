import SwiftUI

struct CategoryData {
    let category: String
    let percent: Double
}

struct PieChartView: View {
    let pieData: [CategoryData]
    let baseColors: [Color]
    
    var slices: [(start: Double, end: Double, color: Color)] {
        var startAngle = 0.0
        var result: [(Double, Double, Color)] = []
        
        for (index, item) in pieData.enumerated() {
            let angle = item.percent / 100 * 360
            let sliceStart = startAngle
            let sliceEnd = startAngle + angle
            result.append((sliceStart, sliceEnd, baseColors[index % baseColors.count]))
            startAngle += angle
        }
        return result
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<slices.count, id: \.self) { i in
                CircleSegment(startAngle: .degrees(slices[i].start),
                              endAngle: .degrees(slices[i].end))
                    .stroke(slices[i].color, lineWidth: 30)
            }
        }
        .frame(width: 220, height: 220)
    }
}

struct CircleSegment: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        path.addArc(center: center,
                    radius: radius - 15,
                    startAngle: startAngle - .degrees(90),
                    endAngle: endAngle - .degrees(90),
                    clockwise: false)
        return path
    }
}

#Preview {
    PieChartView(
        pieData: [
            CategoryData(category: "Needs", percent: 50),
            CategoryData(category: "Wants", percent: 30),
            CategoryData(category: "Savings", percent: 20)
        ],
        baseColors: [
            Color("Royal Blue"),
            Color("Wild Blue Yonder"),
            Color("Space Cadet")
        ]
    )
    .padding()
}
