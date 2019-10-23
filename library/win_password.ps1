#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy
#Requires -Version 2.0

$ErrorActionPreference = "Stop"

$result = @{ }

$params = Parse-Args -arguments $args -supports_check_mode $true
$check_mode = Get-AnsibleParam -obj $params -name "_ansible_check_mode" -type "bool" -default $false
$diff_mode = Get-AnsibleParam -obj $params -name "_ansible_diff" -type "bool" -default $false

# Modules parameters

$passwordLength = Get-AnsibleParam -obj $params "length" -type "int" -default 8 -resultobj $result
$minUpperCase = Get-AnsibleParam -obj $params "min_upper_case" -type "int" -default 1 -resultobj $result
$minLowerCase = Get-AnsibleParam -obj $params "min_lower_case" -type "int" -default 1 -resultobj $result
$minDigit = Get-AnsibleParam -obj $params "min_digit" -type "int" -default 1 -resultobj $result
$minSpecial = Get-AnsibleParam -obj $params "min_special" -type "int" -default 1 -resultobj $result
$specialCharacters = Get-AnsibleParam -obj $params "special_characters" -type "str" -default '!%&=?][#+-' -resultobj $result 

$CharGroups = @(
    @{ min = $minLowerCase; characters = [char[]]'abcdefghiklmnoprstuvwxyz' },
    @{ min = $minUpperCase; characters = [char[]]'ABCDEFGHKLMNOPRSTUVWXYZ' },
    @{ min = $minDigit; characters = [char[]]'1234567890' },
    @{ min = $minSpecial; characters = [char[]]$specialCharacters }
)

Function Get-Seed {
    # Generate a seed for randomization
    $RandomBytes = New-Object -TypeName 'System.Byte[]' 4
    $Random = New-Object -TypeName 'System.Security.Cryptography.RNGCryptoServiceProvider'
    $Random.GetBytes($RandomBytes)
    [BitConverter]::ToUInt32($RandomBytes, 0)
}

# Create char array containing all chars
$AllChars = $CharGroups | ForEach-Object { [Char[]]($_.characters) }

$passwordArray = @{ }

# Randomize one char from each group
Foreach ($Group in $CharGroups) {
    $characters = $group.characters
    $minLength = $group.min
    for ($i = 1; $i -le $Minlength; $i++) {
        if ($PasswordArray.Count -lt $passwordLength) {
            $Index = Get-Seed
            While ($PasswordArray.ContainsKey($Index)) {
                $Index = Get-Seed                        
            }
            $PasswordArray.Add($Index, $characters[((Get-Seed) % $characters.Count)])
        }
    }    
}

# Fill out with chars from $AllChars
for ($i = $PasswordArray.Count; $i -lt $passwordLength; $i++) {
    $Index = Get-Seed
    While ($PasswordArray.ContainsKey($Index)) {
        $Index = Get-Seed                        
    }
    $PasswordArray.Add($Index, $AllChars[((Get-Seed) % $AllChars.Count)])
}

$password = $( -join ($PasswordArray.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value))

$result = @{
    changed = $true
}

if ($diff_mode) {
    $result.diff = @{ }
}

if ($check_mode) {
    $result = @{
        changed       = $false
        ansible_facts = @{
            win_complex_password = ''
        }        
    }
}
else {
    $result = @{
        changed       = $true
        ansible_facts = @{
            win_complex_password = $password
        }
    }
}

Exit-Json -obj $result
