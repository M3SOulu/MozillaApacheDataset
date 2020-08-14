import pandas
import matplotlib.pyplot as plt

timestamps = pandas.read_parquet("../../data_msr/timestamps_fixed.parquet")
timestamps = timestamps[timestamps.tz.notnull()]

def local_time(time, tz):
    tz = (tz.str[:3].astype(int) + tz.str[3:].astype(int) * 60)
    return time + pandas.to_timedelta(tz, 'h')

timestamps['local_time'] = local_time(timestamps.time, timestamps.tz)
hours = timestamps.groupby(timestamps.local_time.dt.hour).size()

plt.plot(hours)
plt.show()
