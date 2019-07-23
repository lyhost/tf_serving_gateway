GOPATH=${HOME}/go
PROTOC_FLAGS=-I tensorflow -I tensorflow_serving -I/usr/local/include -I. -I${GOPATH}/src -I${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis

DESTINATION_PATH=build
STUBS_PATH=${DESTINATION_PATH}/stubs
SWAGGER_PATH=${DESTINATION_PATH}/swagger-ui
DEFINITIONS_PATH=${DESTINATION_PATH}/definitions

SED_OPTS="-i"

code:
	rm -fr ${DESTINATION_PATH}
	mkdir -p ${DESTINATION_PATH}
	cp -r template/* ${DESTINATION_PATH}
	mkdir -p ${STUBS_PATH}
	mkdir -p ${DEFINITIONS_PATH}
	mkdir -p ${SWAGGER_PATH}
	find -L tensorflow -type f -name "*.proto" -exec protoc ${PROTOC_FLAGS} --go_out=plugins=grpc:${STUBS_PATH} {} \;
	find -L tensorflow_serving -type f -name "*.proto" -exec protoc ${PROTOC_FLAGS} --go_out=plugins=grpc:${STUBS_PATH} {} \;
	find -L tensorflow_serving/tensorflow_serving/apis -type f -name "*service.proto" -exec protoc ${PROTOC_FLAGS} --grpc-gateway_out=logtostderr=true:${STUBS_PATH} {} \;

	find -L tensorflow_serving/tensorflow_serving/apis -type f -name "*service.proto" -exec protoc ${PROTOC_FLAGS} \
		--swagger_out=logtostderr=true:${DEFINITIONS_PATH} {} \;

run:
	cd ~/go/src/gw && go build grpc-gateway.go && go run grpc-gateway.go
