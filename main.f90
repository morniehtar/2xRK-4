module config
    implicit none
    public

    !Segment boundaries
    real(8), parameter :: fl = 0.d0, cl = 1.d0
    !Integration precision
    integer, parameter :: dots = 10
end module config

program output
    use config
    implicit none

    procedure(func), pointer :: fptr, gptr
    fptr => func
    gptr => gunc

    call integ(fptr, gptr, fl, cl)

contains

    !y'=func(x, y, z)
    !z'=gunc(x, y, z)

    pure real(8) function func(x, y, z)
        implicit none
        real(8), intent(in) :: x, y, z
        func = x / z
    end function func

    pure real(8) function gunc(x, y, z)
        implicit none
        real(8), intent(in) :: x, y, z
        gunc = - x / y
    end function gunc

    subroutine integ(fptr, gptr, st, ed)
        use config
        implicit none

        procedure(func), pointer, intent(in) :: fptr, gptr
        real(8), intent(in) :: st, ed
        real(8), dimension(4) :: k, l
        real(8) :: x0, x, y, z, step
        integer :: i, j

        step = (ed - st) / dots

        !Initial conditions
        x0 = 0.d0
        y = 1.d0
        z = 1.d0

        open(unit = 1, file = "output.dat")
        do i = 1, dots+1
            x = x0 + (i-1)*step
            write(1,*) x, y, ysltn(x), z, zsltn(x)

            k(1) = fptr(x, y, z)
            l(1) = gptr(x, y, z)

            k(2) = fptr(x+step/2, y+k(1)*step/2, z+k(1)*step/2)
            l(2) = gptr(x+step/2, y+l(1)*step/2, z+l(1)*step/2)

            k(3) = fptr(x+step/2, y+k(2)*step/2, z+k(2)*step/2)
            l(3) = gptr(x+step/2, y+l(2)*step/2, z+l(2)*step/2)

            k(4) = fptr(x+step, y+k(3)*step, z+k(3)*step)
            l(4) = gptr(x+step, y+l(3)*step, z+l(3)*step)

            y = y + step*(k(1)+2*k(2)+2*k(3)+k(4))/6
            z = z + step*(l(1)+2*l(2)+2*l(3)+l(4))/6

        end do
        close(1)

    end subroutine integ

    pure real(8) function ysltn(x)
        !Red dashed line
        implicit none
        real(8), intent(in) :: x
        ysltn = exp(x**2/2)
    end function ysltn

    pure real(8) function zsltn(x)
        !Green dashed line
        implicit none
        real(8), intent(in) :: x
        zsltn = exp(-x**2/2)
    end function zsltn

end program output
