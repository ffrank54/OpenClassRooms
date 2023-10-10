### Script nouvel utilisateur ###

### Cette commande démarre une journalisation ###

Start-Transcript -OutputDirectory C:\Log\Utilisateurs

### Ajout des données utilisateurs ###

$prenom = Read-Host "Entrer le prénom de l'utilisateur"
$nom = Read-Host "Entrer le NOM de l'utilisateur"
$complet = $prenom +" "+ $nom
$mdp = "Azerty123"
Write-Host "1=Direction, 2=Finance, 3=Marketing, 4=RH, 5=Technique"
$ou = Read-Host "Entrer le numéro de l'unité d'organisation que l'utilisateur doit intégrer"
$stagiaire = Read-Host "L'utilisateur est il un stagiaire? (Oui/Non) "

Switch ($ou, $stagiaire)
{
1 {$ou='Direction'}
1 {$groupe='Direction'}
1 {$dossier='Direction'}
2 {$ou='Finance'}
2 {$groupe='Finance'}
2 {$dossier='Finance'}
3 {$ou='Marketing'}
3 {$groupe='Marketing'}
3 {$dossier='Marketing'}
4 {$ou='RH'}
4 {$groupe='RH'}
4 {$dossier='RH'}
5 {$ou='Technique'}
5 {$groupe='Technique'}
5 {$dossier='Technique'}
6 {$ou='Stagiaire'}
6 {$groupe='Stagiaire'}
6 {$dossier='Stagiaire'}
}

try
{
### Création du compte utilisateur en fonction des variables ajoutées ###

New-ADUser -Name $complet -GivenName $prenom -Surname $nom -SamAccountName $complet -UserPrincipalName $complet@acme.fr -AccountPassword (ConvertTo-SecureString -AsPlainText $mdp -Force) -PasswordNeverExpires $true -CannotChangePassword $true -Enabled $true -Path "OU=$ou,OU=ACME,DC=Acme,DC=fr"

### Groupe a joindre ###

Add-ADGroupMember -Identity $groupe -Members $complet

### Dérogation si utilisateur stagiaire ###

    if ($stagiaire -eq "Oui")
{
    Add-ADGroupMember -Identity Stagiaire -Members $complet
    $ou = 'Stagiaire'
} 

### Création du dossier ###

New-Item -Path C:\Partage\$dossier\$complet -ItemType Directory | Out-Null

### Partage du dossier aux administrateurs ###

New-SMbShare -Name $complet$ -Path C:\Partage\$dossier\$complet\ -FullAccess Administrateurs | Out-Null

### Partage du dossier caché seulement à l'utilisateur ###

Grant-SmbShareAccess -name $complet$ -AccountName $complet -AccessRight Change -Force | Out-Null

### Mappage du dossier personnel sur le lecteur S ###

Set-ADUser -Identity $complet -HomeDirectory "\\ACME\$complet$" -HomeDrive "S:"
 
Write-Host "L'utilisateur $complet a bien été créer, ajouté au groupe, et son dossier partagé est dans le répertoire ciblé" -ForegroundColor Green
}
catch
{
Write-Warning "Impossible de créer cet utilisateur avec les données fournies" -ForegroundColor Red
}
