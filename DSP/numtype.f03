
module NumType

	use iso_c_binding, only: c_float, c_int
	!* Library includes *!
	include 'fftw3.f03'
	save
	
	integer, parameter :: cf = kind(1.0_c_float)
	integer, parameter :: ci = kind(1.0_c_int)
	
	!real(cf), parameter :: pi = 4*atan(1._cf)
	
	complex(cf), parameter :: iic = (0._cf,1._cf)

	!
	! NEEDED OBJECTS
	!

	complex(cf) :: buffer(0:5000)
	complex(cf) :: ImpRes(0:5000)

	
end module numtype


