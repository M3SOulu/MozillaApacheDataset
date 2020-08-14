library(MozillaApacheDataset)

commits <- ReadParquet("commits.parquet")
commits <- commits[repo %in% c("hadoop", "zookeeper", "releases-comm-central")]
WriteParquet(copy(commits), "sample/commits.parquet")

issues <- ReadParquet("issues.parquet")
issues <- issues[product %in% c("Thunderbird", "HADOOP", "HDFS", "ZOOKEEPER")]
WriteParquet(copy(issues), "sample/issues.parquet")

comments <- ReadParquet("comments.parquet")
comments <- comments[product %in% c("Thunderbird", "HADOOP", "HDFS", "ZOOKEEPER")]
WriteParquet(copy(comments), "sample/comments.parquet")

timestamps <- ReadParquet("timestamps.parquet")
timestamps <- timestamps[repo %in% c("hadoop", "zookeeper", "releases-comm-central") |
                         product %in% c("Thunderbird", "HADOOP", "HDFS", "ZOOKEEPER")]
WriteParquet(copy(timestamps), "sample/timestamps.parquet")

idmerging <- ReadParquet("idmerging.parquet")
idmerging <- idmerging[(type == "commits" &
                        repo %in% c("hadoop", "zookeeper", "releases-comm-central") &
                        key.hash %in% commits[, c(author, committer)]) |
                       (type == "issues" &
                        key.hash %in% c(issues[, c(reporter.key, creator.key, assignee.key)],
                                        comments[, c(author.key, update.author.key)]))]
WriteParquet(copy(idmerging), "sample/idmerging.parquet")

tzhistory <- ReadParquet("tzhistory.parquet")
tzhistory <- tzhistory[merged.id %in% idmerging$merged.id]
WriteParquet(copy(tzhistory), "sample/tzhistory.parquet")

emoticons <- ReadParquet("nlp/emoticons.parquet")
emoticons <- emoticons[product %in% c("Thunderbird", "HADOOP", "HDFS", "ZOOKEEPER")]
WriteParquet(copy(emoticons), "sample/nlp/emoticons.parquet")

senti4sd <- ReadParquet("nlp/senti4sd.parquet")
senti4sd <- senti4sd[product %in% c("Thunderbird", "HADOOP", "HDFS", "ZOOKEEPER")]
WriteParquet(copy(senti4sd), "sample/nlp/senti4sd.parquet")

sentistrength <- ReadParquet("nlp/sentistrength.parquet")
sentistrength <- sentistrength[product %in% c("Thunderbird", "HADOOP", "HDFS", "ZOOKEEPER")]
WriteParquet(copy(sentistrength), "sample/nlp/sentistrength.parquet")
