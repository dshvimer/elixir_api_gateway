APP_NAME=gateway
MODULE_NAME=Gateway

mix phx.new . \
    --app ${APP_NAME} \
    --module ${MODULE_NAME} \
    --database postgres \
    --binary-id