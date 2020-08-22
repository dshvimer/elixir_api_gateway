APP_NAME=test
MODULE_NAME=Test

mix phx.new . \
    --app ${APP_NAME} \
    --module ${MODULE_NAME} \
    --database postgres \
    --binary-id