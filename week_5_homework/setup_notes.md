### Spark issues

I was able to get to `spark-shell` using:

```
spark-shell --conf "spark.driver.extraJavaOptions=-Djava.security.manager=allow"
```

I swapped to spark 3.4.4 to solve an issue with the pandas data frame. I could have downgraded pandas as well.


