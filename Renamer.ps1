# Renamer.ps1

$folderPath = "\\DESKTOP-O50R7DL\CCStatus"
$configPath = "C:\ClusterMonitor\CCStatus\mapping.json"

# Read detected nodes from folder
$detectedNodes = Get-ChildItem -Path $folderPath -Filter *.txt | ForEach-Object { $_.BaseName }

if ($detectedNodes.Count -eq 0) {
    Write-Host "No nodes detected in $folderPath"
    pause
    exit
}

# Load existing mapping if present
if (Test-Path $configPath) {
    $mapping = Get-Content $configPath | ConvertFrom-Json
} else {
    $mapping = @{}
}

# Add any new nodes to mapping
foreach ($node in $detectedNodes) {
    if (-not $mapping.ContainsKey($node)) {
        $mapping[$node] = $node
    }
}

Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "PC → Worker Name Renamer"

# Calculate form height
$height = 50 + ($detectedNodes.Count * 35)
$form.Size = New-Object System.Drawing.Size(450, $height)
$form.StartPosition = "CenterScreen"

$y = 20
$inputs = @{}

foreach ($node in $detectedNodes) {
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $node
    $label.Location = New-Object System.Drawing.Point(20, $y)
    $label.Size = New-Object System.Drawing.Size(180, 20)
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Text = $mapping[$node]
    $textBox.Location = New-Object System.Drawing.Point(210, $y)
    $textBox.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textBox)

    $inputs[$node] = $textBox
    $y += 30
}

$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "Save"
$saveY = $y + 10
$btnSave.Location = New-Object System.Drawing.Point(180, $saveY)
$btnSave.Add_Click({
    foreach ($node in $inputs.Keys) {
        $mapping[$node] = $inputs[$node].Text
    }
    $mapping | ConvertTo-Json | Set-Content $configPath
    [System.Windows.Forms.MessageBox]::Show("Mapping saved to $configPath.")
    $form.Close()
})
$form.Controls.Add($btnSave)

$form.ShowDialog()
