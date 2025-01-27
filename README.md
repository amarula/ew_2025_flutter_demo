# ew_2025_flutter_demo

Flutter thermostat demo for Embedded World 2025

# Run on Target

```shell
export FLUTTER_TAG="$( (cd /usr/share/flutter/ && printf -- '%s\n' */) | head -n 1)"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH":/usr/share/flutter/"$FLUTTER_TAG"/release/lib/
/usr/bin/flutter-client -f -b /usr/share/flutter/ew_2025_flutter_demo/"$FLUTTER_TAG"/release/
```

![Normal](screenshot/homepage.png)
---
![Boosting](screenshot/forecast.png)