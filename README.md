[![Build Status](https://travis-ci.org/mirage/mirage-tutorial.svg?branch=master)](https://travis-ci.org/mirage/mirage-tutorial)

This is tutorial content for Mirage OS, written as a self-hosting slide deck.

To view the content:

* [Install Mirage](http://www.openmirage.org/wiki/install)
* `make configure`
* `make build`

To test under a local unix, set `MODE=unix`, `NET=socket` and `PORT=8080` for
`mirage configure`, build, run as `./src/mir-tutorial`, and then navigate to
`http://127.0.0.1:8080` to view the slides.

To build for deployment on Xen, set `MODE=xen` for `mirage configure`.
