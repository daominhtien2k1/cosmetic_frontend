import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool passToggleOld = true;
  bool passToggleNew = true;
  bool passToggleConfirm = true;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? passwordValidator (String? password) {
    if (password == null || password.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    RegExp regChar = RegExp(r'^[\w_]{6,30}$');
    RegExp regPhone = RegExp(r'^0\d{9}$');
    if(regPhone.hasMatch(password)) {
      return 'Định dạng mật khẩu giống với định dạng điện thoại';
    }
    if(!regChar.hasMatch(password)) {
      return 'Mật khẩu phải từ 6-30 kí tự';
    }
    return null;
  }

  String? validateReEnterPassword(String? reEnterPassword) {
    String? returnedValidateNotify = passwordValidator(reEnterPassword);
    print(returnedValidateNotify);
    if (returnedValidateNotify != null) {
      return returnedValidateNotify;
    } else {
      if (reEnterPassword != _newPasswordController.text) {
        return 'Mật khẩu nhập lại phải giống mật khẩu mới';
      }
    }
    return null;
  }

  final formStateKey = GlobalKey<FormState>();
  void submitForm(BuildContext context) async {
    if (formStateKey.currentState?.validate() ?? true) { // Khi form gọi hàm validate thì tất cả các TextFormField sẽ gọi hàm validate. Hàm validate trả về true là thành công, false là thất bại
      // print('#Validate: Trước khi save: Phone: ${phone} và Password: ${password}');
      formStateKey.currentState?.save(); // khi form gọi hàm save thì tất cả các TextFormField sẽ gọi hàm save

    } else {
      // print('#Validate: Validate thất bại. Vui lòng thử lại');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thay đổi mật khẩu'),
      ),
      body: Form(
        key: formStateKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                    controller: _oldPasswordController,
                    obscureText: passToggleOld,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        //Change this value to custom as you like
                        isDense: true,
                        // and add this line
                        hintText: 'Mật khẩu cũ',
                        suffixIcon: InkWell(
                          onTap:(){
                            setState(() {
                              passToggleOld = !passToggleOld;
                            });
                          },
                          child: Icon(
                              passToggleOld ? Icons.visibility : Icons.visibility_off
                          ),
                        )
                    ),
                    validator: passwordValidator
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                    controller: _newPasswordController,
                    obscureText: passToggleNew,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        //Change this value to custom as you like
                        isDense: true,
                        // and add this line
                        hintText: 'Mật khẩu mới',
                        suffixIcon: InkWell(
                          onTap:(){
                            setState(() {
                              passToggleNew = !passToggleNew;
                            });
                          },
                          child: Icon(
                              passToggleNew ? Icons.visibility : Icons.visibility_off
                          ),
                        )
                    ),
                    validator: passwordValidator
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: passToggleConfirm,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        //Change this value to custom as you like
                        isDense: true,
                        // and add this line
                        hintText: 'Mật khẩu nhập lại',
                        suffixIcon: InkWell(
                          onTap:(){
                            setState(() {
                              passToggleConfirm = !passToggleConfirm;
                            });
                          },
                          child: Icon(
                              passToggleConfirm ? Icons.visibility : Icons.visibility_off
                          ),
                        )
                    ),
                    validator: validateReEnterPassword
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 150, //width of button
                child: ElevatedButton(
                  onPressed: () {
                    submitForm(context);
                  },
                  child: Text('Thay đổi'),
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}
