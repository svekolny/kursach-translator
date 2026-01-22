!===========================================
!   demo file
!===========================================


    implicit none
    private

    ! Initialization
    real, parameter :: PI = 3.1415
    integer, parameter :: MAX_SIZE = 100
    CHARACTER :: chr = 34
    real :: fr = (50 + 10) / chr
    
    InTeGer :: var
    var = 256 + (chr * MAX_SIZE) / (2 * PI)

    ! Conditional expressions
    IF (var > 1000) then
        integer :: temp = 0

    ELSE IF (0) then
        integer :: temp = 1

    ELSE
        integer :: temp = 2
    end if

    ! Cycles
    DO n = 1, 10
        integer :: p = 9
        character :: s = p
    END DO

    DO n = 1, 20, 2
        integer :: p = 9
        character :: s = p
    END DO
    
    DO WHILE (chr < 50)
        chr = chr + 1
    END DO

    ! Switchcase
    SELECT CASE (MAX_SIZE)
    CASE (100)
        MAX_SIZE = 50
        MAX_SIZE = 25
        MAX_SIZE = MAX_SIZE + 1
    CASE (255)
        MAX_SIZE = 12
        MAX_SIZE = 6
    END SELECT

    ! Input / Output
    WRITE (*,'(A)') chr
    WRITE (*,'(F)') PI
    WRITE (*,'(I)') MAX_SIZE

    READ (*,'(I)') MAX_SIZE

    WRITE (*,'(A, F, I)') chr, PI, MAX_SIZE

    READ (*,'(F)') fr

    WRITE (*,'(F)') fr
    
    REAd (*,'(I)') var, MAX_SIZE

!------------------------------------------
