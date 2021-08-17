![music-notation](https://user-images.githubusercontent.com/62043/111560932-cf4d1180-8750-11eb-842e-3159015c61ab.png)

[![Platform](https://img.shields.io/badge/Platforms-macOS%20-lightgrey.svg)](https://github.com/music-notation-swift/music-notation-import)
![Swift 5.4](https://img.shields.io/badge/Swift-5.4-F28D00.svg)
[![Build & Test](https://github.com/music-notation-swift/music-notation-import/actions/workflows/build-test.yml/badge.svg)](https://github.com/music-notation-swift/music-notation-import/actions/workflows/build-test.yml)
[![Lint](https://github.com/music-notation-swift/music-notation-import/actions/workflows/swiftlint.yml/badge.svg)](https://github.com/music-notation-swift/music-notation-import/actions/workflows/swiftlint.yml)
![Coverage Badge](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/woolie/b9f858cfba09911bd1755bdc40dd5a35/raw/music-notation-import__heads_main.json)

# music-notation-import

Import various music notation file formats into [music-notation](https://github.com/music-notation-swift/music-notation).

## Supported Formats

- [Guitar Pro 7 Files](https://github.com/music-notation-swift/music-notation-import-guitarpro).

## Dependencies

- [ArgumentParser](https://github.com/apple/swift-argument-parser)

  Used to create the command line interface.

- [SWXMLHash](https://github.com/drmohundro/SWXMLHash)

  Used to parse the XML data in the GuitarPro files.

- [ZIPFoundation](https://github.com/weichsel/ZIPFoundation)

  Used to find the XML file within the GuitarPro file (which is just a folder zipped with some files in it)

- [music-notation](https://github.com/music-notation-swift/music-notation)

  The whole point of this exercise. The music notation model we are trying to parse to.

- [music-notation-import-guitarpro](https://github.com/music-notation-swift/music-notation-import-guitarpro)

  The actual code that implements the XML parsing of GuitarPro specific data.

## Notes

This is (obviously) a work in progress. It is meant to drive and help develop the `music-notation` project.
