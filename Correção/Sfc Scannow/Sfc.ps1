# ================================================
# Script: Verifica��o de Integridade do Sistema
# Fun��o: Executar "sfc /scannow" como administrador
# ================================================

# --- Fun��o para garantir execu��o como Administrador
function Ensure-RunAsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Reiniciando o script como Administrador..." -ForegroundColor Yellow
        Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }
}

# --- Chamar fun��o para garantir privil�gios administrativos
Ensure-RunAsAdministrator

# --- Exibir t�tulo
Clear-Host
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   VERIFICA��O DE INTEGRIDADE DO SISTEMA (SFC)" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# --- Executar o comando SFC /scannow
Write-Host "Iniciando a verifica��o do sistema..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

# Executar o comando e capturar a sa�da
$sfcProcess = Start-Process cmd.exe -ArgumentList "/c sfc /scannow" -Wait -NoNewWindow -PassThru

Write-Host ""
Write-Host "-----------------------------------------------"
Write-Host "Verifica��o conclu�da." -ForegroundColor Green
Write-Host "-----------------------------------------------"

# --- Exibir mensagem final
Write-Host ""
Write-Host "Caso erros tenham sido encontrados e corrigidos," -ForegroundColor Yellow
Write-Host "recomenda-se reiniciar o computador." -ForegroundColor Yellow
Write-Host ""
Pause
