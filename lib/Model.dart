class Model {
  final String image;
  final String value;
  final String name;
  bool accepted;
  Model(
      {this.accepted = false,
      required this.name,
      required this.image,
      required this.value});
}
