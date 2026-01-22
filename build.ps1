# Build Script for Product Manual
$inputFile = "wthm_simple_manual.md"
$htmlFile = "wthm_simple_manual.html"
$pdfFile = "wthm_simple_manual.pdf"

$inputFileEn = "wthm_simple_manual_en.md"
$htmlFileEn = "wthm_simple_manual_en.html"
$pdfFileEn = "wthm_simple_manual_en.pdf"

# Add GTK3 to PATH for the current process
$gtkPath = "D:\Program Files\GTK3-Runtime Win64\bin"
if (Test-Path $gtkPath) {
    $env:PATH = "$gtkPath;" + $env:PATH
}

Write-Host "Checking requirements..."
if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    Write-Error "Pandoc is not installed or not in PATH."
    exit 1
}

# Check for WeasyPrint (it's a python module, usually run as 'weasyprint' or 'python -m weasyprint')
# We will use 'python -m weasyprint' to be safe since user installed via pip
$weasyCmd = "python"
$weasyArgs = "-m", "weasyprint"

# --- Chinese Version ---
Write-Host "Step 1 (CN): Converting Markdown to HTML..."
# --standalone is needed to make a full HTML file
# --template uses our custom template
# --metadata sets the page title and language
pandoc $inputFile -o $htmlFile --template=template.html --metadata pagetitle="Product Manual" --metadata lang="zh-CN" --standalone

if ($LASTEXITCODE -ne 0) {
    Write-Error "Pandoc conversion (CN) failed."
    exit $LASTEXITCODE
}

Write-Host "Step 2 (CN): Converting HTML to PDF with WeasyPrint..."
& $weasyCmd $weasyArgs $htmlFile $pdfFile

if ($LASTEXITCODE -ne 0) {
    Write-Error "WeasyPrint conversion (CN) failed."
    exit $LASTEXITCODE
}

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
Write-Host "  - $pdfFile"
Write-Host "  - $pdfFileEn"
