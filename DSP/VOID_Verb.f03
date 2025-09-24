module VOID_Verb
! Simple wrapper to expose ring buffer
! to c++ for CI/CD integration
! Needed for non-interpolability of 
! type-bound methods (which are the best)

    use numtype
    use buffers
    implicit none

    type(ringBuffer) :: buffer

contains   

    subroutine ringPush(val) bind(C)
    !
    !   wraps bufferRing%push()
    !
        real(cf), intent(in)             :: val
        integer(ci)                      :: i

        i = buffer%writeIdx + 1_ci
        buffer%delayline(i) = val
        buffer%writeIdx = mod(buffer%writeIdx + 1, buffer%size)

    end subroutine ringPush


    subroutine ringPopAll(memory, buffersize) bind(C)
    !
    !   wraps ringBuffer%fullPop_()
    !
        integer(ci), intent(in)          :: buffersize 
        real(cf), intent(out)            :: memory(*)


        call buffer%fullPop_(memory, buffersize)

    end subroutine ringPopAll

    




end module void_verb