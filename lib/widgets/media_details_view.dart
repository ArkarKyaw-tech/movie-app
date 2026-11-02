import 'package:flutter/material.dart';

class MediaDetailsView extends StatelessWidget {
  const MediaDetailsView({
    super.key,
    required this.title,
    required this.overview,
    required this.backdropUrl,
    required this.rating,
    required this.year,
    required this.popularity,
    this.bottomSection,
  });

  final String title;
  final String overview;
  final String? backdropUrl;
  final double rating;
  final String year;
  final double popularity;
  final Widget? bottomSection;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: const Color(0xFF10101A),
          foregroundColor: Colors.white,
          pinned: true,
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (backdropUrl != null && backdropUrl!.isNotEmpty)
                  Image.network(
                    'https://media.themoviedb.org/t/p/w500$backdropUrl!',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                else
                  _placeholder(),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xFF10101A)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.deepPurpleAccent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      year.isEmpty ? 'Unknown year' : year,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.star_outline, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  overview.isEmpty ? 'No overview available.' : overview,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.7,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Popularity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Colors.deepPurpleAccent,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      popularity.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (bottomSection != null) ...[
                  const SizedBox(height: 23),
                  bottomSection!,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return const ColoredBox(
      color: Color(0xFF252538),
      child: Center(
        child: Icon(Icons.movie_outlined, size: 64, color: Colors.white38),
      ),
    );
  }
}
