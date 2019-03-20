set(Phanide_SRC
	internal.h
    phanide-unix.c
	phanide-windows.c
	threads.h
)

add_definitions(-DBUILD_PHANIDE_CORE)
add_library(phanide SHARED ${Phanide_SRC})
