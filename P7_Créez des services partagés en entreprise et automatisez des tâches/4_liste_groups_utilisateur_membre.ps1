### Script Groupe d'un utilisateur ###

### Login utilisateur à renseigner pour générer la liste des groupes ###

$membre = Read-Host "Entrer le login de l'utilisateur"

### Recherche de groupe dont l'utilisateur est membre et export du résultat en fichier .txt ###
try
{
Get-ADPrincipalGroupMembership $membre | Select Name | Export-CSV "$membre.txt"
Write-Host " Le Fichier à été généré " -ForeGroundColor Green
pause
}  

catch
{
Write-Host "Le login renseigner n'existe pas!" -ForegroundColor Red
pause
}
