import 'package:flutter/material.dart';
import 'package:movie_app/controllers/tv_controller.dart';
import 'package:movie_app/models/tv_model.dart';
import 'package:movie_app/widgets/media_details_view.dart';
import 'package:provider/provider.dart';

class TvDetailsPage extends StatefulWidget {
  const TvDetailsPage({super.key, required this.id});

  final int id;

  @override
  State<TvDetailsPage> createState() => _TvDetailsPageState();
}

class _TvDetailsPageState extends State<TvDetailsPage> {
  late final Future<TvModel> _future;

  @override
  void initState() {
    super.initState();

    _future = context.read<TvProvider>().fetchTvDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10101A),
      body: FutureBuilder<TvModel>(
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
                    'Unable to load TV details',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }

          final tv = snapshot.data;

          if (tv == null) {
            return const Center(
              child: Text(
                'No TV details available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return MediaDetailsView(
            title: tv.name,
            overview: tv.overview,
            backdropUrl: tv.backdropPath,
            rating: tv.voteAverage,
            year: tv.firstAirDate,
            popularity: tv.popularity,
          );
        },
      ),
    );
  }
}
