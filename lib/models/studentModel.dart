class StudentModel {
  int gender;
  int stuClass;
  int seat;
  int iD;
  String name;

  StudentModel({this.gender, this.stuClass, this.seat, this.iD, this.name});

  StudentModel.fromJson(Map<String, dynamic> json) {
    gender = json['Gender'];
    stuClass = json['Class'];
    seat = json['Seat'];
    iD = json['ID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Gender'] = this.gender;
    data['Class'] = this.stuClass;
    data['Seat'] = this.seat;
    data['ID'] = this.iD;
    data['Name'] = this.name;
    return data;
  }
}
