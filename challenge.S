.intel_syntax noprefix
.global main
main:
        lea     ecx, [esp+4]        # load address of the next stack element into ecx
        push    DWORD PTR [ecx-4]   # push old return address
        push    ebp                 # save old base pointer
        mov     ebp, esp            # set new base pointer
        push    ecx                 # save ecx

        push    0x0                 # push null
        push    0x41797261          # push 'A','y','r','a'
        push    0x7262694c          # push 'r','b','i','L'
        push    0x64616f4c          # push 'd','a','o','L'
        push    esp                 # push pointer to "LoadLibraryA"

        call    FindFunction        # call FindFunction("LoadLibraryA")
        add     esp, 0x14           # clear stack

        push    0x00006c6c          # push 'null','l','l'
        push    0x642e7472          # push 'd','.','t','r'
        push    0x6376736d          # push 'c','v','s','m'
        push    esp                 # push pointer to "msvcrt.dll"

        call    eax                 # call LoadLibrary("msvcrt.dll")
        add     esp, 0x0c           # clear stack

        push    eax                 # store module handle for msvcrt
        push    0x00007373          # push 'null','s','s'
        push    0x65726464          # push 'e','r','d','d'
        push    0x41636f72          # push 'A','c','o','r'
        push    0x50746547          # push 'P','t','e','G'
        push    esp                 # push pointer to "GetProcAddress"

        call    FindFunction        # call FindFunction("GetProcAddress")
        add     esp, 0x14           # clear stack
        pop     ebx                 # restore module handle for msvcrt

        push    0x00006674          # push 'null','null','f','t'
        push    0x6e697270          # push 'n','i','r','p'
        push    esp                 # push pointer to "printf"
        push    ebx                 # push module handle for msvcrt
        mov     esi, eax            # store address of GetProcAddress
        call    eax                 # call GetProcAddress(msvcrt, "printf")
        add     esp, 0x08           # clear stack
        mov     edi, eax            # store address of printf

        mov     eax, esi            # load address of GetProcAddress
        push    0x00000066          # push 'null','null','null','f'
        push    0x6e616373          # push 'n','a','c','s'
        push    esp                 # push pointer to "scanf"
        push    ebx                 # push module handle for msvcrt
        call    eax                 # call GetProcAddress(msvcrt, "scanf")
        add     esp, 0x08           # clear stack
        mov     esi, eax            # store address of scanf

        # Initialization
        sub     esp, 68             # allocate space on stack
        mov     DWORD PTR [ebp-12], 0    # wood = 0
        mov     DWORD PTR [ebp-16], 0    # brick = 0
        mov     DWORD PTR [ebp-20], 0    # wool = 0
        mov     DWORD PTR [ebp-24], 0    # grain = 0
        mov     DWORD PTR [ebp-28], 0    # ore = 0
        mov     BYTE PTR [ebp-41], 0     # null terminator
		mov     WORD PTR [ebp-43], 0x7325 # %s

L1:
        sub     esp, 8                 # allocate space for arg
        lea     eax, [ebp-40]          # load address of buffer
        push    eax                    # push buffer address
        lea     eax, [ebp-43]          # load address of the input
        push    eax                    # push input address
        call    esi                    # call scanf
        add     esp, 16                # clear stack
        cmp     eax, -1                # check if scanf returned EOF
        je      L5                     # if yes, jump to L5

        mov     al, BYTE PTR [ebp-40]  # move first character of input to al
        cmp     al, 0x63               # compare with 'c'
        jne     L2                     # if not 'c', jump to L2
        add     DWORD PTR [ebp-24], 2  # increment grain by 2
        add     DWORD PTR [ebp-28], 3  # increment ore by 3
L2:
        cmp     al, 0x64               # compare with 'd'
        jne     L3                     # if not 'd', loop to L3
        add     DWORD PTR [ebp-20], 1  # increment wool
        add     DWORD PTR [ebp-24], 1  # increment grain
        add     DWORD PTR [ebp-28], 1  # increment ore
L3:
		cmp     al, 0x72               # compare with 'r'
        jne     L4                     # if not 'r', jump to L4
        add     DWORD PTR [ebp-12], 1  # increment wood
        add     DWORD PTR [ebp-16], 1  # increment brick
L4:
		cmp     al, 0x73               # compare with 's'
        jne     L1                     # if not 's', jump to L1
        add     DWORD PTR [ebp-12], 1  # increment wood
        add     DWORD PTR [ebp-16], 1  # increment brick
        add     DWORD PTR [ebp-20], 1  # increment wool
        add     DWORD PTR [ebp-24], 1  # increment grain
        jmp     L1                     # loop to L1
L5:
        # print results
        mov     DWORD PTR [ebp-68], 0x64323025 # push string format "02d 02d 02d 02d 02d"
        mov     DWORD PTR [ebp-64], 0x32302520 # part of string format
        mov     DWORD PTR [ebp-60], 0x30252064 # part of string format
        mov     DWORD PTR [ebp-56], 0x25206432 # part of string format
        mov     DWORD PTR [ebp-52], 0x20643230 # part of string format
        mov     DWORD PTR [ebp-48], 0x64323025 # part of string format
        mov     BYTE PTR [ebp-44], 0           # null terminator
        lea     esp, [esp-8]                   # allocate space for args
        push    DWORD PTR [ebp-28]             # push ore
        push    DWORD PTR [ebp-24]             # push grain
        push    DWORD PTR [ebp-20]             # push wool
        push    DWORD PTR [ebp-16]             # push brick
        push    DWORD PTR [ebp-12]             # push wood
        mov     eax, ebp                       # move base pointer to eax
		sub     eax, 68                        # subtract the offset to get the address of the string format
        push    eax                            # push string format address
        call    edi                            # call printf
        add     esp, 32                        # clear stack
        mov     eax, 0                         # set return value to 0
        mov     ecx, DWORD PTR [ebp-4]         # load old return address
        lea     esp, [ecx-4]                   # restore stack pointer
        ret                                    # return

FindFunction:       # placeholder
