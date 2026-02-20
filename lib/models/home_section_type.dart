enum HomeSectionType {
  topAiring,
  mostPopular,
  topTvSeries,
}

String titleForType(HomeSectionType type) {
  switch (type) {
    case HomeSectionType.topAiring:
      return 'Top Airing';
    case HomeSectionType.mostPopular:
      return 'Most Popular';
    case HomeSectionType.topTvSeries:
      return 'Top TV Series';
  }
}
