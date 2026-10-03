num getAvgRating(List<dynamic> reviews) {
  if (reviews.isEmpty) return 0;
  var sum = 0.0;
  var count = 0;
  for (var review in reviews) {
    try {
      if (review == null) continue;
      // If it's a Map with a 'rating' key
      if (review is Map && review.containsKey('rating')) {
        final val = review['rating'];
        if (val is num) {
          sum += val.toDouble();
          count++;
        } else if (val is String) {
          final parsed = num.tryParse(val);
          if (parsed != null) {
            sum += parsed.toDouble();
            count++;
          }
        }
      } else if (review is Map && review['rating'] == null) {
        // skip
      } else {
        // Try to access .rating property
        final val = (review as dynamic).rating;
        if (val is num) {
          sum += val.toDouble();
          count++;
        } else if (val is String) {
          final parsed = num.tryParse(val);
          if (parsed != null) {
            sum += parsed.toDouble();
            count++;
          }
        }
      }
    } catch (_) {
      // ignore invalid review entries
      continue;
    }
  }

  if (count == 0) return 0;
  return sum / count;
}
