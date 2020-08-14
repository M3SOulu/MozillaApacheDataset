library(arrow)
library(data.table)

idmerging <- as.data.table(read_parquet("../../data_msr/idmerging.parquet"))
idmerging.commits <- idmerging[type == "commits" & !is_bot, unique(merged_id)]
idmerging.issues <- idmerging[merged_id %in% idmerging.commits,
                              list(source, key_hash, merged_id)]

comments <- as.data.table(read_parquet("../../data_msr/comments.parquet"))
comments <- comments[, list(source, issue_id, comment_id, author_key)]
comments <- merge(comments, unique(idmerging.issues),
                  by.x=c("source", "author_key"),
                  by.y=c("source", "key_hash"))

senti4sd <- as.data.table(read_parquet("../../data_msr/nlp/senti4sd.parquet"))
senti4sd <- merge(comments, senti4sd, by=c("source", "issue_id", "comment_id"))
negatives <- senti4sd[, list(negatives=sum(senti4sd == "negative"), total=.N),
                      by=list(source, product, issue_id)]

commits <- as.data.table(read_parquet("../../data_msr/commits.parquet"))
commits <- merge(commits[, list(source, repo, hash, issue_id)],
                 negatives, by=c("source", "issue_id"))
commits <- commits[total > 10 & negatives / total > 0.1, ][order(-negatives)]
