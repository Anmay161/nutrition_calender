class Item {
  String name;
  bool state;
  Item(this.name, this.state);
}

class EatingTime {
  List<Item> breakfast = [];
  List<Item> lunch = [];
  List<Item> dinner = [];
  List<Item> other = [];
}

Map<String, EatingTime> check = {
  "2025-08-16":
      EatingTime()
        ..breakfast = [
          Item("Eggs", false),
          Item("Toast", true),
          Item("Coffee", false),
        ]
        ..lunch = [
          Item("Rice", false),
          Item("Chicken Curry", true),
          Item("Salad", false),
        ]
        ..dinner = [Item("Pizza", false), Item("Pasta", false)]
        ..other = [Item("Snacks", true), Item("Juice", false)],

  "2025-08-17":
      EatingTime()
        ..breakfast = [Item("Pancakes", false), Item("Milk", true)]
        ..lunch = [Item("Burger", false), Item("Fries", false)]
        ..dinner = [Item("Fish", false), Item("Rice", true)]
        ..other = [Item("Ice Cream", false)],

  "2025-08-18":
      EatingTime()
        ..breakfast = [
          Item("Bread", true),
          Item("Butter", false),
          Item("Tea", false),
        ]
        ..lunch = [Item("Sandwich", false), Item("Soup", true)]
        ..dinner = [Item("Steak", false), Item("Mashed Potatoes", false)]
        ..other = [Item("Cookies", false), Item("Smoothie", true)],
};

var getdate = DateTime.now().toString().split(' ').first;
