# Apache Mozilla Dataset - raw and intermediate data files

The raw and intermediate data files are not included in the dataset,
mostly for privacy reasons as they contain fields identifying
people. Nevertherless, this file describes how those files are
structured.

## Git

Each Git repository has a JSON file (raw/git/<source>/repo.json)
generated with Perceval. Each JSON file was converted as a Parquet
table (raw/git/<source>/repo.parquet) containing the following
columns:
* source: source of the repository (i.e. Apache or Mozilla)
* repo: repository name
* hash: Git commit hash
* parents: this commit's parents as a single string where each hash is
  separated by spaces
* author: commit's raw author field
* author\_date\_raw: commit's raw author date
* author\_time: commit's author date parsed as a timestamp
* atuhor\_tz: timezone extracted from commit's raw author date
* committer: commit's raw committer field
* commit\_date\_raw: commit's raw commit date
* commit\_time: commit's commit date parsed as a timestamp
* commit\_tz: timezone extracted from commit's raw commit date
* message: commit's raw message
* file: filename changed in the commit
* file\_extension: file extension of the filename
* action: action on the file
* added: number of lines added
* removed: number of lines removed
* tag: tag used in Perceval (i.e. <source>/<repo>)
* backend: Perceval backend used (i.e. Git)

source, repo, hash, file and action act as a primary key of each row.

## Aggregated Git log

All Git repositories commits have been aggregated into raw/git.parquet
as a Parquet table containing the following columns:
* source: source of the repository (i.e. Apache or Mozilla)
* repo: repository name
* hash: Git commit hash
* parents: this commit's parents as a single string where each hash is
  separated by spaces
* author: commit's raw author field
* author\_date\_raw: commit's raw author date
* author\_time: commit's author date parsed as a timestamp
* atuhor\_tz: timezone extracted from commit's raw author date
* committer: commit's raw committer field
* commit\_date\_raw: commit's raw commit date
* commit\_time: commit's commit date parsed as a timestamp
* commit\_tz: timezone extracted from commit's raw commit date
* message: commit's raw message
* added: total number of lines added
* removed: total number of lines removed

source, repo and hash act as a primary key of each row.

## Jira (Apache issues)

The Jira data is split based on the product (i.e. project) tag from
the issue tracker. Each product is also split in different files
containing at most 10000 issues and stored into a JSON file generated
with Perceval (raw/jira/apache/<product>/<N>.json with <N>
representing the sequence number of the file). Different Parquet
tables are generated:
* raw/jira/apache/<product>/<N>_issues.parquet: issue metadata.
* raw/jira/apache/<product>/<N>_history.parquet: history of changes of
  the issue metadata.
* raw/jira/apache/<product>/<N>_versions.parquet: versions information
  tagged to issues.
* raw/jira/apache/<product>/<N>_comments.parquet: issue comments.

### Issues

* source: source of the repository (i.e. Apache)
* product: product/project name
* issue\_id: unique Jira identifier of the issue
* created\_raw: raw issue creation date
* created: issue creation date parsed as a timestamp
* updated\_raw: raw issue last update date
* updated: issue last update date parsed as a timestamp
* summary: summmary (i.e. title) of the issue
* description: description of the issue
* status: issue status
* priority: issue priority
* issuetype: type of issue
* resolution: type of resolution if issue is fixed/closed
* component: components (separated by line feeds) related to this
  issue
* votes: number of votes on the issue
* product\_name: product full name
* reporter\_key: unique identifier of the user who reported the issue
* reporter\_name: name of the user who reported the issue
* reporter\_displayname: displayed name of the user who reported the issue
* reporter\_email: email of the user who reported the issue
* reporter\_tz: timezone of the user who reported the issue
* creator\_key: unique identifier of the user who created the issue
* creator\_name: name of the user who created the issue
* creator\_displayname: displayed name of the user who created the issue
* creator\_email: email of the user who created the issue
* creator\_tz: timezone of the user who created the issue
* assignee\_key: unique identifier of the user who is assigned to the issue
* assignee\_name: name of the user who is assigned to the issue
* assignee\_displayname: displayed name of the user who is assigned to the issue
* assignee\_email: email of the user who is assigned to the issue
* assignee\_tz: timezone of the user who is assigned to the issue
* tag: tag used in Perceval (i.e. Apache)
* backend: Perceval backend used (i.e. Jira)

