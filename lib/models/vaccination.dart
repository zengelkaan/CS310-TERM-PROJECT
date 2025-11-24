class Vaccination {
  String title;
  String dateText;
  bool completed;
  bool warning;

  Vaccination({
    required this.title,
    required this.dateText,
    this.completed = false,
    this.warning = false,
  });
}

