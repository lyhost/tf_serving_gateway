
Refer:
   https://github.com/lyhost/serving
   https://github.com/devsu/grpc-gateway-generator

# Usage
```
ln -s path/to/tensorflow .
ln -s path/to/tensorflow_serving .
```

edit
```
template/definitions/list.json
template/grpc-gateway.go
```

```
make
make install
make run
```
