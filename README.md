# MozillaApacheDataset

Here are located files that will be publicly available upon the
publication of the MSR paper "20-MAD - 20 years of issues and commits
of Mozilla and Apache Development".

# Data

The data folder contains all the raw, intermediate and final data.

Data files are organized in a way so that most data processing
operation can be run on an average modern laptop (i.e. with at least 8
GB of memory) using a map reduce approach.

The raw and intermediate data is stored in data/raw and contains the following files:
* Git
  * Each Git repository raw data is either stored as a single JSON
    file raw/git/<source>/<repo>.json or as multiple JSON files in a
    folder raw/git/<source>/<repo>
  * Each JSON file was converted to 2 Parquet tables
    <filename>\_log.parquet and <filename>\_diff.parquet
* Jira
  * Apache's issue tracker data is stored inside
    raw/jira/apache. Individual folders contain issues specific to one
    product tag. For example raw/jira/apache/HADOOP contains all JSON
    files containing issues for Hadoop.
  * Each JSON file was converted to 4 Parquet tables: one for the
    issue meta-data, one for the comments, one for the history of the
    changes of issue metadata and one for the version tags of the
    issue. In the current dataset, the two last files aren't used.
* Bugzilla
  * Mozilla's issue tracker data is stored inside
    raw/bugzilla/mozilla. Individual folders contain issues specific
    to one product tag. For example raw/bugzilla/mozilla/Firefox
    contains all JSON files containing issues for Firefox.
  * Each JSON file was converted to 3 Parquet tables: one for the
    issue meta-data, one for the comments and one for the history of
    the changes of issue metadata. In the current dataset, the last
    file isn't used.

The files raw/git.parquet, raw/issues.parquet and raw/comments.parquet
contains the aggregated metadata found in the other folders. The file
raw/comments.parquet only contains the comment meta-data but not the
actual comments so it can be opened on a computer with 8GB of memory.

The folder nlp contains a jira and bugzilla folders similar to the
ones found in the raw folder. Here the folders for each product tag
contains processed comments:
* X.parquet: pre-processed raw comments.
* X\_nlcomments.parquet: comments filtered to only keep natural
  language.
* X\_sentences.parquet: natural language split into sentences.
* X\_sentistrength.parquet: output of SentiStrength on X\_sentences.parquet.
* X\_senti4sd.parquet: output of Senti4SD on X\_sentences.parquet.
* X\_emoticons.parquet: emoticons found in X_nlcomments.parquet.

Upon publication, we will publicly release commits.parquet,
issues.parquets, comments.parquet, identities.parquet,
idmerging.parquet, tzhistory.parquet, timestamps.parquet and the whole
nlp folder.

Because the raw data contains personal developer information, we don't
share it publicly. The public version of the dataset, only contains
anonymized data by replacing fields containing names and emails with
SHA1 hash.

# R packages

The Rpackage folder contains several packages and files needed to
process the raw data.

MozillaApacheDataset is the main package related to the dataset. It
relies on drake, a computation system for data analysis in R similar
to the Unix make tool. We build a large drake plan that can be used to
automatically figure out which data files are up to date and which
needs to (re)generated in case of failure during execution.

The other packages are dependencies:
* NLoN is the package we developed for identifying which parts of
  comments are natural language and which are not. This package is
  already publicly available: https://github.com/M3SOulu/NLoN
* EmoticonFindeR is the package we wrote to detect emoticons and
  emojis with regular expressions and is also already publicly
  available: https://github.com/M3SOulu/EmoticonFindeR
* AutoTimeNLP is an unreleased package containing various NLP
  functions, including the code running Senti4SD and
  SentiStrength. For the public release, we will most likely include
  this code directly into MozillaApacheDataset.

For simplifying replicability, we also provide a Docker image on
Docker Hub that contains the packages and all their dependencies
already installed:
https://hub.docker.com/repository/docker/claesmaelick/autotime-packages
The Dockerfile for building the image is included in the Rpackage
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
