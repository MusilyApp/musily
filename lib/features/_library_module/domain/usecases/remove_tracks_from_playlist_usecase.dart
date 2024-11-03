abstract class RemoveTracksFromPlaylistUsecase {
  Future<void> exec(String playlistId, List<String> trackIds);
}
