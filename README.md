# [Transcriptome profiling of mRNA and lncRNA involved in wax biosynthesis in cauliflower]()

[![Kanghua](https://img.shields.io/badge/Kanghua-github-blue?logo=github)](https://github.com/kanghuadu)

# Datasets
In this study, high-throughput RNA sequencing was performed on leaves of a wax-deficient mutant type (WL) and its wild type (YL). Here, we provied the drawing code for the manuscript. In addition, this dataset can be accessed at Figshare [https://doi.org/10.6084/m9.figshare.27727356](https://doi.org/10.6084/m9.figshare.27727356). 

# Software
Parameters for the software tools involved are described below:
(1) Fastp: version 0.24.0, parameters: -f 13 -F 13 -q 20; web: [https://github.com/OpenGene/fastp](https://github.com/OpenGene/fastp)
(2) FastQC: version 0.11.9, default parameters; web: [https://www.bioinformatics.babraham.ac.uk/projects/fastqc/](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
(3) Hisat2: version 2.2.1, parameters: -p 20 --dta --min --intronlen 20–max-intronlen 500000 --minins 0--maxins 500; web: [https://daehwankimlab.github.io/hisat2/](https://daehwankimlab.github.io/hisat2/)
(4) Samtools: version 1.21, default parameters; web: [https://github.com/samtools/samtools](https://github.com/samtools/samtools)
(5) StringTie: version 2.2.3, default parameters; --merge, parameters: -F 0 -T 0; web: [https://ccb.jhu.edu/software/stringtie/](https://ccb.jhu.edu/software/stringtie/)
(6) Gffcompare: version 0.12.9, default parameters; web: [https://github.com/gpertea/gffcompare](https://github.com/gpertea/gffcompare）
(7) FeatureCounts: version 2.1.0, default parameters; web: [https://subread.sourceforge.net/featureCounts.html](https://subread.sourceforge.net/featureCounts.html)
