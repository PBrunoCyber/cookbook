import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum DownloadStatus { notDownloaded, downloading, downloaded, fetchingDownload }

class DownloadButtonPage extends StatefulWidget {
  @override
  _DownloadButtonPageState createState() => _DownloadButtonPageState();
}

class _DownloadButtonPageState extends State<DownloadButtonPage> {
  late final List<DownloadController> _downloadControllers;

  @override
  initState() {
    super.initState();
    _downloadControllers = List<DownloadController>.generate(
      20,
      (index) => SimulatedDownloadController(
        onOpenDownload: () => _openDownload(index),
      ),
    );
  }

  void _openDownload(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 400),
        content: Text('Open App ${index + 1}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Download Button"),
      ),
      backgroundColor: Colors.white,
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemCount: _downloadControllers.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: _buildListItem,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final downloadController = _downloadControllers[index];
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.black12,
      ),
      title: Text(
        'App ${index + 1}',
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.headline6,
      ),
      subtitle: Text(
        'Lorem ipsum dolor #${index + 1}',
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.caption,
      ),
      trailing: SizedBox(
        width: 96.0,
        child: AnimatedBuilder(
          animation: downloadController,
          builder: (context, child) {
            return DownloadButton(
              status: downloadController.downloadStatus,
              progress: downloadController.progress,
              onDownload: downloadController.startDownload,
              onCancel: downloadController.stopDownload,
              onOpen: downloadController.openDownload,
            );
          },
        ),
      ),
    );
  }
}

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get downloadStatus;
  double get progress;

  void startDownload();
  void stopDownload();
  void openDownload();
}

class SimulatedDownloadController extends DownloadController
    with ChangeNotifier {
  SimulatedDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required VoidCallback onOpenDownload,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        _onOpenDownload = onOpenDownload;

  DownloadStatus _downloadStatus;
  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;
  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;
  bool _isDownloading = false;

  @override
  void startDownload() {
    if (downloadStatus == DownloadStatus.notDownloaded) {
      _doSimulatedDownload();
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      _isDownloading = false;
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
    }
  }

  @override
  void openDownload() {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
    }
  }

  Future<void> _doSimulatedDownload() async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();

    // Wait a second to simulate fetch time.
    await Future<void>.delayed(const Duration(seconds: 1));

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloading phase.
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();

    const downloadProgressStops = [0.0, 0.15, 0.45, 0.80, 1.0];
    for (final stop in downloadProgressStops) {
      // Wait a second to simulate varying download speeds.
      await Future<void>.delayed(const Duration(seconds: 1));

      // If the user chose to cancel the download, stop the simulation.
      if (!_isDownloading) {
        return;
      }

      // Update the download progress.
      _progress = stop;
      notifyListeners();
    }

    // Wait a second to simulate a final delay.
    await Future<void>.delayed(const Duration(seconds: 1));

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloaded state, completing the simulation.
    _downloadStatus = DownloadStatus.downloaded;
    _isDownloading = false;
    notifyListeners();
  }
}

@immutable
class DownloadButton extends StatefulWidget {
  const DownloadButton({
    Key? key,
    required this.status,
    required this.progress,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  final DownloadStatus status;
  final double progress;
  final Duration transitionDuration;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool get _isDownloading => widget.status == DownloadStatus.downloading;
  bool get _isFetching => widget.status == DownloadStatus.fetchingDownload;
  bool get _isDownloaded => widget.status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (widget.status) {
      case DownloadStatus.notDownloaded:
        widget.onDownload();
        break;
      case DownloadStatus.fetchingDownload:
        // do nothing.
        break;
      case DownloadStatus.downloading:
        widget.onCancel();
        break;
      case DownloadStatus.downloaded:
        widget.onOpen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          _buildButtonShape(child: _buildText()),
          _buildDownloadProgress()
        ],
      ),
    );
  }

  Widget _buildButtonShape({required Widget child}) {
    return AnimatedContainer(
      duration: widget.transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: _isDownloading || _isFetching
          ? ShapeDecoration(
              shape: const CircleBorder(),
              color: Colors.white.withOpacity(0.0),
            )
          : ShapeDecoration(
              shape: StadiumBorder(),
              color: CupertinoColors.lightBackgroundGray,
            ),
      child: child,
    );
  }

  Widget _buildText() {
    final String text = _isDownloaded ? "Abrir" : "Baixar";
    final double opacity = _isDownloading || _isFetching ? 0.0 : 1.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: AnimatedOpacity(
        duration: widget.transitionDuration,
        opacity: opacity,
        curve: Curves.ease,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: _isDownloaded ? Colors.blue : Colors.black),
        ),
      ),
    );
  }

  Widget _buildDownloadProgress() {
    return Positioned.fill(
      child: Center(
        child: AnimatedOpacity(
          duration: widget.transitionDuration,
          opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
          curve: Curves.ease,
          child: Stack(
            children: [
              _buildProgressIndicator(),
              if (_isDownloading)
                const Center(
                    child: Icon(
                  Icons.stop,
                  size: 14,
                  color: Colors.black,
                )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: widget.progress),
          duration: Duration(milliseconds: 100),
          builder: (context, double progress, Widget? child) =>
              CircularProgressIndicator(
            backgroundColor: _isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.white.withOpacity(0.0),
            valueColor: AlwaysStoppedAnimation(_isFetching
                ? CupertinoColors.lightBackgroundGray
                : Colors.black),
            strokeWidth: 2.0,
            value: _isFetching ? null : progress,
          ),
        ),
      ),
    );
  }
}
