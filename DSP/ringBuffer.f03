module buffers

    ! --------------------------------------------------
    ! Simple ring buffer to for delay lines 
    ! in REVERB/DELAY fortran kernels
    ! 
    ! TYPE RingBuffer:
    !
    ! OBJECTS:      
    !   delayline: ring buffer storage line
    !
    ! METHODS:
    !   push         : adds a value to the buffer
    !   pop          : read value from buffer
    !   reset        : reset the buffer back to 0_cf 
    !   rbDestructor : clean up when leaving scope
    !
    !   fullPop_     : peek whole stored buffer
    ! --------------------------------------------------

    use numtype
    implicit none

    type :: ringbuffer
        !
        !   Type to bind buffer storage
        !   with methods
        !
        integer(ci)  :: size              = 150000_ci
        real(cf)     :: delayline(150000) = 0.0_cf
        integer(ci)  :: writeIdx          = 0_ci
        integer(ci)  :: readIdx           = 0_ci
    contains 
        procedure    :: push              => rbPush
        procedure    :: pop               => rbPop
        procedure    :: reset             => rbReset
        final        :: rbDestructor 
        ! unit testing
        procedure    :: fullPop_    
    end type ringbuffer
        

contains 

    ! PUSH

    subroutine rbPush(buffer,value) 
        !
        !   push value into ring bufferfullPop_(buffer, buffersize)
        !
        class(ringbuffer), intent(inout) :: buffer
        real(cf), intent(in)             :: value
        integer(ci)                       :: i

        i = buffer%writeIdx + 1_ci  ! Handle Fortran 1-indexing on arrays
        buffer%delayline(i) = value 
        buffer%writeIdx = mod(buffer%writeIdx + 1_ci, buffer%size)

    end subroutine rbPush

    ! POP

    function rbPop(buffer) result(value)
        !
        ! read value off of buffer at readIdx
        !
        ! RETURNS:fullPop_(buffer, buffersize)
        !           value [c_float]
        !
        class(ringbuffer), intent(inout) :: buffer
        real(cf)                         :: value
        integer(ci)                      :: i

        i = buffer%readIdx + 1_ci  ! Handle Fortran 1-indexing on arrays
        value = buffer%delayline(i)
        buffer%readIdx = mod(buffer%readIdx + 1_ci, buffer%size)

    end function rbPop

    ! FULL POP !

    subroutine fullPop_(buffer, memory, buffersize) 
        !
        ! FOR UNIT TESTING ONLY
        ! applues rbPop to the whole stored buffer(buffersize)
        !  
        ! RETURNS:
        !           values [array(c_float)]
        !
        class(ringbuffer), intent(inout) :: buffer
        integer(ci), intent(in)          :: buffersize
        real(cf), intent(out)            :: memory(0:buffersize-1)
        integer(ci)                      :: i

        do i = 0, buffersize - 1

            memory(i) = buffer%pop()

        end do

    end subroutine fullPop_

    ! RESET

    subroutine rbReset(buffer) 
        !
        !   Resets buffer values and idx's
        !   
        class(ringbuffer), intent(inout) :: buffer

        buffer%delayline = 0._cf
        buffer%writeIdx  = 0_ci
        buffer%readIdx   = 0_ci

    end subroutine rbReset

    ! DESTRUCTOR

    subroutine rbDestructor(buffer)
        !
        !   Finalizer (C++ Destructor)
        !
        type(ringbuffer), intent(inout) :: buffer

        call buffer%reset()

    end subroutine rbDestructor


end module buffers
