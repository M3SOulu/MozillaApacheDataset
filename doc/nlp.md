# Apache Mozilla Dataset - NLP data

This file contains the description of the fields in each Parquet files
found in the data/nlp folder from the Open Science Framework
repository.

## General structure

The folder nlp contains a jira and bugzilla folders similar to the
with subfolders for each issue tracker product
(e.g. nlp/bugzilla/mozilla/Firefox contains all files relating to
Firefox comments). Comments for individual products are split in
different files in order to limit their size. Here the folders for
each product tag contains processed comments:
* X\_nlcomments.parquet: comments filtered to keep only natural
  language.
* X\_sentences.parquet: natural language split into sentences.
* X\_sentistrength.parquet: output of SentiStrength on X\_sentences.parquet.
* X\_senti4sd.parquet: output of Senti4SD on X\_sentences.parquet.
* X\_emoticons.parquet: emoticons found in X_nlcomments.parquet.

Each file contains the following basic columns:
* source: source of the repository (i.e. Apache or Mozilla)
* product: product/project name
* issue\_id: unique Jira or Bugzilla identifier of the issue
* comment\_id: unique identifier of the comment
* paragraph\_id: unique identifier of the paragraph

## NL comments

This file contains filtered comments to keep only natural language
with one row in the table per paragraph. It also contains columns text
and nchar with the comment paragraph text and its length (number of
characters).

## Sentences

Paragraphs are further split in sentences. This files add a
sentence\_id column to the previous file and each row contains a
single sentence.

## Emoticons

This contains the list of emoticon and emojis identified from NL
comments. The text has been removed from the file (to save space) and
the table contains the following additional column:
* start: index where the emoticon starts in the paragraph
* end: index where the emoticon ends in the paragraph
* emoticon: emoticon or emoji identified
* type: emoticon or emoji

All the files have been aggregated in a single table in
data/nlp/emoticons.parquet.

## SentiStrength

This contains the output of running SentiStrength on each
sentence. The text has been removed from the file (to save space) and
the table contains the following additional column:
* valence.min: minimum valence word of the sentence (detected using
  the default SentiStrength lexicon)
* valence.max: maximum valence word of the sentence (detected using
  the default SentiStrength lexicon)
* arousal.min: minimum arousal word of the sentence (detected using
  our own lexicon for software engineering domain)
* arousal.max: maximum arousal word of the sentence (detected using
  our own lexicon for software engineering domain)

All the files have been aggregated in a single table in
data/nlp/sentistrength.parquet.

## Senti4SD

This contains the output of running SentiStrength on each
sentence. The text has been removed from the file (to save space) and
the table contains an additional column senti4sd with the result
(positive, negative or neutral).

All the files have been aggregated in a single table in
data/nlp/senti4sd.parquet.
