**WebP Image Conversion**

To **convert** images in a specified folder to WebP format with a specified quality (e.g., 80), run the following commands:

1. Make the script executable:
   ```
   chmod +x *.sh
   ```

2. Convert images in the chosen folder with the specified quality:
   ```
   ./compress.sh [folder_name] [quality]
   ```
   Replace `[folder_name]` with the path to your folder, and `[quality]` with the desired quality (e.g., 80).

**Quality Settings**  
- **Quality 100**: Best quality, larger file size (lossless).  
- **Quality 50**: Good compression, smaller file size, slightly lower quality.  
- **Quality 1**: Maximum compression, smallest file size, potential visual artifacts.  

**Recompression (Optional)**  
If you're not satisfied with the result, you can **reconvert** the images with a different quality setting:

```
./reconvert_webp.sh [folder_name] [new_quality]
```
Replace `[folder_name]` with the path to your folder, and `[new_quality]` with the desired quality (e.g., 10).

[Preview Results](PreviewResults/README.md)

