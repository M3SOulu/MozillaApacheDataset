# Apache Mozilla Dataset - Git commits and Jira and Bugzilla issues metadata

This file contains the description of the fields in each Parquet files
found at the root of the data folder in the Open Science Framework
repository. For the description of the files related to natural
language processing, see the [nlp.md](https://github.com/M3SOulu/MozillaApacheDataset/blob/master/doc/nlp.md).

## Commits

All Git repositories commits have been aggregated into git.parquet
as a Parquet table containing the following columns:
* source: source of the repository (i.e. Apache or Mozilla)
* repo: repository name
* hash: Git commit hash
* parents: this commit's parents as a single string where each hash is
  separated by spaces
* author: author key SHA1 hash
* author\_time: commit's author date parsed as a timestamp
* atuhor\_tz: timezone extracted from commit's raw author date
* committer: committer key SHA1 hash
* commit\_time: commit's commit date parsed as a timestamp
* commit\_tz: timezone extracted from commit's raw commit date
* message: commit's raw message
* added: total number of lines added
* removed: total number of lines removed
* from\_svn: boolean indicating whether this commit was imported from
  SVN.
* accurate\_tz: boolean indicating whether this commit has an accurate
  timezone.
* issue\_id: Jira or Bugzilla issue id referenced in the commit message.

source, repo and hash act as a primary key of each row.

## Jira & Bugzilla issue metadata

* source: source of the repository (i.e. Apache or Mozilla)
* product: product/project name
* issue\_id: unique Jira or Bugzilla identifier of the issue
* issue\_key: secondary unique identifier for Jira issues.
* created: issue creation date parsed as a timestamp
* updated: issue last update date parsed as a timestamp
* last\_resolved: issue last resolved date parsed as a timestamp (only
  for Bugzilla)
* summary: summmary (i.e. title) of the issue
* description: description of the issue
* milestone: milestone for the issue (only for Bugzilla)
* status: issue status
* severity: issue severity (only for Bugzilla)
* priority: issue priority
* issuetype: type of issue (only for Jira)
* resolution: type of resolution if issue is fixed/closed
* component: components (separated by line feeds) related to this
  issue
* votes: number of votes on the issue
* product\_name: product full name (only for Jira)
* reporter\_key: unique identifier (SHA1) of the user who reported the
  issue (only for Jira)
* reporter\_tz: timezone of the user who reported the issue (only for Jira)
* creator\_key: unique identifier (SHA1) of the user who created the issue
* creator\_tz: timezone of the user who created the issue (only for Jira)
* assignee\_key: unique identifier (SHA1) of the user who is assigned to the issue
* assignee\_tz: timezone of the user who is assigned to the issue
  (only for Jira)

source, product and issue\_id act as a primary key of each row.

## Jira & Bugzilla issue comment metadata

* source: source of the repository (i.e. Apache or Mozilla)
* product: product/project name
* issue\_id: unique Jira or Bugzilla identifier of the issue
* comment\_id: unique identifier of the comment
* count: sequence number of the comment in the issue (only for Bugzilla)
* author\_key: unique identifier (SHA1) of the user who authored the comment
* author\_tz: timezone of the user who authored the comment (only for Jira)
* update\_author\_key: unique identifier (SHA1) of the user who
  updated the comment
* update\_author\_tz: timezone of the user who updated the comment
  (onlfy for Jira)
* created: issue comment creation date parsed as a timestamp
* updated: issue comment last update date parsed as a timestamp

source, product, issue\_id and comment\_id act as a primary key of each row.

## Identity merging

The file contains the mapping of the different identities used in the
code repositories and issue trackers to unique developer profiles.

* source: source of the identity (i.e. Apache or Mozilla)
* repo: git repository name or NA for issue trackers
* type: commits or issues
* key\_hash: SHA1 hash of the key used to identify uniquely people in
  commits.parquet, issues.parquet and comments.parquet
* merged\_id: unique identifier of a single merged profile. Identities
  with the same merged\_id belong to the same person.
* is\_bot: boolean indicating whether this identity should be
  considered as a bot
* N: number of time this identity was used

## Timezone history

This file contains for each merged developer profile the list of
timezones used in commits, alongside a timestamp indicating when the
timezone was first used since the last different timezone. Commits
with inaccurate timezone (e.g. imported from SVN) were filtered out.

* source: source of the merged profile (i.e. Apache or Mozilla)
* merged.id: unique identifier of the merged profile
* time: first timestamp for which the timezone is used
* tz: timezone used

## Timestamps

This file contains all the commit and issue timestamps of merged
developer profiles with a timezone history.

* source: source of the timestamp (i.e. Apache or Mozilla)
* repo: git repository name (only for commits)
* hash: git commit hash (only for commits)
* time: timestamp
* tz: timezone as found or inferred from commits
* person: developer (merged) profile unique identifier
* type: type of data in which the timestamp comes from (commit,
  comment or issue)
* action: action to which the timestamp relates: authored (commit),
  committed (commit), created (issue or comment), reported (issue,
  only for Jira) and updated (issue or comment)
