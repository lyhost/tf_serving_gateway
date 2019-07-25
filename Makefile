PROTOC_FLAGS=-I tensorflow -I tensorflow_serving -I/usr/local/include -I. \
	-I${GOPATH}/src -I${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis

DESTINATION_PATH=build
STUBS_PATH=${DESTINATION_PATH}/stubs
SWAGGER_PATH=${DESTINATION_PATH}/swagger-ui
DEFINITIONS_PATH=${SWAGGER_PATH}/definitions

SED_OPTS="-i"

code:
	rm -fr ${DESTINATION_PATH}
	mkdir -p ${DESTINATION_PATH}
	cp -r template/* ${DESTINATION_PATH}
	mkdir -p ${STUBS_PATH}
	mkdir -p ${DEFINITIONS_PATH}
	mkdir -p ${SWAGGER_PATH}


#	find -L tensorflow/tensorflow/core -type f -name "*.proto" \
#	  	| xargs grep -l "option go_package" \
#	  	| xargs -n 1 protoc ${PROTOC_FLAGS} --go_out=plugins=grpc:${STUBS_PATH}
	find -L tensorflow -type f -name "*.proto" \
		| xargs grep -l "option go_package" \
	  	| xargs -n 1 protoc ${PROTOC_FLAGS} --go_out=plugins=grpc:${STUBS_PATH}

# tf servring pb
	find -L tensorflow_serving -type f -name "*.proto" -exec protoc ${PROTOC_FLAGS} --go_out=plugins=grpc:${STUBS_PATH} {} \;
	rm -fr ${STUBS_PATH}/tensorflow_serving/apis/prediction_log.*

# Gateway pb
	find -L tensorflow_serving/tensorflow_serving/apis -type f -name "*service.proto" \
		-exec protoc ${PROTOC_FLAGS} --grpc-gateway_out=logtostderr=true:${STUBS_PATH} {} \;

# Swagger
	find -L tensorflow_serving/tensorflow_serving/apis -type f -name "*service.proto" -exec protoc ${PROTOC_FLAGS} \
		--swagger_out=logtostderr=true:${DEFINITIONS_PATH} {} \;

install:
	rm -fr ${GOPATH}/src/github.com/tensorflow
	rm -fr ${GOPATH}/src/tensorflow_serving
	rm -fr ${GOPATH}/src/gw
	mkdir -p ${GOPATH}/src/github.com
	cp -r ${STUBS_PATH}/github.com/tensorflow ${GOPATH}/src/github.com
	cp -r ${STUBS_PATH}/tensorflow_serving ${GOPATH}/src
	cp -r ${DESTINATION_PATH} ${GOPATH}/src/gw
	rm -fr ${GOPATH}/src/gw/stubs

run:
	cd ${GOPATH}/src/gw && go build grpc-gateway.go && go run grpc-gateway.go
