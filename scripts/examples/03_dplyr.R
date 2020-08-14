library(arrow)
library(dplyr)

idmerging <- read_parquet("../../data_msr/idmerging.parquet")
idmerging.commits <- filter(idmerging, type == "commits" & !is_bot)
idmerging.issues <- filter(idmerging, merged_id %in% idmerging.commits$merged_id)
idmerging.issues <- idmerging.issues[, c("source", "key_hash", "merged_id")]

comments <- read_parquet("../../data_msr/comments.parquet")
comments <- comments[, c("source", "issue_id", "comment_id", "author_key")]
## Cannot allocate memory
## comments <- inner_join(comments, unique(idmerging.issues),
##                 by.x=c("source", "author_key"),
##                 by.y=c("source", "key_hash"))
## Renaming column to avoid memory allocation issue.
idmerging.issues <- unique(idmerging.issues)
idmerging.issues$author_key <- idmerging.issues$key_hash
idmerging.issues$key_hash <- NULL
comments <- inner_join(comments, idmerging.issues,
                by=c("source", "author_key"))

senti4sd <- read_parquet("../../data_msr/nlp/senti4sd.parquet")
senti4sd <- inner_join(comments, senti4sd,
                       by=c("source", "issue_id", "comment_id"))
negatives <- (senti4sd %>%
              group_by(source, product, issue_id) %>%
              summarize(negatives=sum(senti4sd == "negative"),
                        total=n()))

commits <- read_parquet("../../data_msr/commits.parquet")
commits <- inner_join(commits[, c("source", "repo", "hash", "issue_id")],
                      negatives, by=c("source", "issue_id"))
commits <- commits[commits$total > 10 & commits$negatives / commits$total > 0.1, ]
commits <- commits[order(-commits$negatives), ]
