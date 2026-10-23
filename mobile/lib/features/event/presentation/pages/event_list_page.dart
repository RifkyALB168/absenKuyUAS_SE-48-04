import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../bloc/event_list_bloc.dart';
import '../bloc/event_list_event.dart';
import '../bloc/event_list_state.dart';
import '../event_dependencies.dart';
import '../widgets/event_card.dart';
import 'event_detail_page.dart';
import 'event_form_page.dart';

/// Daftar kegiatan kelompok (M3.3) dan pintu masuk kelola kegiatan (M3.1, M3.4).
///
/// Sementara memakai repositori dummy lewat [eventRepository]; ganti dengan
/// `EventRepositoryImpl` saat backend REST siap tanpa mengubah halaman ini.
class EventListPage extends StatefulWidget {
  const EventListPage({super.key, this.repository});

  /// Diisi pada pengujian; default memakai [eventRepository].
  final EventRepository? repository;

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  late final EventRepository _repository = widget.repository ?? eventRepository;
  late final EventListBloc _bloc = EventListBloc(_repository);

  @override
  void initState() {
    super.initState();
    _bloc.add(const EventListLoadRequested());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventListBloc>.value(
      value: _bloc,
      child: BlocConsumer<EventListBloc, EventListState>(
        listener: (BuildContext context, EventListState state) {
          final String? message = state.lastMessage;
          if (message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }
        },
        builder: (BuildContext context, EventListState state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Kegiatan'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Muat ulang',
                  onPressed: () => _bloc.add(const EventListLoadRequested()),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add),
              label: const Text('Buat Kegiatan'),
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, EventListState state) {
    if (state.isLoading && state.events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isFailure && state.events.isEmpty) {
      return _ErrorView(
        message: state.errorMessage ?? 'Gagal memuat kegiatan',
        onRetry: () => _bloc.add(const EventListLoadRequested()),
      );
    }

    if (state.isEmpty) {
      return const _EmptyView();
    }

    return RefreshIndicator(
      onRefresh: () async => _bloc.add(const EventListLoadRequested()),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.gap,
          AppTheme.gap,
          AppTheme.gap,
          96,
        ),
        itemCount: state.events.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) {
          final Event event = state.events[index];
          return EventCard(event: event, onTap: () => _openDetail(event));
        },
      ),
    );
  }

  Future<void> _openForm({Event? event}) async {
    final Event? result = await Navigator.of(context).push<Event>(
      MaterialPageRoute<Event>(
        builder: (_) => EventFormPage(repository: _repository, event: event),
      ),
    );
    if (result == null) return;
    if (event == null) {
      _bloc.add(EventAdded(result));
    } else {
      _bloc.add(EventChanged(result));
    }
  }

  Future<void> _openDetail(Event event) async {
    final EventDetailResult? result = await Navigator.of(context)
        .push<EventDetailResult>(
          MaterialPageRoute<EventDetailResult>(
            builder: (_) =>
                EventDetailPage(event: event, repository: _repository),
          ),
        );
    if (result == null) return;
    if (result.deleted) {
      _bloc.add(EventRemoved(event.id));
      return;
    }
    final Event? updated = result.updated;
    if (updated != null) {
      _bloc.add(EventChanged(updated));
    }
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.event_busy_outlined,
              size: 48,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 12),
            Text(
              'Belum Ada Kegiatan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Pengurus kelompok belum menjadwalkan kegiatan baru.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }
}
