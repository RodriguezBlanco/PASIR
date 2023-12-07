# Creación Grupos
New-ADGroup -Name "Junior" -GroupCategory Security -GroupScope Global -Path "OU=Grupos,DC=Proyecto,DC=local"
New-ADGroup -Name "Senior" -GroupCategory Security -GroupScope Global -Path "OU=Grupos,DC=Proyecto,DC=local"

# Asignar Usuarios a Grupos
Add-ADGroupMember -Identity "Junior" -Members "A1", "B1"
Add-ADGroupMember -Identity "Senior" -Members "C1", "D1", "E1"
