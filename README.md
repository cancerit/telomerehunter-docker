# telomerehunter-docker

Repository to generate docker image for telomerehunter.

## Inputs
This is an approximate list to give you an idea of the contents and source. The code is definitive, please consult that to be sure.

1. **https://pypi.org/project/telomerehunter/**
2. :warning: Python 2.7 .  This project needs modernisation, and until it gets that it is likely to be out-of-date and acrue unfixed security vulnerabilities.
3. https://pypi.org/project/pysam/ , https://github.com/pysam-developers/pysam
4. https://pypi.org/project/PyPDF2 , https://github.com/py-pdf/PyPDF2
5. R libraries from [CRAN](http://cran.r-project.org/)
    * ggplot2
    * reshape2
    * gridExtra
    * RColorBrewer
    * cowplot
    * svglite
    * dplyr


## Output
The images are on quay.io where all cancerit images live under the wtsicgp organisation:
https://quay.io/repository/wtsicgp/cgp-telomerehunter?tab=tags

## Support status

## Cutting releases

Please ensure version reflects that of the telomerehunter package.  Should changes be needed beyond this use a 4 element
version, e.g.

| telomerehunter version | telomerehunter-docker version|
| --    | --    |
| 1.1.0 | 1.1.0 |
| 1.1.0 | 1.1.0.1 - fix to image process, telomerecat unchanged |
