### Script de sauvegarde de nuit sur serveur ###

### Date de sauvegarde ###

$date = Get-Date -Format dd.MM.yyyy

### Récuperation de la liste des PC ###

$AllPC = (Get-ADComputer -Filter * -SearchBase "CN=Computers,DC=Acme,DC=fr").Name

### Création d'une boucle pour que tous les Pc du domaine soient sauvegardés ###

Foreach ($Pc in $AllPC)
{
### Création du répertoire si il n'existe pas ###

if(-not(Test-Path C:\SAV\$Pc\$date))
{
 New-Item "C:\SAV\$Pc\$date" -ItemType Directory
}

  ### Description des options :
  ###/E = copie les sous-répertoires, y compris les vides.
  ###/R:0 = nombre de tentatives après l'échec de copies.
  ###/XJ = exclut les points de Jonction (normalement inclus par défaut).
  ###/XD = exclut les répertoires qui correspondent aux noms et chemins d’accès spécifiés.

### Copie des fichiers (inclut les sous-dossiers sauf si vides, aucune nouvelle tentative, exclusion des points de jonction) ###

Robocopy "\\$PC\C$\Users\$user" "C:\SAV\$Pc\$date" /E /R:0 /XJ /XD "3D Objects" OneDrive AppData Contacts Downloads Favorites Links Music Pictures Save "Saved Games" Searches Videos

### Extinction des Pc une fois la sauvegarde éffectuée ###

shutdown -s -m "\\$pc"
}
