# Build Script for Product Manual
$inputFile = "wthm_simple_manual.md"
$htmlFile = "wthm_simple_manual.html"
$pdfFile = "wthm_simple_manual_cn.pdf"

$inputFileEn = "wthm_simple_manual_en.md"
$htmlFileEn = "wthm_simple_manual_en.html"
$pdfFileEn = "wthm_simple_manual_en.pdf"

$inputFileFr = "wthm_simple_manual_fr.md"
$htmlFileFr = "wthm_simple_manual_fr.html"
$pdfFileFr = "wthm_manuel_du_produit_fr.pdf"

$inputFileDe = "wthm_simple_manual_de.md"
$htmlFileDe = "wthm_simple_manual_de.html"
$pdfFileDe = "wthm_produkthandbuch_de.pdf"

$inputFileEs = "wthm_simple_manual_es.md"
$htmlFileEs = "wthm_simple_manual_es.html"
$pdfFileEs = "wthm_manual_del_producto_es.pdf"

$inputFileIt = "wthm_simple_manual_it.md"
$htmlFileIt = "wthm_simple_manual_it.html"
$pdfFileIt = "wthm_manuale_del_prodotto_it.pdf"

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

# --- French Version ---
Write-Host "Step 1 (FR): Converting Markdown to HTML..."
pandoc $inputFileFr -o $htmlFileFr --template=template.html --metadata pagetitle="Manuel du Produit (FR)" --metadata lang="fr" --standalone

if ($LASTEXITCODE -ne 0) {
    Write-Error "Pandoc conversion (FR) failed."
    exit $LASTEXITCODE
}

Write-Host "Step 2 (FR): Converting HTML to PDF with WeasyPrint..."
& $weasyCmd $weasyArgs $htmlFileFr $pdfFileFr

if ($LASTEXITCODE -ne 0) {
    Write-Error "WeasyPrint conversion (FR) failed."
    exit $LASTEXITCODE
}

# --- German Version ---
Write-Host "Step 1 (DE): Converting Markdown to HTML..."
pandoc $inputFileDe -o $htmlFileDe --template=template.html --metadata pagetitle="Produkthandbuch (DE)" --metadata lang="de" --standalone

if ($LASTEXITCODE -ne 0) {
    Write-Error "Pandoc conversion (DE) failed."
    exit $LASTEXITCODE
}

Write-Host "Step 2 (DE): Converting HTML to PDF with WeasyPrint..."
& $weasyCmd $weasyArgs $htmlFileDe $pdfFileDe

if ($LASTEXITCODE -ne 0) {
    Write-Error "WeasyPrint conversion (DE) failed."
    exit $LASTEXITCODE
}

# --- Spanish Version ---
Write-Host "Step 1 (ES): Converting Markdown to HTML..."
pandoc $inputFileEs -o $htmlFileEs --template=template.html --metadata pagetitle="Manual del Producto (ES)" --metadata lang="es" --standalone

if ($LASTEXITCODE -ne 0) {
    Write-Error "Pandoc conversion (ES) failed."
    exit $LASTEXITCODE
}

Write-Host "Step 2 (ES): Converting HTML to PDF with WeasyPrint..."
& $weasyCmd $weasyArgs $htmlFileEs $pdfFileEs

if ($LASTEXITCODE -ne 0) {
    Write-Error "WeasyPrint conversion (ES) failed."
    exit $LASTEXITCODE
}

# --- Italian Version ---
Write-Host "Step 1 (IT): Converting Markdown to HTML..."
pandoc $inputFileIt -o $htmlFileIt --template=template.html --metadata pagetitle="Manuale del Prodotto (IT)" --metadata lang="it" --standalone

if ($LASTEXITCODE -ne 0) {
    Write-Error "Pandoc conversion (IT) failed."
    exit $LASTEXITCODE
}

Write-Host "Step 2 (IT): Converting HTML to PDF with WeasyPrint..."
& $weasyCmd $weasyArgs $htmlFileIt $pdfFileIt

if ($LASTEXITCODE -ne 0) {
    Write-Error "WeasyPrint conversion (IT) failed."
    exit $LASTEXITCODE
}

Write-Host "Success! PDFs generated at:"
Write-Host "  - $pdfFile (Chinese)"
Write-Host "  - $pdfFileEn (English)"
Write-Host "  - $pdfFileFr (French)"
Write-Host "  - $pdfFileDe (German)"
Write-Host "  - $pdfFileEs (Spanish)"
Write-Host "  - $pdfFileIt (Italian)"
