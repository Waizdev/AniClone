import 'package:flutter/material.dart';
import 'package:projects/Screens/AnimeDetailScreen.dart';
import 'package:projects/api/JikanService.dart';
import 'package:projects/models/anime.dart';
import 'package:projects/services/my_list_storage.dart';

class Schedulescreen extends StatefulWidget {
  const Schedulescreen({
    super.key,
    required this.accentColor,
  });

  final Color accentColor;

  @override
  State<Schedulescreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<Schedulescreen> {
  final JikanService _service = JikanService();
  static const int _anchorIndex = 10000;
  static const int _virtualItemCount = 20001;
  static const double _dateChipWidth = 50;
  static const double _dateChipSpacing = 10;
  static const double _monthSeparatorLead = 15;
  late final ScrollController _dateScrollController;
  final DateTime _baseDate = DateTime.now();

  int _selectedDateIndex = _anchorIndex;
  int _firstVisibleDateIndex = _anchorIndex;
  List<Anime> _airingAnime = const [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dateScrollController = ScrollController(
      initialScrollOffset:
          _anchorIndex * (_dateChipWidth + _dateChipSpacing),
    );
    _dateScrollController.addListener(_handleDateStripScroll);
    _loadSchedule();
  }

  @override
  void dispose() {
    _dateScrollController.removeListener(_handleDateStripScroll);
    _dateScrollController.dispose();
    super.dispose();
  }

  void _handleDateStripScroll() {
    final itemExtent = _dateChipWidth + _dateChipSpacing;
    final rawIndex = ((_dateScrollController.offset + _monthSeparatorLead) /
            itemExtent)
        .floor();
    final newIndex = rawIndex.clamp(0, _virtualItemCount - 1);
    if (newIndex == _firstVisibleDateIndex) return;

    setState(() {
      _firstVisibleDateIndex = newIndex;
    });
  }

  String _weekdayFilter(DateTime date) {
    const days = <String>[
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[date.weekday - 1];
  }

  String _weekdayLabel(DateTime date) {
    const days = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _monthLabel(DateTime date) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }

  String _broadcastTime(String broadcast) {
    final match = RegExp(r'\b\d{1,2}:\d{2}\b').firstMatch(broadcast);
    return match?.group(0) ?? '--:--';
  }

  Future<void> _loadSchedule() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final selectedDate = _dateFromIndex(_selectedDateIndex);
      final day = _weekdayFilter(selectedDate);
      final anime = await _service.getScheduleByDay(day);

      if (!mounted) return;
      setState(() {
        _airingAnime = anime;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load schedule. Pull to retry.';
        _isLoading = false;
      });
    }
  }

  DateTime _dateFromIndex(int index) {
    return DateTime(
      _baseDate.year,
      _baseDate.month,
      _baseDate.day + (index - _anchorIndex),
    );
  }

  Future<void> _onSelectDate(int index) async {
    if (_selectedDateIndex == index) return;
    setState(() {
      _selectedDateIndex = index;
    });
    await _loadSchedule();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  SizedBox(
                    width: 62,
                    child: Center(
                      child: Text(
                        _monthLabel(_dateFromIndex(_firstVisibleDateIndex)),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: _dateScrollController,
                      padding: const EdgeInsets.only(right: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _virtualItemCount,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final date = _dateFromIndex(index);
                        final isSelected = _selectedDateIndex == index;

                        return GestureDetector(
                          onTap: () => _onSelectDate(index),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.centerLeft,
                            children: [
                              Row(
                                children: [
                                  if (date.day == 1) ...[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _monthLabel(date),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface
                                                .withValues(alpha: .7),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          width: 1.3,
                                          height: 24,
                                          color: colorScheme.outline
                                              .withValues(alpha: 0.55),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                  ],
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: _dateChipWidth,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? widget.accentColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(34),
                                      border: Border.all(
                                        color: isSelected
                                            ? widget.accentColor
                                            : colorScheme.outline
                                                .withValues(alpha: 0.6),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _weekdayLabel(date),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? Colors.white
                                                : colorScheme.onSurface
                                                    .withValues(alpha: .8),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${date.day}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : colorScheme.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: AnimatedBuilder(
                animation: MyListStorage.instance,
                builder: (context, _) {
                  if (_isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_errorMessage != null) {
                    return RefreshIndicator(
                      onRefresh: _loadSchedule,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (_airingAnime.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _loadSchedule,
                      child: ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 120),
                          Center(child: Text('No schedule for selected day')),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _loadSchedule,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      itemCount: _airingAnime.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final anime = _airingAnime[index];
                        final isAdded = MyListStorage.instance.isAdded(anime);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: widget.accentColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _broadcastTime(anime.broadcast),
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AnimeDetailScreen(anime: anime),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.network(
                                          anime.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: colorScheme.surfaceContainer,
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.broken_image_outlined,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          anime.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          anime.episodes > 0 ? 'Episode ${anime.episodes}' : 'Episode TBA',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 38,
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              if (isAdded) {
                                                await MyListStorage.instance.removeAnime(anime);
                                              } else {
                                                await MyListStorage.instance.addAnime(anime);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: widget.accentColor,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 14,
                                              ),
                                            ),
                                            icon: Icon(
                                              isAdded ? Icons.check : Icons.add,
                                            ),
                                            label: Text(
                                              isAdded ? 'Added' : 'My List',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
