import 'package:form_field_validator/form_field_validator.dart';

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: 'Enter a valid Email address'),
]);
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
]);

final usernameValidator = MultiValidator([
  RequiredValidator(errorText: 'Username is required'),
  MinLengthValidator(3, errorText: 'Username must be at least 3 digits long'),
]);

final productNameValidator = MultiValidator([
  RequiredValidator(errorText: 'Product name is required'),
]);

final itemNameValidator = MultiValidator([
  RequiredValidator(errorText: 'Item name is required'),
]);

final userNameValidator = MultiValidator([
  RequiredValidator(errorText: 'name is required'),
]);

final pantryValidator = MultiValidator([
  RequiredValidator(errorText: 'Pantry name is required'),
]);

final categoryValidator = MultiValidator([
  RequiredValidator(errorText: 'Category name is required'),
]);

final shoppingTitleValidator = MultiValidator([
  RequiredValidator(errorText: 'Shopping List title is required'),
]);

final entryDateValidator = MultiValidator([
  RequiredValidator(errorText: 'Entry date is required'),
]);

final expiryDateValidator = MultiValidator([
  RequiredValidator(errorText: 'Expiry date is required'),
]);