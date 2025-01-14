//
//  DocumentDetailView.swift
//  DocumentScanner
//
//  Created by 엄기철 on 1/14/25.
//

import SwiftUI
import PDFKit
import LocalAuthentication

struct DocumentDetailView: View {
  var document: Document
  @State private var isLoading: Bool = false
  @State private var showFileMover: Bool = false
  @State private var fileURL: URL?
  @State private var isLockAvailable: Bool?
  @State private var isUnlocked: Bool = false
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
  @Environment(\.scenePhase) private var scenePhase
    var body: some View {
      if let pages = document.pages?.sorted(by: { $0.pageIndex < $1.pageIndex }) {
        VStack(spacing: 10) {
          HeaderView()
            .padding([.horizontal, .top], 15)
          TabView {
            ForEach(pages) { page in
              if let image = UIImage(data: page.pageData) {
                Image(uiImage: image)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
              }
            }
            FooterView()
          }
          .tabViewStyle(.page)
        }
        .background(.black)
        .toolbarVisibility(.hidden, for: .navigationBar)
        .loadingScreen(status: $isLoading)
        .overlay {
          LockView()
        }
        .fileMover(isPresented: $showFileMover, file: fileURL) { result in
          if case .failure(_) = result {
            //Removing the temporary file
            guard let fileURL else { return }
            try? FileManager.default.removeItem(at: fileURL)
            self.fileURL = nil
          }
        }
        .onAppear {
          guard document.isLocked else {
            isUnlocked = true
            return
          }
          let context = LAContext()
          isLockAvailable = context
            .canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        }
        .onChange(of: scenePhase) { oldValue, newValue in
          if newValue != .active && document.isLocked {
            isUnlocked = false
          }
        }
      }
    }

  @ViewBuilder
  private func HeaderView() -> some View {
    Text(document.name)
      .font(.callout)
      .foregroundStyle(.white)
      .hSpacing(.center)
      .overlay(alignment: .trailing) {
        //Lock Button
        Button {
          document.isLocked.toggle()
          isUnlocked = !document.isLocked
          try? context.save()
        } label: {
          Image(systemName: document.isLocked ? "lock.fill" : "lock.open.fill")
            .font(.title3)
            .foregroundStyle(.purple)
        }
      }
  }

  @ViewBuilder
  private func FooterView() -> some View {
    HStack {
      // Share Button
      Button(action: createAndShareDocument) {
        Image(systemName: "square.and.arrow.up.fill")
          .font(.title3)
          .foregroundStyle(.red)
      }

      Spacer(minLength: 0)

      Button {
        dismiss()
        Task { @MainActor in
            //Giving some time to finish zoom transition effect
          try? await Task.sleep(for: .seconds(0.3))
          context.delete(document)
          try? context.save()
        }
      } label: {
        Image(systemName: "trash.fill")
          .font(.title3)
          .foregroundStyle(.red)
      }
    }
    .padding([.horizontal, .bottom], 15)
  }

  @ViewBuilder
  private func LockView() -> some View {
    if document.isLocked {
      ZStack {
        Rectangle()
          .fill(.ultraThinMaterial)
          .ignoresSafeArea()

        VStack(spacing: 6) {
          if let isLockAvailable, !isLockAvailable {
            Text("Please enable biometric access in Settings to unlock this document!")
              .multilineTextAlignment(.center)
              .frame(width: 200)
          } else {
            Image(systemName: "lock.fill")
              .font(.largeTitle)

            Text("Tap to unlock!")
              .font(.callout)
          }
        }
        .padding(15)
        .background(.bar, in: .rect(cornerRadius: 10))
        .contentShape(.rect)
        .onAppear(perform: authenticateUser)
      }
      .opacity(isUnlocked ? 0 : 1)
      .animation(snappy, value: isUnlocked)
    }
  }

  private func authenticateUser() {
    let context = LAContext()
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil ) {
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Locked Document") { status, _ in
        DispatchQueue.main.async {
          self.isUnlocked = status
        }
      }
    } else {
      isLockAvailable = false
      isUnlocked = false
    }
  }

  private func createAndShareDocument() {
    //converting swiftData document into a PDF Document
    guard let pages = document.pages?.sorted(by: { $0.pageIndex < $1.pageIndex}) else { return }
    isLoading = true

    Task.detached(priority: .high) { [document] in

      let pdfDocument = PDFDocument()

      for index in pages.indices {
        if let pageImage = UIImage(data: pages[index].pageData) ,
           let pdfPage = PDFPage(image: pageImage) {
          pdfDocument.insert(pdfPage, at: index)
        }
      }

      var pdfURL = FileManager.default.temporaryDirectory
      let fileName = "\(document.name).pdf"
      pdfURL.append(path: fileName)
      if pdfDocument.write(to: pdfURL) {
        await MainActor.run { [pdfURL] in
          fileURL = pdfURL
          showFileMover = true
          isLoading = false
        }
      }
    }
  }
}
