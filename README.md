## looker3: interface with the Looker 3.0 API <a href="https://travis-ci.com/avantcredit/avant-looker3"><img src="https://img.shields.io/travis/avantcredit/avant-looker3.svg"></a> 

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
