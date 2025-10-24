# ============================================================
# Script: detailed-system-info-log.ps1
# Função: Lista informações detalhadas do sistema e salva em log
# Autor : Adaptado para Diego Geset
# ============================================================

# --- Função para detectar pasta do script ---
function Get-ScriptDirectory {
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path -Parent $Invocation.MyCommand.Definition
}

$ScriptDir = Get-ScriptDirectory

# --- Gerar nome do log com hostname e timestamp ---
$Hostname = $env:COMPUTERNAME
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = Join-Path -Path $ScriptDir -ChildPath "system_info_${Hostname}_${Timestamp}.txt"

# --- Função para escrever no console e log ---
function Write-Log {
    param (
        [string]$Text
    )
    Write-Host $Text
    Add-Content -Path $LogFile -Value $Text
}

# --- CPU ---
$CPU = Get-WmiObject -Class Win32_Processor
Write-Log "===== CPU ====="
Write-Log "Nome: $($CPU.Name)"
Write-Log "Fabricante: $($CPU.Manufacturer)"
Write-Log "Cores Físicos: $($CPU.NumberOfCores)"
Write-Log "Processadores Lógicos: $($CPU.NumberOfLogicalProcessors)"
Write-Log "Clock Máximo (GHz): $([math]::Round($CPU.MaxClockSpeed / 1000, 2))"
Write-Log "Uso Atual (%): $((Get-WmiObject Win32_Processor).LoadPercentage)"
Write-Log ""

# --- Memória RAM ---
$MemModules = Get-WmiObject -Class Win32_PhysicalMemory
$TotalRAMGB = [math]::Round(($MemModules | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
Write-Log "===== MEMÓRIA RAM ====="
Write-Log "Total RAM (GB): $TotalRAMGB"
Write-Log "Quantidade de Pentes: $($MemModules.Count)"
$i = 1
foreach ($mod in $MemModules) {
    $capGB = [math]::Round($mod.Capacity / 1GB, 2)
    Write-Log "Pente ${i}: $capGB GB, Velocidade: $($mod.Speed) MHz, Fabricante: $($mod.Manufacturer)"
    $i++
}
Write-Log ""

# --- Sistema / Hostname ---
$CS = Get-WmiObject -Class Win32_ComputerSystem
Write-Log "===== SISTEMA ====="
Write-Log "Hostname: $($CS.Name)"
Write-Log "Proprietário Principal: $($CS.PrimaryOwnerName)"
Write-Log "Fabricante: $($CS.Manufacturer)"
Write-Log "Modelo: $($CS.Model)"
Write-Log "Tipo do Sistema: $($CS.SystemType)"
Write-Log ""

# --- Discos ---
$Disks = Get-WmiObject -Class Win32_DiskDrive
Write-Log "===== DISPOSITIVOS DE ARMAZENAMENTO ====="
foreach ($disk in $Disks) {
    Write-Log "Nome: $($disk.DeviceID)"
    Write-Log "Modelo: $($disk.Model)"
    Write-Log "Tamanho (GB): $([math]::Round($disk.Size / 1GB, 2))"
    Write-Log "Tipo: $($disk.MediaType)"
    Write-Log "-----------------------------"
}

Write-Log "Log salvo em: $LogFile"
Write-Host ""

# --- Função para aguardar Enter ---
function Wait-ForEnter {
    Write-Host "Pressione Enter para sair..."
    [void][System.Console]::ReadLine()
}

# Chama a função de espera antes de encerrar
Wait-ForEnter
