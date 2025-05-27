import 'package:flutter/material.dart';
import 'package:sad_final/movie.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<Movie> movies = [];

  void addMovie(Movie movie) {
    setState(() {
      movies.add(movie);
    });
  }

  void editMovie(int index, Movie movie) {
    setState(() {
      movies[index] = movie;
    });
  }

  void deleteMovie(int index) {
    setState(() {
      movies.removeAt(index);
    });
  }

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green.shade50,
        title: Text('Delete Movie', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${movies[index].title}"?', style: TextStyle(color: Colors.green.shade900)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.green.shade800)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () {
              deleteMovie(index);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void openMovie(Movie movie) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.green.shade100,
        title: Text(movie.title, style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(movie.description, style: TextStyle(color: Colors.green.shade800)),
              const SizedBox(height: 12),
              Text('Rating: ${movie.rating.toStringAsFixed(1)} / 10', style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Status: ${movie.status}', style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.green.shade900)),
          ),
        ],
      ),
    );
  }

  void showAddDialog({Movie? movie, int? index}) {
    final titleController = TextEditingController(text: movie?.title ?? '');
    final descController = TextEditingController(text: movie?.description ?? '');
    final ratingController = TextEditingController(text: movie != null ? movie.rating.toString() : '');
    String status = movie?.status ?? 'Watching';
    String? errorText;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          void validateAndSave() {
            final title = titleController.text.trim();
            final desc = descController.text.trim();
            final ratingText = ratingController.text.trim();
            if (title.isEmpty || desc.isEmpty || (status == 'Watched' && ratingText.isEmpty)) {
              setState(() {
                errorText = 'All fields are required (Rating for Watched)';
              });
              return;
            }
            final rating = double.tryParse(ratingText) ?? 0.0;
            if ((status == 'Watched') && (rating < 0 || rating > 10)) {
              setState(() {
                errorText = 'Rating must be between 0 and 10';
              });
              return;
            }
            final newMovie = Movie(title: title, description: desc, rating: rating, status: status);
            if (movie == null) {
              addMovie(newMovie);
            } else if (index != null) {
              editMovie(index, newMovie);
            }
            Navigator.pop(context);
          }

          return AlertDialog(
            backgroundColor: Colors.green.shade50,
            title: Text(movie == null ? 'Add Movie' : 'Edit Movie', style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(isDense: true, labelText: 'Title', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          isDense: true,
                          value: status,
                          onChanged: (value) => setState(() => status = value!),
                          items: ['Watching', 'Watched', 'Plan to Watch']
                              .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13))))
                              .toList(),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: ratingController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: 'Rating',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: InputDecoration(isDense: true, labelText: 'Description', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                  ),
                  if (errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(errorText!, style: TextStyle(color: Colors.red.shade700, fontSize: 13)),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.green.shade800)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800),
                onPressed: validateAndSave,
                child: Text(movie == null ? 'Add' : 'Save', style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: movies.isEmpty
          ? Center(child: Text('No movies added.', style: TextStyle(color: Colors.green.shade300, fontSize: 16)))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.green.shade600,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                        const SizedBox(height: 6),
                        Text(
                          '${movie.description}\nRating: ${movie.rating.toStringAsFixed(1)} / 10\nStatus: ${movie.status}',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(icon: const Icon(Icons.file_open_rounded, color: Colors.white70), onPressed: () => openMovie(movie)),
                      IconButton(icon: const Icon(Icons.edit_note_outlined, color: Colors.white70), onPressed: () => showAddDialog(movie: movie, index: index)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => confirmDelete(index)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        onPressed: () => showAddDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Add Movie',
      ),
    );
  }
}
