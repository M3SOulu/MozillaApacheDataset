import pandas
import matplotlib.pyplot as plt

issues = pandas.read_parquet("../../data_msr/issues_fixed.parquet")
years = issues.groupby(issues.created.dt.year).size()

plt.plot(years)
plt.show()
