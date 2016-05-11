## looker3: interface with the Looker 3.0 API [![Build Status](http://de-jenkins.rd.avant.com/jenkins/buildStatus/icon?job=avant-looker3)](http://de-jenkins.rd.avant.com/jenkins/job/avant-looker3/) 

Pull data from Looker with the 3.0 API.

## Installation

```R
if (!require("devtools")) { install.packages("devtools") }
devtools::install_github("avantcredit/looker3")
```

## How it works

Before pulling data from Looker, you need to set up environment variables LOOKER_URL, LOOKER_ID, and LOOKER_SECRET with the url to your Looker instance, your client id, and your client secret respectively.

Once those are set up, you can access data using the `looker3` function:
```R
library("looker3")
df <- looker3(model = "thelook",
              view = "orders",
              fields = c("orders.count", "orders.created_month")
              filters = list("orders.created_month" = "90 days", "orders.status" = "complete")
)
```

Filters can be specified as above, or as a character string with colon separations, e.g. 

```
filters = c("orders.created_month: 90 days", "orders.status: complete")
```
