import SwiftUI
import SwiftAndroidSDK

/// Trending — movies-only with day/week toggle.
struct TrendingScreen: View {
    private let vm = TMDBContainer.getTrendingViewModel()

    @State private var window: TimeWindow = .week
    @State private var state: UiState<MoviePage> = .loading

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Picker("Time window", selection: $window) {
                    Text("Today").tag(TimeWindow.day)
                    Text("This Week").tag(TimeWindow.week)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                content
            }
            .navigationTitle("Trending Movies")
            .task(id: window) { await load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
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
            let page = try await vm.loadTrendingMovies(timeWindow: window, page: 1)
            state = .loaded(page)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
