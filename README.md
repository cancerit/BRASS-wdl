# BRASS-wdl

WDL descriptors for BRASS and related tooling.

## Development

* Please use the git/hub-flow methodology when working in this repository.  See [this site][hubflow] for details.
* Where applicable please add pre-commit hooks to ensure validation of syntax and linting is applie before commits are pushed.

<!-- links -->
[hubflow]: https://datasift.github.io/gitflow/

## Workflow overview
### Docker environment
The official CGP docker repository lives on Quay.io: [quay.io/wtsicgp/dockstore-cgpwgs:1.1.3](quay.io/wtsicgp/dockstore-cgpwgs:1.1.3).  
WDL does not officially support pulling docker images from Quay yet, so a lagging version is available at Dockerhub: [https://hub.docker.com/r/erictdawson/cgp-docker/](https://hub.docker.com/r/erictdawson/cgp-docker/)

### Inputs
[ ] A matched tumor/normal BAM pair, aligned with BWA.  
[ ] A set of reference supporting files (e.g. from: ftp://ftp.sanger.ac.uk/pub/cancer/dockstore/human/CNV_SV_ref_GRCh37d5_brass6+.tar.gz).

### Pre-requisites
[ ] All bam files must have a corresponding .bai file  
[ ] All bam files must have a corresponding .bas file  
[ ] All bams, indices, and reference files must be in a location accessible to your cloud system (i.e. Google Cloud Storage for FireCloud).

The following workflow description files will produce a BAI/BAS for a given BAM:
1. brass-bam-index.wdl  
2. brass-bam-stats.wdl  

### BRASS panel-of-normals filter generation
A panel of normals improves artifact removal from the final callset.  
The inputs of this process are normal-sample BAM files, which are used to generate discordant pair BAMs ("brm-bams"), merged, grouped and indexed.

The following workflow description files will produce PON filter for BRASS.
1. brass-generate-brm-bam.wdl
2. brass-merge-brm-bams.wdl
3. brass-generate-filter.wdl

### Running BRASS

### Outputs

