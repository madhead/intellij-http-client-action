FROM jetbrains/intellij-http-client:251.27812.49

RUN apk add --no-cache bash

COPY intellij-http-client-action.sh /intellij-http-client-action.sh

ENTRYPOINT ["/intellij-http-client-action.sh"]
