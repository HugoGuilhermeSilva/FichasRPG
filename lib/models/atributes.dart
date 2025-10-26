class Attributes{
  double base;
  double bonus;
  Attributes({required this.base,this.bonus = 0});
  double get total => base + bonus;
}