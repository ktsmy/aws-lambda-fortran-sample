TARGET=linear_eq
IMAGE=fortran-lambda:latest

all: $(TARGET).zip

$(TARGET).zip: $(TARGET) bootstrap
	zip $(TARGET).zip bootstrap $(TARGET)

$(TARGET): linear_eq.f90 json_matrix.f90
	docker build -t $(IMAGE) .
	docker run -it --rm -v `pwd`:/tmp -w /tmp --entrypoint=cp $(IMAGE) /$(TARGET) /tmp

test:
	#   x1 + 3*x2 =  7
	# 2*x2 + 4*x2 = 10
	docker run -it --rm $(IMAGE) /$(TARGET) '{"a": [[1,2],[3,4]], "b":[7,10]}'

clean:
	rm -f $(TARGET) *.zip
