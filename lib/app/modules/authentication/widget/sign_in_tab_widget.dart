part of '../views/authentication_view.dart';

class SignInTabWidget extends StatelessWidget {
  const SignInTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AuthenticationController>();
    return FormBuilder(
      key: controller.formSignInKey,
      child: ListView(
        padding: const EdgeInsets.all(15.0),
        physics: const BouncingScrollPhysics(), //remove Glow effect
        children: <Widget>[
          ...buildTextField_UserNamePassWord(),
          const SizedBox(height: 15.0),
          StatefulBuilder(
              builder: (context, setState) => CheckboxListTile(
                    activeColor: Colors.green,
                    title: Text(TranslateKeys.RememberPassword.tr()),
                    value: controller.isRememberPassword,
                    onChanged: (value) => setState(() => controller.isRememberPassword = value!),
                  )),
          const SizedBox(height: 15.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ElevatedButton(
              onPressed: () => controller.onSignIn(),
              child: Text(TranslateKeys.SignIn.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> buildTextField_UserNamePassWord() => [
      FormBuilderTextField(
        name: 'email',
        initialValue: 'eva.brunet@example.com', //
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: CustomPrefixIconWidget(
            icon: const Icon(Icons.email, color: Colors.green),
            color: Colors.greenAccent.withOpacity(0.5),
          ),
          // suffixIcon: Icon(
          //   Icons.check_circle,
          //   color: Colors.black26,
          // ),
          labelText: '${TranslateKeys.Email.tr()}',
          // hintStyle: const TextStyle(color: Colors.yellow),
          filled: true,
          fillColor: Colors.lightBlueAccent.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
        ),
        // style: TextStyle(color: Theme.of(context).colorScheme.primary),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
      ),
      const SizedBox(height: 15.0),
      FormBuilderTextField(
        name: 'password',
        initialValue: 'password',
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: CustomPrefixIconWidget(
            icon: const Icon(Icons.key, color: Colors.pinkAccent),
            color: Colors.yellowAccent.withOpacity(0.5),
          ),
          // suffixIcon: Icon(
          //   Icons.check_circle,
          //   color: Colors.black26,
          // ),
          labelText: '${TranslateKeys.Password.tr()}',
          // hintStyle: const TextStyle(color: Colors.yellow),
          filled: true,
          fillColor: Colors.lightBlueAccent.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
      ),
    ];
