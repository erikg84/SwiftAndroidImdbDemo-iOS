import SwiftUI
import SwiftAndroidSDK

/// TV Shows tab — popular TV shows.
struct TVShowsScreen: View {
    private let vm = TMDBContainer.getTVShowsViewModel()

    @State private var state: UiState<TVShowPage> = .loading

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Popular TV Shows")
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
                ForEach(page.results, id: \.id) { show in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(show.name).font(.headline)
                        Text("⭐ \(String(format: "%.1f", show.voteAverage))  •  first aired \(show.firstAirDate ?? "?")")
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
            let page = try await vm.loadPopular(page: 1)
            state = .loaded(page)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
