struct NGuiOutline
    string ld_corner = "└"
    string rd_corner = "┘"
    string lu_corner = "┌"
    string ru_corner = "┐"
    string vertical = "│"
    string horizontal = "─"
    NGuiOutline => do return
    NGuiOutline string ld_corner, string rd_corner, string lu_corner, string ru_corner, string vertical, string horizontal =>
        this->ld_corner = ld_corner
        this->rd_corner = rd_corner
        this->lu_corner = lu_corner
        this->ru_corner = ru_corner
        this->vertical = vertical
        this->horizontal = horizontal
    ;
;