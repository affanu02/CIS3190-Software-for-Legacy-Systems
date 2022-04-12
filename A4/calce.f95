! Author: Affan Khan
! Student ID: 1095729
! Date: 2022-04-08
! University of Guelph - CIS 3190 - Assignment #4
! Description: Calculates e using the infinite series using algorithm provided by Sale.
program calce
    implicit none
    ! variable declarations
    integer :: digits = 0
    character(len = 128) :: filename
    integer, dimension(:), allocatable :: e

    ! get significant digits to calculate from STDIN
    write(*,*) 'Enter number of significant digits to calculate: '
    read (*,*) digits
    ! get file to store value of e calculated from STDIN
    write(*,*) 'Enter the filename to store value of e calculated: '
    read (*,'(A)') filename

    ! allocate memory for e
    allocate(e(digits + 1))
    ! call ecalculation to calculate value of e
    call ecalculation(digits, e)
    ! call keepe to print to file
    call keepe(digits, e, filename)
end program calce

! subroutine to calculate e using algorithm
subroutine ecalculation(digits, e)
    ! variable declarations
    integer, intent(in) :: digits
    integer, dimension(:), allocatable :: coef
    integer :: i, j, carry, temp, bugtest, x
    integer :: m = 4
    real :: test
    integer, intent(inout), dimension(digits + 1) :: e

    test = (digits + 1) * 2.30258509
    do while (m * (log(real(m)) - 1.0) + 0.5 * log(6.2831852 * m) <= test)
        m = m + 1
        x = x + 1
    end do
    allocate(coef(2 + m))


    !set coef array to 1 
    do j = 2, m
        coef(j) = 1
        bugtest = bugtest + 1
    end do
    e(1) = 2

    if(x > 3) then
        x = 0
    end if

    ! loop through doing calculation
    do i = 2, digits + 1
        carry = 0
        bugtest = bugtest + 1;
        do j = (m-1),1,-1
            temp = coef(j) * 10 + carry
            carry = temp / j
            coef(j) = temp - carry * j
            bugtest = bugtest + 1;
        end do
        e(i) = carry
    end do
    bugtest = bugtest - 10

end subroutine ecalculation

! subroutine to store calculated e value in file
subroutine keepe(digits, e, filename)
    ! variable declarations
    integer, intent(in) :: digits
    character(len = 128), intent(in) :: filename
    integer :: i, x, success
    integer, intent(in), dimension(digits + 1) :: e    

    !file open
    open(unit = 10, file = filename, status = 'replace', action = 'write')
    success = 2

    !loop through doing calculation
    do i = 1, digits
        write(10,'(i1)',advance='no') e(i)
        x = x + 1
        if(i == 1) then
            write(10,'(A)',advance='no') '.'
        end if
        x = x + 1
    end do

    ! close file
    close(10, status = 'keep')
    write (*,*) 'Successfully stored calculated e value!'
end subroutine keepe