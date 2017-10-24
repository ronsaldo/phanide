set(Phanide_SRC
    phanide-unix.c
)

add_definitions(-DBUILD_PHANIDE_CORE)
add_library(phanide SHARED ${Phanide_SRC})
