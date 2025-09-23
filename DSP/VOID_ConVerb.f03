module VOID_Converb
!
!   Convolution Reverb
!
    use convtools
    implicit none


contains   


    subroutine process(inputBuffer, outputBuffer, buffersize) bind(C)
    !
    !   full process function
    !
        integer(ci), intent(in)          :: buffersize 
        real(cf), intent(in)             :: inputBuffer(0:buffersize-1)
        real(cf), intent(out)            :: outputBuffer(0:buffersize-1)
        type(fftw_plan)                  :: plan 

        call setupPlan(plan, inputBuffer, outputBuffer, 'r2c')
        call FFT(plan)
        !call convolve() 
        call setupPlan(plan, inputBuffer, outputBuffer, 'c2r')
        call FFT(plan)
        !call cleanup()



    end subroutine process


    subroutine setupPlan(plan, inputBuffer, outputBuffer, irFreq, type)
    !
    !   setup for FFTW process
    !   uses type to determine plan
    !
    character(len=100)               :: type
    integer(ci)                      :: buffersize 
    real(cf), intent(in)             :: inputBuffer(0:buffersize-1)
    complex(cf), intent(in)          :: irFreq
    real(cf), intent(out)            :: outputBuffer(0:buffersize-1)
    type(fftw_plan), intent(out)     :: plan 


    if (type .eq. 'r2c') then

        plan = fftw_plan_dft_r2c_1d(buffersize, inputBuffer, buffer(0:buffersize/2), FFTW_ESTIMATE)

    else if (type .eq. 'c2r') then

        plan = fftw_plan_dft_c2r_1d(buffersize, buffer(0:buffersize/2), outputBuffer, FFTW_ESTIMATE)

    end if



    end subroutine setupplan


    subroutine setupIR(irFreq, buffersize)
    !
    !   setup for FFTW process
    !   uses type to determine plan
    !
    integer(ci), intent(in)          :: buffersize 
    complex(cf), intent(in)          :: irFreq
    type(fftw_plan), intent(out)     :: plan 


    plan = fftw_plan_dft_r2c_1d(buffersize, irFreq, buffer(0:buffersize/2), FFTW_ESTIMATE)


    end subroutine setupir



    subroutine FFT(plan) 
    !
    !   impliment fftw plan
    !     

    call fftw_execute(plan)

    end subroutine fft



    subroutine convolve()
    !
    !   apply convolution
    !

    end subroutine convolve


end module void_converb