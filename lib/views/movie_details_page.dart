import 'package:flutter/material.dart';
import 'package:movie_app/controllers/movie_controller.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/widgets/media_details_view.dart';
import 'package:provider/provider.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({super.key, required this.id});

  final int id;

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late final Future<MovieModel> _future;

  @override
  void initState() {
    super.initState();

    _future = context.read<MovieProvider>().fetchMovieDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10101A),
      body: FutureBuilder<MovieModel>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_off_outlined,
                    size: 48,
                    color: Colors.white54,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Unable to load movie details',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }

          final movie = snapshot.data;

          if (movie == null) {
            return const Center(
              child: Text(
                'No movie details available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return MediaDetailsView(
            title: movie.title,
            overview: movie.overview,
            backdropUrl: movie.backdropPath,
            rating: movie.voteAverage,
            year: movie.releaseDate,
            popularity: movie.popularity,
          );
        },
      ),
    );
  }
}
