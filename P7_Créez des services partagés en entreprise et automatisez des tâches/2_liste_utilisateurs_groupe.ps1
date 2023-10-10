### Script Liste utilisateurs d'un groupe ###

### Variable du groupe à lister ###

$groupe = Read-Host "Entrer le nom du groupe AD à lister"


### Recherche des membres du groupe et export du résultat en fichier .txt ###

try
{
 Get-ADGroupMember $groupe | Select-Object name, samAccountName, UserPrincipalName | Export-Csv "$groupe.txt" 

Write-Host "Le fichier à était généré" -ForegroundColor Green
pause
}

catch
{
Write-Host "Impossible de trouver le groupe demander" -ForegroundColor Red
pause
}
