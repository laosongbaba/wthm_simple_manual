# Image Layout Guide for Pandoc + WeasyPrint

This document records the effective method used to achieve a **full-width, multi-column image layout** that preserves aspect ratio in PDF output generated via Pandoc and WeasyPrint.

## The Challenge
Directly using Markdown image syntax (`![alt](src)`) in a Flexbox or Grid container often leads to:
1.  **Vertical Stacking**: Pandoc wraps adjacent images in a single `<p>` tag, causing the grid to see only one item.
2.  **Size Issues**: Images might be too small or fail to fill the available width.
3.  **Aspect Ratio Distortion**: Using `flex: 1` generally on `img` tags can stretch them disproportionately if height isn't carefully controlled.

## The Solution: HTML Wrappers + CSS Flexbox

### 1. Markdown Structure
Instead of standard Markdown syntax, use explicit HTML `<div>` wrappers. This provides a clear, controllable structure for CSS.

```html
<div class="image-grid">
  <div><img src="./images/image1.png"></div>
  <div><img src="./images/image2.png"></div>
  <div><img src="./images/image3.png"></div>
  <div><img src="./images/image4.png"></div>
</div>
```

### 2. CSS Styling
Use Flexbox to distribute the wrapper `div`s equally, and let the `img` tags fill those wrappers naturally.

```css
/* Container */
.image-grid {
    display: flex;
    width: 100%;           /* Force full width */
    margin: 15px 0;
    justify-content: space-between;
    align-items: flex-start; /* Align top, preventing vertical stretch distortion */
    gap: 3px;              /* Small gap to maximize image space */
}

/* Flex Items (The Wrapper Divs) */
.image-grid > div {
    flex: 1;               /* Force equal width distribution */
    min-width: 0;          /* Allow items to shrink if necessary */
    margin: 0;
    padding: 0;
    text-align: center;
}

/* Inner Images */
.image-grid img {
    width: 100%;           /* Fill the wrapper width */
    height: auto;          /* Maintain aspect ratio */
    display: block;
    border: 1px solid #eee;
}
```

## Why This Works
-   **Structure**: The `<div>` wrappers isolate each image, ensuring the Flex container sees exactly 4 items.
-   **Width**: `flex: 1` on the wrappers guarantees they split the 100% width equally.
-   **Aspect Ratio**: Applying `width: 100%; height: auto;` to the *image* (not the wrapper) ensures it scales perfectly within its assigned "cell" without distorting.
