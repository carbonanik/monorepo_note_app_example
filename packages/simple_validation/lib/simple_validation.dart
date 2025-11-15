// class Validator {
//   final String? message;

//   Validator(this.message);

//   String? required(String? value) {
//     if (value == null || value.isEmpty) {
//       return message ?? 'Field is required';
//     }
//     return null;
//   }

//   static String? requiredPhone(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your mobile number';
//     } else if (value.length < 11) {
//       return "Mobile number should be at least 11 digits";
//     }
//     return null;
//   }

//   static String? requiredEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email is required';
//     } else if (!value.contains('@')) {
//       return 'Must be a valid email';
//     }
//     return null;
//   }
// }

class Validator {
  // final String value;
  Validator();

  final List<String? Function(String? value)> _validationRules = [];

  bool _isValueEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  Validator require(String message) {
    _validationRules.add((String? value) {
      if (_isValueEmpty(value)) {
        return message;
      }
      return null;
    });
    return this;
  }

  // must be exac length
  Validator exactLength(int length, String message) {
    _validationRules.add((String? value) {
      if (_isValueEmpty(value)) return null;
      if (value!.length != length) {
        return message;
      }
      return null;
    });
    return this;
  }

  Validator minLength(int length, String message) {
    _validationRules.add((String? value) {
      if (_isValueEmpty(value)) return null;
      if (value!.length < length) {
        return message;
      }
      return null;
    });
    return this;
  }

  Validator maxLength(int length, String message) {
    _validationRules.add((String? value) {
      if (_isValueEmpty(value)) return null;
      if (value!.length > length) {
        return message;
      }
      return null;
    });
    return this;
  }

  // must be a number
  Validator isNumber(String message) {
    _validationRules.add((String? value) {
      if (_isValueEmpty(value)) return null;
      if (!RegExp(r'^[0-9]+$').hasMatch(value!)) {
        return message;
      }
      return null;
    });
    return this;
  }

  // must be a valid email
  Validator isEmail(String message) {
    _validationRules.add((String? value) {
      if (_isValueEmpty(value)) return null;
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(value!)) {
        return message;
      }
      return null;
    });
    return this;
  }

  Validator startsWith(String prefix, String message) {
    _validationRules.add((String? value) {
      if (_isValueEmpty(value)) return null;
      if (!value!.startsWith(prefix)) {
        return message;
      }
      return null;
    });
    return this;
  }

  Validator matchRegex(String regex, String message) {
    _validationRules.add((String? value) {
      if (_isValueEmpty(value)) return null;
      if (!RegExp(regex).hasMatch(value!)) {
        return message;
      }
      return null;
    });
    return this;
  }

  Validator isEqualTo(String match, String message) {
    _validationRules.add((String? value) {
      if (_isValueEmpty(value)) return null;
      if (value != match) {
        return message;
      }
      return null;
    });
    return this;
  }

  Validator customValidation(
    String? Function(String? value) validationFunction,
  ) {
    _validationRules.add((String? value) {
      if (_isValueEmpty(value)) return null;
      final result = validationFunction(value);
      if (result != null) {
        return result;
      }
      return null;
    });
    return this;
  }

  String? validate(String? value) {
    for (var rule in _validationRules) {
      final result = rule(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}


class Validator2 {
  final List<ValidationRule> _validationRules = [];
  Validator2({List<ValidationRule>? rules}) {
    if (rules != null) {
      _validationRules.addAll(rules);
    }
  }

  String? validate(String? value) {
    for (var rule in _validationRules) {
      final result = rule.execute(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {'rules': _validationRules.map((rule) => rule.toJson()).toList()};
  }

  factory Validator2.fromJson(Map<String, dynamic> json) {
    final rules =
        (json['rules'] as List)
            .map((rule) => _createRuleFromJson(rule as Map<String, dynamic>))
            .toList();
    return Validator2(rules: rules);
  }

  static ValidationRule _createRuleFromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'require':
        return Require(json['message']);
      case 'exactLength':
        return ExactLength(json['length'], json['message']);
      case 'minLength':
        return MinLength(json['length'], json['message']);
      case 'maxLength':
        return MaxLength(json['length'], json['message']);
      case 'isEmail':
        return IsEmail(json['message']);
      case 'isNumber':
        return IsNumber(json['message']);
      case 'startsWith':
        return StartsWith(json['prefix'], json['message']);
      case 'matchRegex':
        return MatchRegex(json['regex'], json['message']);
      case 'isEqualTo':
        return IsEqualTo(json['match'], json['message']);
      default:
        throw Exception('Unknown validation rule type: ${json['type']}');
    }
  }
}

bool _isValueEmpty(String? value) {
  return value == null || value.isEmpty;
}

abstract class ValidationRule {
  String? execute(String? value);
  Map<String, dynamic> toJson();
}

class Require extends ValidationRule {
  final String message;
  Require(this.message);

  @override
  String? execute(String? value) {
    if (_isValueEmpty(value)) {
      return message;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'require', 'message': message};
  }
}

class ExactLength extends ValidationRule {
  final int length;
  final String message;
  ExactLength(this.length, this.message);

  @override
  String? execute(String? value) {
    if (_isValueEmpty(value)) return null;
    if (value!.length != length) {
      return message;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'exactLength', 'length': length, 'message': message};
  }
}

class MinLength extends ValidationRule {
  final int length;
  final String message;
  MinLength(this.length, this.message);

  @override
  String? execute(String? value) {
    if (_isValueEmpty(value)) return null;
    if (value!.length < length) {
      return message;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'minLength', 'length': length, 'message': message};
  }
}

class MaxLength extends ValidationRule {
  final int length;
  final String message;
  MaxLength(this.length, this.message);

  @override
  String? execute(String? value) {
    if (_isValueEmpty(value)) return null;
    if (value!.length > length) {
      return message;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'maxLength', 'length': length, 'message': message};
  }
}

class IsEmail extends ValidationRule {
  final String message;
  IsEmail(this.message);

  @override
  String? execute(String? value) {
    if (_isValueEmpty(value)) return null;
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value!)) {
      return message;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'isEmail', 'message': message};
  }
}

class IsNumber extends ValidationRule {
  final String message;
  IsNumber(this.message);

  @override
  String? execute(String? value) {
    if (_isValueEmpty(value)) return null;
    if (!RegExp(r'^[0-9]+$').hasMatch(value!)) {
      return message;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'isNumber', 'message': message};
  }
}

class StartsWith extends ValidationRule {
  final String prefix;
  final String message;
  StartsWith(this.prefix, this.message);

  @override
  String? execute(String? value) {
    if (_isValueEmpty(value)) return null;
    if (!value!.startsWith(prefix)) {
      return message;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'startsWith', 'prefix': prefix, 'message': message};
  }
}

class MatchRegex extends ValidationRule {
  final String regex;
  final String message;
  MatchRegex(this.regex, this.message);

  @override
  String? execute(String? value) {
    if (_isValueEmpty(value)) return null;
    if (!RegExp(regex).hasMatch(value!)) {
      return message;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'matchRegex', 'regex': regex, 'message': message};
  }
}

class IsEqualTo extends ValidationRule {
  final String match;
  final String message;
  IsEqualTo(this.match, this.message);

  @override
  String? execute(String? value) {
    if (_isValueEmpty(value)) return null;
    if (value != match) {
      return message;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'isEqualTo', 'match': match, 'message': message};
  }
}