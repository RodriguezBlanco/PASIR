# Importar los módulos necesarios
Import-Module ActiveDirectory


# Definir las variables
$departamentos = @("Ventas", "RRHH", "Desarrollo", "Marketing", "Atención al cliente", "Explotación")
$inicial = [char]65 # Código ASCII de 'A'
$final = [char]90 # Código ASCII de 'Z'


# Iterar sobre los departamentos
foreach ($departamento in $departamentos) {


    # Crear la unidad organizativa si no existe
    $ouPath = "OU=$departamento,OU=Usuarios,DC=example,DC=com"
    if (-not (Get-ADOrganizationalUnit -Filter {Name -eq $departamento})) {
        New-ADOrganizationalUnit -Name $departamento -Path "OU=Usuarios,DC=example,DC=com"
    }


    # Crear los grupos de trabajo
    $grupo1 = New-ADGroup -Name "$departamento-Trabajadores" -GroupScope DomainLocal -Path $ouPath
    $grupo2 = New-ADGroup -Name "$departamento-Especialistas" -GroupScope DomainLocal -Path $ouPath
    $grupo3 = New-ADGroup -Name "$departamento-Administradores" -GroupScope DomainLocal -Path $ouPath


    # Iterar sobre el rango de nombres de usuario
    for ($i = $inicial; $i -le $final; $i++) {


        # Crear el nombre de usuario y el nombre completo
        $nombre = "$departamento$([char]$i)"
        $nombreCompleto = "$departamento $([char]$i)"


        # Comprobar si el usuario ya existe
        if (-not (Get-ADUser -Filter {SamAccountName -eq $nombre})) {


            # Crear el usuario
            $usuario = New-ADUser -Name $nombreCompleto -SamAccountName $nombre -UserPrincipalName "$nombre@example.com" -Department $departamento -Path $ouPath -Enabled $true -AccountPassword (ConvertTo-SecureString "contrasena123" -AsPlainText -Force) -PassThru


            # Asignar el grupo de trabajo
            Add-ADGroupMember -Identity $grupo1 -Members $usuario


            # Asignar los usuarios al grupo especialistas
            if ($i -le 10) {
                Add-ADGroupMember -Identity $grupo2 -Members $usuario
            }


            # Asignar los usuarios al grupo administradores
            if ($i -le 5) {
                Add-ADGroupMember -Identity $grupo3 -Members $usuario
            }
            Write-Host "Usuario creado: $nombreCompleto"
        } else {
            Write-Host "El usuario $nombre ya existe."
        }
    }
}
