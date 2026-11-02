import 'package:flutter/material.dart';
import 'package:movie_app/models/cast_model.dart';
import 'package:movie_app/views/actor_details_page.dart';

class TopBillCast extends StatelessWidget {
  final Future<List<CastModel>> castFuture;

  const TopBillCast({super.key, required this.castFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: castFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Center(
                  child: const Icon(
                    Icons.cloud_off_outlined,
                    size: 32,
                    color: Colors.white54,
                  ),
                ),
                const Text(
                  'Unable to load cast',
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton.icon(
                  onPressed: () {
                    //Navigator.of(context).pushReplacement();
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(""),
                ),
              ],
            ),
          );
        }

        final cast = snapshot.data ?? [];

        if (cast.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No cast information available.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return SizedBox(
          height: 235,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final actor = cast[index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActorDetailsPage(actorId: actor.id),
                    ),
                  );
                },
                child: SizedBox(
                  width: 115,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 115,
                          height: 150,
                          child: actor.profileUrl != null
                              ? Image.network(
                                  actor.profileUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _placeHolder(),
                                )
                              : _placeHolder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        actor.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        actor.character,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemCount: cast.length,
          ),
        );
      },
    );
  }

  // Image PlaceHolder
  _placeHolder() {
    return ColoredBox(
      color: Color(0xFF252538),
      child: Center(
        child: Icon(Icons.person_outline, color: Colors.white54, size: 42),
      ),
    );
  }
}
