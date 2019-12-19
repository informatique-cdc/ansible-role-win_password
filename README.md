# win_password - Creates a random and complex password

## Synopsis

* Ansible module to create a random and complex password on Windows-based systems.

## Parameters

| Parameter          | Required | Choices/Defaults      | Comments                                                                                                 |
| ------------------ | -------- | --------------------- | -------------------------------------------------------------------------------------------------------- |
| length             | no       | Default: `8`          | The number of characters in the generated password.<br/>The length must be between 1 and 128 characters. |
| min_upper_case     | no       | Default: `1`          | The minimum number of uppercase letters of European languages (A through Z).                             |
| min_lower_case     | no       | Default: `1`          | The minimum number of lowercase letters of European languages (a through z).                             |
| min_digit          | no       | Default: `1`          | The minimum number of characters from base 10 digits (0 through 9)                                       |
| min_special        | no       | Default: `1`          | The minimum number of non-alphanumeric characters (special characters).                                  |
| special_characters | non      | Default: `!%&=?][#+-` | A string containing all special characters allowed to use.                                               |

## Examples

```yaml
---
- hosts: localhost

  roles:

    - role: win_password

  tasks:

    - name: generate a complex password
      win_password:
        length: 14
        min_upper_case: 2
        min_lower_case: 2
        min_digit: 2
        min_special: 1

    - name: debug message
      debug:
        var: win_complex_password

    - name: generate a complex password
      win_password:
        length: 14
        min_upper_case: 13
        min_lower_case: 0
        min_digit: 0
        min_special: 1
      register: myComplexPassword  

    - name: debug message
      debug:
        var: myComplexPassword.ansible_facts.win_complex_password

```

## Return Values

The following are the fields unique to this module:

| Key                  | Returned | Description                                     |
| -------------------- | -------- | ----------------------------------------------- |
| changed              | always   | Whether there was a change done.                |
| win_complex_password | success  | A string containing the password in plain text. |

## Authors

* [Stéphane Bilqué](https://github.com/sbilque)

## License

This project is licensed under the Apache 2.0 License.

See the [LICENSE](LICENSE) to see the full text.
