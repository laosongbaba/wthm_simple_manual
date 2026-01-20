# Build Script for Product Manual
$inputFile = "product-specs.md"
$htmlFile = "product-specs.html"
$pdfFile = "product-specs.pdf"

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

Write-Host "Step 1: Converting Markdown to HTML..."
# --standalone is needed to make a full HTML file
# --template uses our custom template
# --metadata sets the page title
pandoc $inputFile -o $htmlFile --template=template.html --metadata pagetitle="Product Manual" --standalone

if ($LASTEXITCODE -ne 0) {
    Write-Error "Pandoc conversion failed."
    exit $LASTEXITCODE
}

Write-Host "Step 2: Converting HTML to PDF with WeasyPrint..."
& $weasyCmd $weasyArgs $htmlFile $pdfFile

if ($LASTEXITCODE -ne 0) {
    Write-Error "WeasyPrint conversion failed."
    exit $LASTEXITCODE
}

Write-Host "Success! PDF generated at: $pdfFile"
