import SwiftUI

struct DocumentsView: View {
    @State private var documents: [AnalysisDocument] = [] // List of uploaded documents
    @State private var selectedFile: URL?
    @State private var isFileImporterPresented = false
    @State private var isLoading = false
    @State private var progress: Double = 0.0
    @State private var currentUploadingFile: URL?
    @State private var showDeleteConfirmation: AnalysisDocument?
    @State private var showOptionsForDocument: String? // Document ID for which options are visible

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack {
                // Header
                HStack {
                    Text("Documents")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 24))
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                    
                    Button(action: {
                        isFileImporterPresented.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.4))
                            .padding(.horizontal, 15)
                    }
                }

                // File list
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach($documents) { $document in
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("File ID: \(document.documentId)")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Text("Created At: \(document.createdAt, style: .date)")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Text("Author: \(document.author)")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        TextField("Enter Title", text: $document.title)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding(.bottom, 10)
                                    }

                                    Spacer()

                                    Button(action: {
                                        showOptionsForDocument = document.documentId
                                    }) {
                                        Image(systemName: "ellipsis")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.trailing, 10)
                                }

                                if showOptionsForDocument == document.documentId {
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            showDeleteConfirmation = document
                                            showOptionsForDocument = nil
                                        }) {
                                            Image(systemName: "trash")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.red)
                                        }
                                        .padding(.trailing, 10)
                                    }
                                }

                                Divider()
                                    .background(Color.gray)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }

            // Loading overlay
            if isLoading {
                VStack {
                    Text("Uploading file...")
                        .foregroundColor(.white)
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .padding()
                        .onAppear {
                            simulateUpload()
                        }
                    Text("\(Int(progress * 100))%")
                        .foregroundColor(.white)
                        .bold()
                }
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
                .padding()
            }
        }
        .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.plainText, .pdf, .image]) { result in
            switch result {
            case .success(let url):
                currentUploadingFile = url
                uploadFileToServer(url: url)
            case .failure(let error):
                print("Error picking file: \(error.localizedDescription)")
            }
        }
        .alert(item: $showDeleteConfirmation) { document in
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete the document with ID: \(document.documentId)?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteDocument(document)
                    print("Запрос на удаление документа рассматривается")
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func simulateUpload() {
        isLoading = true
        progress = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if progress < 1.0 {
                progress += 0.02
            } else {
                timer.invalidate()
                isLoading = false
                if let file = currentUploadingFile {
                    addDocument(for: file)
                    currentUploadingFile = nil
                }
            }
        }
    }

    private func uploadFileToServer(url: URL) {
        // Placeholder for sending the file to the server
        // api request sending method should be implemented in NetworkManager
        print("Uploading file: \(url.lastPathComponent)")
        simulateUpload()
    }

    private func addDocument(for file: URL) {
        let newDocument = AnalysisDocument(
            documentId: UUID().uuidString,
            title: file.deletingPathExtension().lastPathComponent, // Set title to file name without extension
            content: "",
            author: "Admin",
            createdAt: Date()
        )
        documents.append(newDocument)
    }

    private func deleteDocument(_ document: AnalysisDocument) {
        // Placeholder for sending the delete request to the server
        deleteDocumentFromServer(documentId: document.documentId)

        // Remove the document from the local list
        if let index = documents.firstIndex(where: { $0.documentId == document.documentId }) {
            documents.remove(at: index)
        }
    }

    private func deleteDocumentFromServer(documentId: String) {
        // Placeholder for server-side deletion logic
        // api request sending method should be implemented in NetworkManager
        print("Deleting document with ID: \(documentId)")
    }
}

struct DocumentsView_Preview: PreviewProvider {
    static var previews: some View {
        DocumentsView()
    }
}
