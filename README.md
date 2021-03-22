![music-notation](https://user-images.githubusercontent.com/62043/111560932-cf4d1180-8750-11eb-842e-3159015c61ab.png)

[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Platform](https://img.shields.io/badge/Platforms-macOS%20-lightgrey.svg)](https://github.com/music-notation-swift/music-notation-import)

# music-notation-import

Import various music notation file formats into [music-notation](https://github.com/music-notation-swift/music-notation).

## Supported Formats
### Guitar Pro 7

Guitar Pro 7 is a zipped file format (`.gp`) which expands into a folder that has the following contents:

![Guitar Pro 7 File Format](images/gp7-contents.png)

The `score.gpif` file is an application specific XML file.
The files in the GuitarPro7 folder are those specific to parsing this file format.

The next goal is to parse the `score.gpif` file directly from the zipped `.gp` file.

## Notes

This is (obviously) a work in progress. It is meant to drive and help develop the `music-notation` project.
