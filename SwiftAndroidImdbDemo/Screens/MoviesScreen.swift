import SwiftUI
import SwiftAndroidSDK

/// Movies tab — popular movies.
struct MoviesScreen: View {
    private let vm = TMDBContainer.getMoviesViewModel()

    @State private var state: UiState<MoviePage> = .loading

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Popular Movies")
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
            List(page.results, id: \.id) { movie in
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title).font(.headline)
                    Text("⭐ \(String(format: "%.1f", movie.voteAverage))  •  \(movie.releaseDate ?? "")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
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
