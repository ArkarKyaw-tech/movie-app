import 'package:flutter/material.dart';
import 'package:movie_app/controllers/movie_controller.dart';
import 'package:movie_app/models/cast_model.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/widgets/media_details_view.dart';
import 'package:movie_app/widgets/top_bill_cast.dart';
import 'package:provider/provider.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({super.key, required this.id});

  final int id;

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late final Future<MovieModel> _future;
  late final Future<List<CastModel>> _castFuture;

  @override
  void initState() {
    super.initState();

    final provider = context.read<MovieProvider>();

    _future = provider.fetchMovieDetails(widget.id);
    _castFuture = provider.fetchMovieCast(widget.id);
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
            bottomSection: _buildTopBillCast(context),
          );
        },
      ),
    );
  }

 Widget _buildTopBillCast(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Billed Cast',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TopBillCast(castFuture: _castFuture),
      ],
    );
  }
}
