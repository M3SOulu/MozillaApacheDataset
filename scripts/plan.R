library(MozillaApacheDataset)

logging::basicConfig()
pkgconfig::set_config("drake::strings_in_dots"="literals")
future::plan(future::multiprocess)

datadir <- "."

repos <- RawData(datadir)
plan <- bind_plans(GitPlan(repos, datadir),
                   JiraPlan(repos, datadir),
                   BugzillaPlan(repos, datadir),
                   IssuePlan(datadir),
                   ModelsPlan(),
                   IdentityMergingPlan(datadir),
                   LogPlan(datadir),
                   NLPPlan(repos, datadir,
                           senti4sd.chunk.limit=3000),
                   NLPAggregatePlan(repos, datadir, "sentistrength"),
                   NLPAggregatePlan(repos, datadir, "senti4sd"),
                   NLPAggregatePlan(repos, datadir, "emoticons"))

system.time(drake::make(plan, "", #parallelism="future", jobs=4,
                        memory_strategy="autoclean",
                        garbage_collection=TRUE))
