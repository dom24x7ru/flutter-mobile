// {id: 1, personId: 1, flatId: 423, isOwner: false, createdAt: 2020-11-08T14:11:27.181Z, updatedAt: 2020-11-08T14:11:27.181Z, flat: {id: 423, houseId: 1, number: 423, section: 4, floor: 10, rooms: 3, square: 91.4, createdAt: 2020-11-08T14:10:20.779Z, updatedAt: 2021-01-26T10:53:42.009Z}}
class Resident {
  late int personId;
  bool? isOwner;
  bool? deleted;

  Resident(this.personId);
  Resident.fromMap(Map<String, dynamic> map) {
    personId = map['personId'];
    isOwner = map['isOwner'];
    deleted = map['deleted'];
  }
}