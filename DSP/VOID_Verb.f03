module VOID_Verb

    use numtype
    use buffers
    implicit none



    type, bind(c) :: ringWrapper
    !
    ! Simple wrapper to expose ring buffer
    ! to c++ for CI/CD integration
    !
        integer(ci) :: size
        real(cf)    :: delayline(150000)
        integer(ci) :: writeIdx
        integer(ci) :: readIdx 

    end type ringWrapper


    subroutine ringPush(buffer, val) bind(C)
    !
    !   wraps bufferRing%push()
    !
        type(ringWrapper), intent(inout) :: buffer
        real(cf), intent(in)             :: val
        integer(ci)                      :: i

        i = buffer%writeIdx + 1
        buffer%delayline(i) = val
        buffer%writeIdx = mod(buffer%writeIdx + 1, buffer%size)

    end subroutine ringPush


    subroutine ringPopAll(buffer, memory, buffersize) bind(C)
    !
    !   wraps ringBuffer%fullPop_()
    !
        type(ringWrapper), intent(inout) :: buffer
        real(cf), intent(out)            :: output(n)
        integer(ci), intent(in)          :: buffersize 

        memory = buffer%fullPop_(buffersize)

    end subroutine ringPopAll

    




end module void_verb