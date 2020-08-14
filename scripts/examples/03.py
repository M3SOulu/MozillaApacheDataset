import pandas

idmerging = pandas.read_parquet("../../data_msr/idmerging.parquet")
idmerging_commits = idmerging[(idmerging.type == 'commits') & (~idmerging.is_bot)]
idmerging_issues = idmerging[idmerging.merged_id.isin(idmerging_commits.merged_id)]
idmerging_issues = idmerging_issues[['source', 'key_hash', 'merged_id']].drop_duplicates()

comments = pandas.read_parquet("../../data_msr/comments.parquet")
comments = comments[['source', 'issue_id', 'comment_id', 'author_key']]
comments = comments.merge(idmerging_issues,
                          left_on=('source', 'author_key'),
                          right_on=('source', 'key_hash'))

senti4sd = pandas.read_parquet("../../data_msr/nlp/senti4sd.parquet")
senti4sd = comments.merge(senti4sd, on=('source', 'issue_id', 'comment_id'))
senti4sd['is_negative'] = senti4sd.senti4sd == 'negative'
negatives = senti4sd.groupby(['source', 'product', 'issue_id'])
negatives = pandas.DataFrame({'total': negatives.size(),
                              'negatives': negatives['is_negative'].sum()})

commits = pandas.read_parquet("../../data_msr/commits_nomessage.parquet")
commits = commits[['source', 'repo', 'hash', 'issue_id']]
commits = commits.merge(negatives.reset_index(), on=('source', 'issue_id'))
commits = commits[(commits.total > 10) & (commits.negatives / commits.total > 0.1)]
commits.sort_values('negatives', ascending=False)
