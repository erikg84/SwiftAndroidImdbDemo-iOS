import SwiftUI
import SwiftAndroidSDK

/// Home — trending media of all types.
struct HomeScreen: View {
    // Each screen owns exactly ONE SDK viewmodel via TMDBContainer.
    // No DI framework, no wrappers — the SDK accessor IS the dependency.
    private let vm = TMDBContainer.getHomeViewModel()

    @State private var state: UiState<MediaItemPage> = .loading

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Trending This Week")
                .task { await load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .loading:
            ProgressView()
        case .failed(let msg):
            ErrorBanner(message: msg)
        case .loaded(let page):
            List {
                ForEach(page.results, id: \.id) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title ?? item.name ?? "(untitled)")
                            .font(.headline)
                        Text("\(item.mediaType)  •  ⭐ \(String(format: "%.1f", item.voteAverage))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.plain)
        }
    }

    private func load() async {
        state = .loading
        do {
            let page = try await vm.loadTrending(timeWindow: .week, page: 1)
            state = .loaded(page)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

struct ErrorBanner: View {
    let message: String
    var body: some View {
        Text("Error: \(message)")
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red.opacity(0.8))
    }
}
