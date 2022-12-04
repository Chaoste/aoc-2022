function calculate_score(enemy_choice, my_choice) result(j)
    CHARACTER*8, intent (in) :: enemy_choice, my_choice
    integer                  :: j

    j = 0
    select case(enemy_choice)
      case( "A" )
        select case(my_choice)
          case( "X" )
            j = 0 + 3
          case( "Y" )
            j = 3 + 1
          case( "Z" )
            j = 6 + 2
        end select
      case( "B" )
        select case(my_choice)
          case( "X" )
            j = 0 + 1
          case( "Y" )
            j = 3 + 2
          case( "Z" )
            j = 6 + 3
        end select
      case( "C" )
        select case(my_choice)
          case( "X" )
            j = 0 + 2
          case( "Y" )
            j = 3 + 3
          case( "Z" )
            j = 6 + 1
        end select
    end select

end function

program exerciseA
  use iso_fortran_env, only: IOSTAT_END
  integer :: num_lines, sum_scores = 0
  real    :: score
  integer :: file_unit
  integer :: stat
  integer :: calculate_score
  CHARACTER*8 :: enemy_choice, my_choice

  open (newunit = file_unit, file = 'input.txt', status = 'OLD', action = "READ", form = "FORMATTED")
  num_lines = 0
  do
    read(file_unit, *, err=99, iostat = stat) enemy_choice, my_choice
    if (stat == IOSTAT_END) exit
    num_lines = num_lines + 1
    score = calculate_score(enemy_choice, my_choice)
    sum_scores = sum_scores + score
  end do
  99 close(file_unit)

  print *, 'Number of lines:', num_lines
  print *, 'Scored points:', sum_scores
  ! 10 format('F(' f3.1 ',' f3.1 ') = ' f4.1 ', ') 
  
end program exerciseA

