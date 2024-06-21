# Created using GitHub CoPilot

# Define the text to animate
$Text = "diecknet"

# Print the text once to initialize
Write-Host $Text -NoNewline -ForegroundColor Yellow
Start-Sleep -Milliseconds 200

# Main loop to animate each character
for ($i = 0; $i -lt $Text.Length; $i++) {
    # Move cursor back to the beginning of the line
    Write-Host "`r" -NoNewline

    # Reprint the text with the current character in red
    for ($j = 0; $j -lt $Text.Length; $j++) {
        if ($j -eq $i) {
            Write-Host $Text[$j] -NoNewline -ForegroundColor Red
        } else {
            Write-Host $Text[$j] -NoNewline -ForegroundColor Yellow
        }
    }

    # Pause for a short period to create the animation effect
    Start-Sleep -Milliseconds 200
}

# Move cursor to the next line after the animation ends
Write-Host