![music-notation](https://user-images.githubusercontent.com/62043/111560932-cf4d1180-8750-11eb-842e-3159015c61ab.png)

[![Platform](https://img.shields.io/badge/Platforms-macOS%20-lightgrey.svg)](https://github.com/music-notation-swift/music-notation-import)
![Swift 5.3](https://img.shields.io/badge/Swift-5.3-F28D00.svg)
[![Build & Test](https://github.com/music-notation-swift/music-notation-import/actions/workflows/build-test.yml/badge.svg)](https://github.com/music-notation-swift/music-notation-import/actions/workflows/build-test.yml)
![Coverage Badge](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/woolie/b9f858cfba09911bd1755bdc40dd5a35/raw/music-notation-import__heads_main.json)

# music-notation-import

Import various music notation file formats into [music-notation](https://github.com/music-notation-swift/music-notation).

## Supported Formats
### Guitar Pro 7

Guitar Pro 7 is a zipped file format (`.gp`) which expands into a folder that has the following contents:

![Guitar Pro 7 File Format](images/gp7-contents.png)

The `score.gpif` file is an application specific XML file.
The files in the GuitarPro7 folder are those specific to parsing this file format.

`music-notation-import` not supports specifying the `gpif` file alone, or specifying the container `gp` file. Using the [ZIPFoundation](https://github.com/weichsel/ZIPFoundation) the process will pull out the `score.gpif` file and parse that directly.

## Dependencies

- [SWXMLHash](https://github.com/drmohundro/SWXMLHash)
- [ZIPFoundation](https://github.com/weichsel/ZIPFoundation)
- [music-notation](https://github.com/music-notation-swift/music-notation)

## Notes

This is (obviously) a work in progress. It is meant to drive and help develop the `music-notation` project.
