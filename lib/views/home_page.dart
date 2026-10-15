import 'package:flutter/material.dart';
import 'package:movie_app/controllers/movie_controller.dart';
import 'package:movie_app/controllers/tv_controller.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/models/tv_model.dart';
import 'package:movie_app/views/movie_details_page.dart';
import 'package:movie_app/views/tv_details_page.dart';
import 'package:movie_app/widgets/media_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<MovieProvider>().fetchPopularMovies();
      context.read<TvProvider>().fetchPopularTvSeries();
    });
  }

  void _openMovieDetails(MovieModel movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailsPage(id: movie.id)),
    );
  }

  void _openTvDetails(TvModel tv) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TvDetailsPage(id: tv.id)),
    );
  }

  Future<void> _refreshHome() async {
    await Future.wait([
      context.read<MovieProvider>().fetchPopularMovies(forceRefresh: true),
      context.read<TvProvider>().fetchPopularTvSeries(forceRefresh: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshHome,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(child: _buildHeader()),

              // Popular Movies
              SliverToBoxAdapter(
                child: Consumer<MovieProvider>(
                  builder: (context, provider, child) {
                    return _buildMovieSection(provider);
                  },
                ),
              ),

              // TV Series
              SliverToBoxAdapter(
                child: Consumer<TvProvider>(
                  builder: (context, provider, child) {
                    return _buildTvSection(provider);
                  },
                ),
              ),

              // Bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF9B6DFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.movie_filter_rounded, size: 27),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Movie App',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Popular Movies section
  Widget _buildMovieSection(MovieProvider provider) {
    if (provider.movies.isEmpty) {
      return _buildEmptySection('Popular Movies');
    }

    if (provider.isLoading) {
      return _buildLoadingSection('Popular Movies');
    }

    if (provider.errorMessage != null) {
      return _buildErrorSection(
        title: 'Popular Movies',
        message: provider.errorMessage!,
        onRetry: () => provider.fetchPopularMovies(forceRefresh: true),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Popular Movies',
          subtitle: '${provider.movies.length} movies',
        ),
        SizedBox(
          height: 278,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemCount: provider.movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final movie = provider.movies[index];

              return MediaCard(
                title: movie.title,
                posterUrl: movie.posterPath,
                rating: movie.voteAverage,
                year: movie.releaseDate,
                onTap: () => _openMovieDetails(movie),
              );
            },
          ),
        ),
      ],
    );
  }

  // Popular TV Series section
  Widget _buildTvSection(TvProvider provider) {
    if (provider.tvSeries.isEmpty) {
      return _buildEmptySection('TV Series');
    }

    if (provider.isLoading) {
      return _buildLoadingSection('TV Series');
    }

    if (provider.errorMessage != null) {
      return _buildErrorSection(
        title: 'TV Series',
        message: provider.errorMessage!,
        onRetry: () => provider.fetchPopularTvSeries(forceRefresh: true),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Popular TV Series',
          subtitle: '${provider.tvSeries.length} series',
        ),
        SizedBox(
          height: 278,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemCount: provider.tvSeries.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final tv = provider.tvSeries[index];

              return MediaCard(
                title: tv.name,
                posterUrl: tv.posterPath,
                rating: tv.voteAverage,
                year: tv.firstAirDate,
                onTap: () => _openTvDetails(tv),
              );
            },
          ),
        ),
      ],
    );
  }

  // Section heading
  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Loading UI
  Widget _buildLoadingSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: title, subtitle: 'Loading...'),
        const SizedBox(
          height: 170,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  // Error UI
  Widget _buildErrorSection({
    required String title,
    required String message,
    required VoidCallback onRetry,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1D2A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty UI
  Widget _buildEmptySection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        children: [
          _buildSectionHeader(title: title, subtitle: ''),
          const SizedBox(height: 12),
          const Text(
            'No items available.',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
