#!/usr/bin/python
# -*- coding: utf-8 -*-

# This is a windows documentation stub.  Actual code lives in the .ps1
# file of the same name.

# Copyright: (c) 2019, Informatique CDC.
# GNU General Public License v3.0+ (see LICENSE or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import absolute_import, division, print_function
__metaclass__ = type

ANSIBLE_METADATA = {'metadata_version': '1.0',
                    'status': ['preview'],
                    'supported_by': 'community'}

DOCUMENTATION = r'''
---
module: win_password
short_description: Creates a random and complex password
author:
  - Stéphane Bilqué (@sbilque)
description:
    - Ansible module to create a random and complex password on Windows-based systems.

options:
  length:
    description:
      - The number of characters in the generated password. The length must be between 1 and 128 characters.
    default: 8
    required: 'No'
    type: int
  min_upper_case:
    description:
      - The minimum number of uppercase letters of European languages (A through Z).
    default: 1
    required: 'No'
    type: int
  min_lower_case:
    description:
      - The minimum number of lowercase letters of European languages (a through z).
    default: 1
    required: 'No'
    type: int
  min_digit:
    description:
      - The minimum number of characters from base 10 digits (0 through 9).
    default: 1
    required: 'No'
    type: int
  min_special:
    description:
      - The minimum number of non-alphanumeric characters (special characters).
    default: 1
    required: 'No'
    type: int
  special_characters:
    description:
      - A string containing all special characters allowed to use.
    default: '!%&=?][#+-'
    required: 'No'
    type: str
'''
EXAMPLES = r'''
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
'''

RETURN = r'''
ansible_facts:
    description: A string containing the password in plain text.
    returned: success
    type: complex
    contains:
        win_complex_password:
            description: A string containing the password in plain text.
            returned: success
            type: str
'''
