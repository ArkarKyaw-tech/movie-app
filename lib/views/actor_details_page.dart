import 'package:flutter/material.dart';
import 'package:movie_app/controllers/actor_controller.dart';
import 'package:movie_app/views/movie_details_page.dart';
import 'package:movie_app/views/tv_details_page.dart';
import 'package:provider/provider.dart';

import '../models/actor_model.dart';
import '../models/known_for_model.dart';

class ActorDetailsPage extends StatefulWidget {
  const ActorDetailsPage({super.key, required this.actorId});

  final int actorId;

  @override
  State<ActorDetailsPage> createState() => _ActorDetailsPageState();
}

class _ActorDetailsPageState extends State<ActorDetailsPage> {
  late final Future<ActorModel> _actorFuture;
  late final Future<List<KnownForModel>> _knownForFuture;

  @override
  void initState() {
    super.initState();

    final provider = context.read<ActorProvider>();

    _actorFuture = provider.fetchActorDetails(widget.actorId);
    _knownForFuture = provider.fetchActorKnownFor(widget.actorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10101A),
      body: FutureBuilder<ActorModel>(
        future: _actorFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _message(
              icon: Icons.cloud_off_outlined,
              message: 'Unable to load actor details.',
            );
          }

          final actor = snapshot.data;

          if (actor == null) {
            return _message(
              icon: Icons.person_outline,
              message: 'Actor information is unavailable.',
            );
          }

          return _buildActorPage(actor);
        },
      ),
    );
  }

  Widget _buildActorPage(ActorModel actor) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 340,
          backgroundColor: const Color(0xFF10101A),
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              actor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (actor.profileUrl != null)
                  Image.network(
                    actor.profileUrl!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => _profilePlaceholder(),
                  )
                else
                  _profilePlaceholder(),
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
                  actor.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (actor.knownForDepartment.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text(
                    actor.knownForDepartment,
                    style: const TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 15,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                _sectionTitle('Biography'),
                const SizedBox(height: 10),
                Text(
                  actor.biography.isEmpty
                      ? 'No biography available.'
                      : actor.biography,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.7,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 28),
                _sectionTitle('Personal Information'),
                const SizedBox(height: 16),
                _infoRow(
                  Icons.cake_outlined,
                  'Birthday',
                  actor.birthday ?? 'Unknown',
                ),
                const SizedBox(height: 14),
                _infoRow(
                  Icons.location_on_outlined,
                  'Place of Birth',
                  actor.placeOfBirth ?? 'Unknown',
                ),
                const SizedBox(height: 28),
                _sectionTitle('Known For'),
                const SizedBox(height: 16),
                _buildKnownFor(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKnownFor(BuildContext context) {
    return FutureBuilder<List<KnownForModel>>(
      future: _knownForFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Text(
            'Unable to load known-for titles.',
            style: TextStyle(color: Colors.white70),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return const Text(
            'No movie or TV credits available.',
            style: TextStyle(color: Colors.white70),
          );
        }

        return SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = items[index];

              return InkWell(
                onTap: () {
                  if (item.mediatype == "movie") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailsPage(id: item.id),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TvDetailsPage(id: item.id),
                      ),
                    );
                  }
                },
                child: SizedBox(
                  width: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 130,
                          height: 175,
                          child: item.posterUrl != null
                              ? Image.network(
                                  item.posterUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _posterPlaceholder(),
                                )
                              : _posterPlaceholder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.releaseDate.toString(),
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 21,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.deepPurpleAccent, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _message({required IconData icon, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white54, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilePlaceholder() {
    return const ColoredBox(
      color: Color(0xFF252538),
      child: Center(
        child: Icon(Icons.person_outline, size: 80, color: Colors.white38),
      ),
    );
  }

  Widget _posterPlaceholder() {
    return const ColoredBox(
      color: Color(0xFF252538),
      child: Center(
        child: Icon(Icons.movie_outlined, size: 40, color: Colors.white38),
      ),
    );
  }
}
