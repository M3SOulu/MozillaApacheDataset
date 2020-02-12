## -*- docker-image-name: "claesmaelick/mozilla-apache-dataset" -*-

FROM rocker/verse:3.6.1

## Packages for SSH and arrow repo
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    apt-transport-https \
    curl \
    gnupg \
    lsb-release \
    openssh-server \
    libx11-dev \
    x11proto-core-dev \
    xauth \
    xfonts-base \
    xvfb \
    bash-completion && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/ && \
    mkdir /var/run/sshd

# SSH config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/X11Forwarding no/X11Forwarding yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#X11UseLocalhost yes/X11UseLocalhost no/g' /etc/ssh/sshd_config

## Apache Arrow repo
RUN echo deb http://deb.debian.org/debian $(lsb_release --codename --short)-backports main | \
    tee -a /etc/apt/sources.list.d/backports.list && \
    curl --output /usr/share/keyrings/apache-arrow-keyring.gpg https://dl.bintray.com/apache/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-keyring.gpg && \
    echo deb [arch=amd64 signed-by=/usr/share/keyrings/apache-arrow-keyring.gpg] https://dl.bintray.com/apache/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/ $(lsb_release --codename --short) main | \
    tee -a /etc/apt/sources.list.d/apache-arrow.list && \
    echo deb-src [signed-by=/usr/share/keyrings/apache-arrow-keyring.gpg] https://dl.bintray.com/apache/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/ $(lsb_release --codename --short) main | \
    tee -a /etc/apt/sources.list.d/apache-arrow.list && \
    curl https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add - && \
    echo deb http://apt.llvm.org/$(lsb_release --codename --short)/ llvm-toolchain-$(lsb_release --codename --short)-7 main | \
    tee -a /etc/apt/sources.list.d/llvm.list && \
    echo deb-src http://apt.llvm.org/$(lsb_release --codename --short)/ llvm-toolchain-$(lsb_release --codename --short)-7 main | \
    tee -a /etc/apt/sources.list.d/llvm.list

## Libs for R packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libpoppler-cpp-dev \
    libpoppler-glib-dev \
    libarrow-dev=0.15.1-1 \
    libparquet-dev=0.15.1-1 \
    python3-pandas \
    python3-arrow \
    libpython3-dev

## Development R packages
RUN install2.r -e -s -n 4 \
    rmarkdown knitr roxygen2 devtools testthat assertr

## Generic R packages
RUN install2.r -e -s -n 4 \
    plyr dplyr magrittr stringr logging tidyr modules drake R.utils RCurl pryr

## Data packages
RUN install2.r -e -s -n 4 \
    data.table ISOweek lubridate igraph arrow

## Programming languages R packages
RUN install2.r -e -s -n 4 \
    rJava reticulate

## Parallel R packages
RUN install2.r -e -s -n 4 \
    pbapply doParallel foreach future

## Plot packages
RUN install2.r -e -s -n 4 \
    ggplot2 ggraph visNetwork

## NLP packages
RUN install2.r -e -s -n 4 \
    lexicon textstem tm NLP openNLP text2vec cleanNLP tokenizers

## ML packages
RUN install2.r -e -s -n 4 \
  LiblineaR MLmetrics e1071 caret glmnet ModelMetrics

## R packages
WORKDIR /packages

COPY ./RSenti4SD /packages/RSenti4SD
RUN R CMD INSTALL ./RSenti4SD
RUN Rscript -e "RSenti4SD::DownloadSenti4SD(\"8a3467e9e8dbaa0af9343862aadc83a56a4668bc\")"

COPY ./RSentiStrength /packages/RSentiStrength
RUN R CMD INSTALL ./RSentiStrength

COPY ./NLoN /packages/NLoN
RUN R CMD INSTALL ./NLoN

COPY ./EmoticonFindeR /packages/EmoticonFindeR
RUN R CMD INSTALL ./EmoticonFindeR

COPY ./MozillaApacheDataset /packages/MozillaApacheDataset
RUN R CMD INSTALL ./MozillaApacheDataset

RUN chsh -s /bin/bash rstudio

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
