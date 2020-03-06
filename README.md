# MozillaApacheDataset

This repository contains files related to the MSR 2020 dataset paper
"20-MAD - 20 years of issues and commits of Mozilla and Apache
Development". This serves as a central access point to the
documentation for the dataset.

The dataset itself is located in
an [OSF repository](https://osf.io/kvxr4/).

If you reuse this dataset for conducting research, please cite the
following paper in your publications:
Claes, Maëlick, and Mika Mäntylä. "Towards automatically identifying
paid open source developers." Proceedings of the 17th International
Conference on Mining Software Repositories. 2019.

# Data

The data folder hosted on Open Science Framework contains the dataset
itself as multiple Parquet files. Data files are organized in a way so
that most data processing operation can be run on an average modern
laptop (i.e. with at least 8 GB of memory) using a map reduce
approach.

The full documentation of the dataset can be found in the
[doc folder](https://github.com/M3SOulu/MozillaApacheDataset/blob/master/data.md) of
this repository.

The files commits.parquet, issues.parquet and comments.parquet contain
the aggregated metadata from commit repositories and issue
trackers. The file comments.parquet only contains the comment
meta-data but not the actual comments so it can be opened on a
computer with 8GB of memory.

The folder nlp contains a jira and bugzilla folders similar to the
with subfolders for each issue tracker product
(e.g. nlp/bugzilla/mozilla/Firefox contains all files relating to
Firefox comments). Comments for individual products are split in
different files in order to limit their size. Here the folders for
each product tag contains processed comments:
* X\_nlcomments.parquet: comments filtered to only keep natural
  language.
* X\_sentences.parquet: natural language split into sentences.
* X\_sentistrength.parquet: output of SentiStrength on X\_sentences.parquet.
* X\_senti4sd.parquet: output of Senti4SD on X\_sentences.parquet.
* X\_emoticons.parquet: emoticons found in X_nlcomments.parquet.

There are also three Parquet files (sentistrength.parquet,
senti4sd.parquet, emoticons.parquet) in the nlp folder containing
aggregated data for the corresponding files available in
subdirectories.

Finally, the data folder also contains idmerging.parquet and
tzhistory.parquet and timestamps.parquet that contain respectively the
result of the identity merging, the history of timezones for each
(merged) developer and the log of all timestamp activity for each
(merged) developer.

The public version of the dataset, only contains anonymized developer
information. All fields in commits.parquet, issues.parquet,
comments.parquet and idmerging.parquet containing personal information
were replaced with SHA1 hashes.

# R packages

The package folder contains several packages, hosted on different
GitHub repositories, and files needed to process the raw data.

MozillaApacheDataset is the main package related to the dataset. It
relies on drake, a computation system for data analysis in R similar
to the Unix tool make. We build a large drake plan that can be used to
automatically figure out which data files are up to date and which
needs to (re)generated in case of failure during execution.

The other packages are dependencies:
* NLoN is the package we developed for identifying which parts of
  comments are natural language and which are not. This package is
  already publicly available: https://github.com/M3SOulu/NLoN
* EmoticonFindeR is the package we wrote to detect emoticons and
  emojis with regular expressions and is also already publicly
  available: https://github.com/M3SOulu/EmoticonFindeR
* RSentiStrength and RSenti4SD are very simple packages used to
  instrument SentiStrength and Senti4SD within R:
  https://github.com/M3SOulu/RSentiStrength and
  https://github.com/M3SOulu/RSenti4SD.

For simplifying replicability, we also provide a Docker image on
Docker Hub that contains the packages and all their dependencies
already installed:
https://hub.docker.com/repository/docker/claesmaelick/mozilla-apache-dataset
The Dockerfile for building the image is included in the package
folder.

While the Docker image doesn't include the data itself, a container
can be created to acces it with the following bash command:

```
docker run -d -v $(pwd):/MozillaApacheDataset \
       -p 127.0.0.1:42222:22 \
       --name mozilla-apache-dataset \
       --ulimit stack=16777216:16777216 \
       claesmaelick/mozilla-apache-dataset
```

(The --ulimit argument is necessary so R can process certain comments
that are very large.)

Then one can SSH in 127.0.0.1:42222 with the username and password
"rstudio" and run R from there and access the data, e.g.:

```
library(arrow)
read_parquet("/MozillaApacheDataset/timestamps.parquet
```

# Raw data

The raw and intermediate data files are not included in the dataset,
mostly for privacy reasons as they contain fields identifying people.

Nevertherless, this section describes how it can be stored in order to
reproduce the processing pipeline leading to the final dataset.

The raw and intermediate data is stored in data/raw and contains the following files:
* Git
  * Each Git repository raw data is either stored as a single JSON
    file raw/git/\<source\>/\<repo\>.json or as multiple JSON files in a
    folder raw/git/\<source\>/\<repo\>
  * Each JSON file was converted to 2 Parquet tables
    \<filename\>\_log.parquet and \<filename\>\_diff.parquet
* Jira
  * Apache's issue tracker raw data is stored inside
    raw/jira/apache. Individual folders contain issues specific to one
    product tag. For example raw/jira/apache/HADOOP contains all JSON
    files containing issues for Hadoop.
  * Each JSON file was converted to 4 Parquet tables: one for the
    issue meta-data, one for the comments, one for the history of the
    changes of issue metadata and one for the version tags of the
    issue. In the current dataset, the two last files aren't used.
* Bugzilla
  * Mozilla's issue tracker raw data is stored inside
    raw/bugzilla/mozilla. Individual folders contain issues specific
    to one product tag. For example raw/bugzilla/mozilla/Firefox
    contains all JSON files containing issues for Firefox.
  * Each JSON file was converted to 3 Parquet tables: one for the
    issue meta-data, one for the comments and one for the history of
    the changes of issue metadata. In the current dataset, the last
    file isn't used.
