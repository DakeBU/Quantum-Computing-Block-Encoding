# Cubic State-Preparation Diagnostics

These are necessary-condition diagnostics, not final block-encoding certificates.

| n | N | norm^2 | norm approx | dense vector entries | dense one-aux unitary memory | precision bits floor |
|---:|---:|---|---:|---:|---:|---:|
| 1 | 2 | `1/64` | 0.125 | 2 | 256 B | 34 |
| 2 | 4 | `397/2048` | 0.440281 | 4 | 1 KiB | 34 |
| 4 | 16 | `3810365/2097152` | 1.34793 | 16 | 16 KiB | 34 |
| 8 | 256 | `79326205235005/2199023255552` | 6.00611 | 256 | 4 MiB | 34 |
| 12 | 4096 | `1348094926504548618045/2305843009213693952` | 24.1794 | 4096 | 1 GiB | 34 |
| 16 | 65536 | `22635408953845511612687175485/2417851639229258349412352` | 96.7563 | 65536 | 256 GiB | 34 |
| 20 | 1048576 | `379778159717727518419871926047723325/2535301200456458802993406410752` | 387.035 | 1048576 | 64 TiB | 34 |

Interpretation: dense executable verification is useful for small `n`, but it materializes data that grows exponentially.  The ABEIS route should use the cubic arithmetic structure and prove a symbolic family in Lean.
