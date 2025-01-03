### WebP Image Conversion

To convert images in the `uploads` folder to WebP format with a specified quality (e.g., 80), run the following:

```bash
chmod +x *.sh
./compress.sh uploads 80
```

### Quality Settings
- **Quality 100**: Best quality, larger file size (lossless).
- **Quality 50**: Good compression, smaller file size, slightly lower quality.
- **Quality 1**: Maximum compression, smallest file size, potential visual artifacts.

### Recompression (Optional)
If you're not satisfied with the result, reconvert with a different quality setting:

```bash
./reconvert_webp.sh uploads 10
```

[Preview Results](PreviewResults/README.md)

