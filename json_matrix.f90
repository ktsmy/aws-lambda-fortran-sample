!
! get matrix (array in array) using json-fortran
! https://github.com/jacobwilliams/json-fortran/issues/203
!
module json_matrix
contains

subroutine get_matrix(json_str, path, amat)
use json_module
implicit none

character(*), intent(in):: json_str, path
real(8), pointer, intent(out):: amat(:,:)
type(json_file):: json
integer :: i,n_cols,n_rows,var_type
logical:: found
type(json_value),pointer :: pa, child
type(json_core) :: core
real(8), allocatable:: buf(:)

call json%initialize()
call json%load_from_string(json_str)
call json%info(path,found,var_type,n_cols)
call json%info(path // '(1)',found,var_type,n_rows)
call json%get(path, pa)
allocate(amat(n_rows, n_cols))
do i = 1, n_cols
  call core%get_child(pa, i, child)
  call core%get(child, buf)
  amat(:, i) = buf(:)
  nullify(child)
  deallocate(buf)
end do
nullify(pa)

return
end subroutine get_matrix

subroutine get_vector(json_str, path, bvec)
use json_module
implicit none

character(*), intent(in):: json_str, path
real(8), pointer, intent(out):: bvec(:)
type(json_file):: json
integer :: i,n_length,var_type
logical:: found
real(8), allocatable:: buf(:)

call json%initialize()
call json%load_from_string(json_str)
call json%info(path,found,var_type,n_length)
allocate(bvec(n_length))
call json%get(path, buf, found)
bvec(:) = buf(:)
deallocate(buf)

return
end subroutine get_vector

subroutine get_size(json_str, path, n)
use json_module
implicit none

character(*), intent(in):: json_str, path
integer, intent(out):: n
type(json_file):: json
integer:: var_type
logical:: found

call json%initialize()
call json%load_from_string(json_str)
call json%info(path,found,var_type,n)

return
end subroutine get_size

end module json_matrix
