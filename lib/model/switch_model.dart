class SwitchCardModel {
  bool status;
  bool actualState;
  String title;

  SwitchCardModel({
    required this.status,
    required this.actualState,
    required this.title,
  });

  SwitchCardModel copyWith({bool? status, bool? actualState}) {
    return SwitchCardModel(
      status: status ?? this.status,
      actualState: actualState ?? this.actualState,
      title: this.title,
    );
  }
}
