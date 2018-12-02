program hello
use json_module
use json_matrix
implicit none

type(json_file) :: json
character(2048):: json_str
logical:: found
real(8), pointer:: a(:,:), b(:)
real(8), allocatable:: x(:), work(:)
real(4), pointer:: swork(:)
integer, allocatable:: ipiv(:)
integer:: n, i, iter, info

call getarg(1, json_str)

call get_size(json_str, 'a', n)
call get_matrix(json_str, 'a', a)
call get_vector(json_str, 'b', b)

allocate(x(n))
allocate(ipiv(n))
allocate(work(n))
allocate(swork(n*(n+1)))
call DSGESV(n, 1, a, n, ipiv, b, n, x, n, work, swork, iter, info)

do i=1,n
  write(*,'(a2,i4,a2,f10.2)') 'x(', i, ')=', x(i)
end do

stop
end program hello
