library(MozillaApacheDataset)

idmerging <- ReadParquet("idmerging.parquet")
setnames(idmerging, "key", "key.orig")

identities <- data.table(orig.key=unique(idmerging$key))
system.time(identities[, key.hash := sapply(key.orig, digest::sha1)])

idmerging <- identities[idmerging, on="key.orig",
                        list(source, repo, type, key.hash,
                             merged.id, is.bot, N)]
WriteParquet(idmerging, "idmerging.parquet")

commits <- ReadParquet("commits.parquet")
commits[, author := identities[author, on="key.orig"]$key.hash]
commits[, committer := identities[committer, on="key.orig"]$key.hash]
WriteParquet(commits, "commits.parquet")

issues <- ReadParquet("issues.parquet")
issues[!is.na(creator.key),
       creator.key := identities[creator.key, on="key.orig"]$key.hash]
issues$creator.name <- NULL
issues$creator.displayname <- NULL
issues$creator.email <- NULL
issues[!is.na(reporter.key),
       reporter.key := identities[reporter.key, on="key.orig"]$key.hash]
issues$reporter.name <- NULL
issues$reporter.displayname <- NULL
issues$reporter.email <- NULL
issues[!is.na(assignee.key),
       assignee.key := identities[assignee.key, on="key.orig"]$key.hash]
issues$assignee.name <- NULL
issues$assignee.displayname <- NULL
issues$assignee.email <- NULL
WriteParquet(issues, "issues.parquet")

comments <- ReadParquet("comments.parquet")
comments[!is.na(author.key),
         author.key := identities[author.key, on="key.orig"]$key.hash]
comments$author.name <- NULL
comments$author.displayname <- NULL
comments$author.email <- NULL
comments[!is.na(update.author.key),
       update.author.key := identities[update.author.key, on="key.orig"]$key.hash]
comments$update.author.name <- NULL
comments$update.author.displayname <- NULL
comments$update.author.email <- NULL
WriteParquet(comments, "comments.parquet")
