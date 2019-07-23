import sys

#./tensorflow/core/framework/variable.proto
# option go_package = "github.com/tensorflow/tensorflow/tensorflow/go/core/framework";

for line in sys.stdin:
    f = line.strip()
    p = '/'.join(line.split('/')[2:4])
    opt = 'option go_package = "github.com/tensorflow/tensorflow/tensorflow/go/core/{}";'.format(p)
    print("echo '{}' >> {}".format(opt, f))
