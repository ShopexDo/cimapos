class ProfileModel {
  int _id;
  String _fName;
  String _lName;
  String _email;
  String _phone;
  String _password;
  String _image;


  ProfileModel(
      {int id,
        String fName,
        String lName,
        String email,
        String phone,
        String password,
        String image,
       }) {
    if (id != null) {
      this._id = id;
    }
    if (fName != null) {
      this._fName = fName;
    }
    if (lName != null) {
      this._lName = lName;
    }
    if (email != null) {
      this._email = email;
    }
    if (phone != null) {
      this._phone = phone;
    }
    if (password != null) {
      this._password = password;
    }
    if (image != null) {
      this._image = image;
    }
 
  }

  int get id => _id;
  String get fName => _fName;
  String get lName => _lName;
  String get email => _email;
  String get phone => _phone;
  String get password => _password;
  String get image => _image;

  

  ProfileModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _email = json['email'];
    _phone = json['phone'];
    _password = json['password'];
    _image = json['image'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['f_name'] = this._fName;
    data['l_name'] = this._lName;
    data['email'] = this._email;
    data['phone'] = this._phone;
    data['password'] = this._password;
    data['image'] = this._image;
    return data;
  }
}
