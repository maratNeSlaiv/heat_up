//
//  AnalyzeImageView.swift
//  heat_up
//
//  Created by marat orozaliev on 21/12/2024.
//

import SwiftUI

struct AnalyzeImageView: View {
    @State private var droppedFiles: [URL] = []

    var body: some View {
        VStack {
            Text("Drag and drop HEIC files here")
                .font(.headline)
                .padding()

            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 300, height: 200)
                .border(Color.blue, width: 2)
                .onDrop(of: ["public.heic"], isTargeted: nil) { providers in
                    if let item = providers.first {
                        item.loadObject(ofClass: URL.self) { url, error in
                            if let fileURL = url as? URL {
                                // Handle the dropped file
                                if fileURL.pathExtension.lowercased() == "heic" {
                                    droppedFiles.append(fileURL)
                                }
                            }
                        }
                    }
                    return true
                }

            List(droppedFiles, id: \.self) { fileURL in
                Text(fileURL.lastPathComponent)
            }
        }
        .padding()
    }
}

struct AnalyzeImageView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzeImageView()
    }
}
