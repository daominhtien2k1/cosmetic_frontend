import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';

class NnStreamChatLocalizationsDelegate
    extends LocalizationsDelegate<StreamChatLocalizations> {
  const NnStreamChatLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'vi';

  @override
  Future<StreamChatLocalizations> load(Locale locale) =>
      SynchronousFuture(const NnStreamChatLocalizations());

  @override
  bool shouldReload(NnStreamChatLocalizationsDelegate old) => false;
}

/// A custom set of localizations for the 'nn' locale. In this example, only
/// the value for launchUrlError was modified to use a custom message as
/// an example. Everything else uses the American English (en_US) messages
/// and formatting.
class NnStreamChatLocalizations extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for English.
  const NnStreamChatLocalizations({super.localeName = 'vi'});

  /// A [LocalizationsDelegate] for [NnStreamChatLocalizations].
  static const delegate = NnStreamChatLocalizationsDelegate();

  @override
  String get launchUrlError => 'Tải Url lỗi';

  @override
  String get loadingUsersError => 'Lỗi khi tải người dùng';

  @override
  String get noUsersLabel => 'Hiện không có người dùng';

  @override
  String get noPhotoOrVideoLabel => 'Không có ảnh hoặc video';

  @override
  String get retryLabel => 'Thử lại';

  @override
  String get userLastOnlineText => 'Lần cuối trực tuyến';

  @override
  String get userOnlineText => 'Trực tuyến';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} đang nhập';
    }
    return '${first.name} và ${users.length - 1} người khác đang nhập';
  }

  @override
  String get threadReplyLabel => 'Phản hồi luồng con';

  @override
  String get onlyVisibleToYouText => 'Chỉ bạn có thể nhìn thấy';

  @override
  String threadReplyCountText(int count) => '$count phản hồi luồng con';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      'Đang tải lên $remaining/$total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Đã ghim bởi bạn';
    return 'Đã ghim bởi ${pinnedBy.name}';
  }

  @override
  String get sendMessagePermissionError =>
      "Bạn không có quyền gửi tin nhắn";

  @override
  String get emptyMessagesText => 'Hiện không có tin nhắn nào';

  @override
  String get genericErrorText => 'Đã xảy ra lỗi';

  @override
  String get loadingMessagesError => 'Lỗi khi tải tin nhắn';

  @override
  String resultCountText(int count) => '$count kết quả';

  @override
  String get messageDeletedText => 'Tin nhắn này đã bị xóa.';

  @override
  String get messageDeletedLabel => 'Tin nhắn đã bị xóa';

  @override
  String get messageReactionsLabel => 'Cảm xúc tin nhắn';

  @override
  String get emptyChatMessagesText => 'Chưa có cuộc trò chuyện nào ở đây...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 phản hồi';
    return '$replyCount phản hồi';
  }

  @override
  String get connectedLabel => 'Đã kết nối';

  @override
  String get disconnectedLabel => 'Đã ngắt kết nối';

  @override
  String get reconnectingLabel => 'Đang kết nối lại...';

  @override
  String get alsoSendAsDirectMessageLabel => 'Đồng thời gửi như tin nhắn trực tiếp';

  @override
  String get addACommentOrSendLabel => 'Thêm bình luận hoặc gửi';

  @override
  String get searchGifLabel => 'Tìm kiếm GIF';

  @override
  String get writeAMessageLabel => 'Viết tin nhắn';

  @override
  String get instantCommandsLabel => 'Lệnh tức thì';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'Tệp quá lớn để tải lên. '
          'Giới hạn kích thước tệp là $limitInMB MB. '
          'Chúng tôi đã cố gắng nén nó, nhưng không đủ.';

  @override
  String fileTooLargeError(double limitInMB) =>
      'Tệp quá lớn để tải lên. Giới hạn kích thước tệp là $limitInMB MB.';

  @override
  String get couldNotReadBytesFromFileError =>
      'Không thể đọc dữ liệu từ tệp.';

  @override
  String get addAFileLabel => 'Thêm một tệp';

  @override
  String get photoFromCameraLabel => 'Ảnh từ máy ảnh';

  @override
  String get uploadAFileLabel => 'Tải lên một tệp';

  @override
  String get uploadAPhotoLabel => 'Tải lên một ảnh';

  @override
  String get uploadAVideoLabel => 'Tải lên một video';

  @override
  String get videoFromCameraLabel => 'Video từ máy ảnh';

  @override
  String get okLabel => 'OK';

  @override
  String get somethingWentWrongError => 'Đã xảy ra lỗi';

  @override
  String get addMoreFilesLabel => 'Thêm nhiều tệp';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'Vui lòng cho phép truy cập vào ảnh'
          '\nvà video của bạn để bạn có thể chia sẻ chúng với bạn bè.';

  @override
  String get allowGalleryAccessMessage => 'Cho phép truy cập vào bộ sưu tập';

  @override
  String get flagMessageLabel => 'Gắn cờ tin nhắn';

  @override
  String get flagMessageQuestion =>
      'Bạn có muốn gửi một bản sao của tin nhắn này đến'
          '\nmột quản trị viên để điều tra tiếp?';

  @override
  String get flagLabel => 'GẮN CỜ';

  @override
  String get cancelLabel => 'HỦY';

  @override
  String get flagMessageSuccessfulLabel => 'Tin nhắn đã được gắn cờ';

  @override
  String get flagMessageSuccessfulText =>
      'Tin nhắn đã được báo cáo cho một quản trị viên.';

  @override
  String get deleteLabel => 'XOÁ';

  @override
  String get deleteMessageLabel => 'Xóa tin nhắn';

  @override
  String get deleteMessageQuestion =>
      'Bạn có chắc chắn muốn xóa tin nhắn này\nvĩnh viễn?';

  @override
  String get operationCouldNotBeCompletedText =>
      "Không thể hoàn thành thao tác.";

  @override
  String get replyLabel => 'Phản hồi';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Bỏ ghim từ Cuộc trò chuyện';
    return 'Ghim vào Cuộc trò chuyện';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Thử lại xóa tin nhắn';
    return 'Xóa tin nhắn';
  }

  @override
  String get copyMessageLabel => 'Sao chép tin nhắn';

  @override
  String get editMessageLabel => 'Chỉnh sửa tin nhắn';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Gửi lại tin nhắn đã chỉnh sửa';
    return 'Gửi lại';
  }

  @override
  String get photosLabel => 'Ảnh';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'hôm nay';
    } else if (date == yesterday) {
      return 'hôm qua';
    } else {
      return 'vào lúc ${Jiffy(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) =>
      'Đã gửi ${_getDay(date)} vào lúc ${Jiffy(time.toLocal()).format('HH:mm')}';

  @override
  String get todayLabel => 'Hôm nay';

  @override
  String get yesterdayLabel => 'Hôm qua';

  @override
  String get channelIsMutedText => 'Kênh đã được tắt tiếng';

  @override
  String get noTitleText => 'Không có tiêu đề';

  @override
  String get letsStartChattingLabel => 'Bắt đầu trò chuyện!';

  @override
  String get sendingFirstMessageLabel =>
      'Có thể thử gửi tin nhắn đầu tiên đến một người bạn xem sao?';

  @override
  String get startAChatLabel => 'Bắt đầu cuộc trò chuyện';

  @override
  String get loadingChannelsError => 'Lỗi khi tải kênh';

  @override
  String get deleteConversationLabel => 'Xóa cuộc trò chuyện';

  @override
  String get deleteConversationQuestion =>
      'Bạn có chắc chắn muốn xóa cuộc trò chuyện này?';

  @override
  String get streamChatLabel => 'Stream Chat';

  @override
  String get searchingForNetworkText => 'Đang tìm kiếm mạng';

  @override
  String get offlineLabel => 'Ngoại tuyến...';

  @override
  String get tryAgainLabel => 'Thử lại';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 thành viên';
    return '$count thành viên';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 trực tuyến';
    return '$count trực tuyến';
  }

  @override
  String get viewInfoLabel => 'Xem thông tin';

  @override
  String get leaveGroupLabel => 'Rời nhóm';

  @override
  String get leaveLabel => 'RỜI';

  @override
  String get leaveConversationLabel => 'Rời cuộc trò chuyện';

  @override
  String get leaveConversationQuestion =>
      'Bạn có chắc chắn muốn rời cuộc trò chuyện này?';

  @override
  String get showInChatLabel => 'Hiển thị trong Cuộc trò chuyện';

  @override
  String get saveImageLabel => 'Lưu ảnh';

  @override
  String get saveVideoLabel => 'Lưu video';

  @override
  String get uploadErrorLabel => 'LỖI TẢI LÊN';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Xáo trộn';

  @override
  String get sendLabel => 'Gửi';

  @override
  String get withText => 'với';

  @override
  String get inText => 'trong';

  @override
  String get youText => 'Bạn';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) =>
      '$currentPage của $totalPages';

  @override
  String get fileText => 'Tệp';

  @override
  String get replyToMessageLabel => 'Trả lời tin nhắn';

  @override
  String attachmentLimitExceedError(int limit) =>
      'Vượt quá giới hạn đính kèm, giới hạn: $limit';

  @override
  String get slowModeOnLabel => 'Chế độ chậm ĐÃ BẬT';

  @override
  String get downloadLabel => 'Tải xuống';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return 'Bỏ tắt âm thanh người dùng';
    } else {
      return 'Tắt âm thanh người dùng';
    }
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Bạn có chắc chắn muốn bỏ tắt âm thanh cho nhóm này?';
    } else {
      return 'Bạn có chắc chắn muốn tắt âm thanh cho nhóm này?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Bạn có chắc chắn muốn bỏ tắt âm thanh cho người dùng này?';
    } else {
      return 'Bạn có chắc chắn muốn tắt âm thanh cho người dùng này?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'BỎ TẮT';
    } else {
      return 'TẮT';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Bỏ tắt âm thanh nhóm';
    } else {
      return 'Tắt âm thanh nhóm';
    }
  }

  @override
  String get linkDisabledDetails =>
      'Không được phép gửi liên kết trong cuộc trò chuyện này.';

  @override
  String get linkDisabledError => 'Liên kết đã bị vô hiệu hóa';

  @override
  String get viewLibrary => 'Xem thư viện';

  @override
  String unreadMessagesSeparatorText(int unreadCount) => 'Tin nhắn mới';

  @override
  String get enableFileAccessMessage => 'Bật quyền truy cập vào tệp để tiếp tục';

  @override
  String get allowFileAccessMessage => 'Cho phép truy cập vào tệp';
}