source, product and issue\_id act as a primary key of each row.

### Comments

* source: source of the repository (i.e. Apache)
* product: product/project name
* issue\_id: unique Jira identifier of the issue
* comment\_id: unique identifier of the comment
* author\_key: unique identifier of the user who authored the comment
* author\_name: name of the user who authored the comment
* author\_displayname: displayed name of the user who authored the comment
* author\_email: email of the user who authored the comment
* author\_tz: timezone of the user who authored the comment
* update\_author\_key: unique identifier of the user who updated the comment
* update\_author\_name: name of the user who updated the comment
* update\_author\_displayname: displayed name of the user who updated the comment
* update\_author\_email: email of the user who updated the comment
* update\_author\_tz: timezone of the user who updated the comment
* created\_raw: raw issue comment creation date
* created: issue comment creation date parsed as a timestamp
* updated\_raw: raw issue comment last update date
* updated: issue comment last update date parsed as a timestamp
* text: text as displayed on Bugzilla's web page

source, product, issue\_id and comment\_id act as a primary key of each row.

## Bugzilla (Mozilla issues)

The Bugzilla data is split based on the product (i.e. project) tag
from the issue tracker. Each product is also split in different files
containing at most 10000 issues and stored into a JSON file generated
with Perceval (raw/bugzilla/mozilla/<product>/<N>.json with <N>
representing the sequence number of the file). Different Parquet
tables are generated:
* raw/bugzilla/mozilla/<product>/<N>_issues.parquet: issue metadata.
* raw/bugzilla/mozilla/<product>/<N>_history.parquet: history of
  changes of the issue metadata.
* raw/bugzilla/mozilla/<product>/<N>_comments.parquet: issue comments.

### Issues

* source: source of the repository (i.e. Mozilla)
* product: product/project name
* issue\_id: unique Bugzilla identifier of the issue
* created\_raw: raw issue creation date
* created: issue creation date parsed as a timestamp
* updated\_raw: raw issue last update date
* updated: issue last update date parsed as a timestamp
* last\_resolved\_raw: raw issue last resolved date
* last\_resolved: issue last resolved date parsed as a timestamp
* component: components (separated by line feeds) related to this
  issue
* summary: summmary (i.e. title) of the issue
* version: version related to the issue
* milestone: milestone for the issue
* status: issue status
* severity: issue severity
* priority: issue priority
* resolution: type of resolution if issue is fixed/closed
* votes: number of votes on the issue
* creator\_key: unique identifier of the user who created the issue
* creator\_name: name of the user who created the issue (usually it is
  the email address in the case of Mozilla's Bugzilla)
* creator\_displayname: displayed name of the user who created the issue
* creator\_email: email of the user who created the issue
* assignee\_key: unique identifier of the user who is assigned to the issue
* assignee\_name: name of the user who is assigned to the issue
  (usually it is the email address in the case of Mozilla's Bugzilla)
* assignee\_displayname: displayed name of the user who is assigned to the issue
* assignee\_email: email of the user who is assigned to the issue
* tag: tag used in Perceval (i.e. Apache)
* backend: Perceval backend used (i.e. Jira)

source, product and issue\_id act as a primary key of each row.

### Comments

* source: source of the repository (i.e. Mozilla)
* product: product/project name
* issue\_id: unique Bugzilla identifier of the issue
* comment\_id: unique identifier of the comment
* count: sequence number of the comment in the issue
* author\_email: email of the author of the comment
* creator\_email: email of the author of the comment
* created\_raw: raw issue comment creation date
* created: issue comment creation date parsed as a timestamp
* updated\_raw: raw issue comment last update date
* updated: issue comment last update date parsed as a timestamp
* raw\_text: raw text
* text: text as displayed on Bugzilla's web page

source, product, issue\_id and comment\_id act as a primary key of each row.
