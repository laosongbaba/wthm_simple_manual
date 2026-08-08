# Build Script for Product Manual
$inputFileEn = "wens_simple_manual_en.md"
$htmlFileEn = "wens_simple_manual_en.html"
$pdfFileEn = "wens_simple_manual_en.pdf"

Write-Host "Checking requirements..."
if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    Write-Error "Pandoc is not installed or not in PATH."
    exit 1
}

# Check for WeasyPrint (it's a python module, usually run as 'weasyprint' or 'python -m weasyprint')
# We will use 'python -m weasyprint' to be safe since user installed via pip
$weasyCmd = "python"
$weasyArgs = "-m", "weasyprint"


# --- English Version ---
Write-Host "Step 1 (EN): Converting Markdown to HTML..."
pandoc $inputFileEn -o $htmlFileEn --template=template.html --metadata pagetitle="Product Manual (EN)" --metadata lang="en" --standalone

if ($LASTEXITCODE -ne 0) {
    Write-Error "Pandoc conversion (EN) failed."
    exit $LASTEXITCODE
}

Write-Host "Step 2 (EN): Converting HTML to PDF with WeasyPrint..."
& $weasyCmd $weasyArgs $htmlFileEn $pdfFileEn

if ($LASTEXITCODE -ne 0) {
    Write-Error "WeasyPrint conversion (EN) failed."
    exit $LASTEXITCODE
}

Write-Host "Success! PDFs generated at:"
Write-Host "  - $pdfFileEn (English)"
