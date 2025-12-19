FROM jetbrains/intellij-http-client:253.29346.138

RUN apk add --no-cache bash

COPY intellij-http-client-action.sh /intellij-http-client-action.sh

ENTRYPOINT ["/intellij-http-client-action.sh"]
