program test
    use VOID_Verb
    implicit none

    integer(ci), parameter :: buffersize = 512

    real(cf)               :: inBuffer(0:buffersize-1)
    real(cf)               :: outBuffer(0:buffersize-1)

    real(cf)               :: bufsum 
    integer(ci)            :: i

    call random_number(inBuffer)
    inBuffer = 2.0_cf * inBuffer - 1.0_cf

    do i = 0, buffersize-1
        call ringPush(inBuffer(i))
    end do

    call ringPopAll(outBuffer, buffersize)

    outBuffer = outBuffer - inBuffer

    bufsum = sum(outBuffer)

    if (bufsum == 0.0_cf) then
        print*, 0

    else 
        print*, 1

    end if

end program test
