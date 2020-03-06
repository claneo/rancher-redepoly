FROM alpine
COPY redeploy.sh redeploy.sh
RUN apk add --no-cache curl jq \
  && chmod +x redeploy.sh
CMD [ "redeploy.sh" ]