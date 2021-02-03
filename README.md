# win_password - Creates a random and complex password

## Synopsis

* Ansible module to create a random and complex password on Windows-based systems.

## Parameters

| Parameter     | Choices/<font color="blue">Defaults</font> | Comments |
| ------------- | ---------|--------- |
|__length__<br><font color="purple">integer</font> | __Default:__<br><font color="blue">8</font> | The number of characters in the generated password. The length must be between 1 and 128 characters. |
|__min_upper_case__<br><font color="purple">integer</font> | __Default:__<br><font color="blue">1</font> | The minimum number of uppercase letters of European languages (A through Z). |
|__min_lower_case__<br><font color="purple">integer</font> | __Default:__<br><font color="blue">1</font> | The minimum number of lowercase letters of European languages (a through z). |
|__min_digit__<br><font color="purple">integer</font> | __Default:__<br><font color="blue">1</font> | The minimum number of characters from base 10 digits (0 through 9). |
|__min_special__<br><font color="purple">integer</font> | __Default:__<br><font color="blue">1</font> | The minimum number of non-alphanumeric characters (special characters). |
|__special_characters__<br><font color="purple">string</font> | __Default:__<br><font color="blue">!%&=?][#+-</font> | A string containing all special characters allowed to use. |

## Examples

```yaml
- hosts: localhost

  roles:

    - role: win_password

  tasks:

    - name: generate a complex password
      win_password:
        length: 14
        min_upper_case: 3
        min_lower_case: 2
        min_digit: 1
        min_special: 4
        special_characters: '+-'

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

Facts returned by this module are added/updated in the `hostvars` host facts and can be referenced by name just like any other host fact. They do not need to be registered in order to use them.

| Fact   | Returned   | Description |
| ------ |------------| ------------|
|__win_complex_password__<br><font color="purple">string</font> | success | A string containing the password in plain text. |

## Authors

* Stéphane Bilqué (@sbilque)

## License

This project is licensed under the Apache 2.0 License.

See [LICENSE](LICENSE) to see the full text.
