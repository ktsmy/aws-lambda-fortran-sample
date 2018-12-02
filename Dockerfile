FROM amazonlinux:latest

# install fortran compiler
RUN yum -y install gcc-gfortran glibc-static

# install json-fortran
RUN yum -y install git cmake make patch
RUN mkdir /build
RUN cd /build && git clone https://github.com/jacobwilliams/json-fortran.git 
RUN cd /build && \ 
    cmake json-fortran || true && \
    make && \
    make install

# install LAPACK
RUN yum -y install lapack-static blas-static

# build program
COPY json_matrix.f90 linear_eq.f90 /
RUN gfortran -I/usr/local/jsonfortran-gnu-6.10.0/lib -c json_matrix.f90
RUN gfortran -I/usr/local/jsonfortran-gnu-6.10.0/lib -c linear_eq.f90
RUN gfortran -static -o linear_eq linear_eq.o json_matrix.o /usr/local/jsonfortran-gnu-6.10.0/lib/libjsonfortran.a -llapack -lblas

CMD /bin/bash
