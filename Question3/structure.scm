; --- Define parameters and list values ---

; filename
(define filename "test")

; device dimensions
(define Tox 0.0015)
(define Lg 0.050)
(define Lsd 0.150)
(define Tspacer 0.015)
(define Hraise 0.040)
(define Lext 0.010)
(define Tsi 0.016)
(define Ldspacer (+ Lg (+ Lsd Tspacer)))
(define Ldevice (+ (+ Ldspacer Tspacer) Lsd))
(define Htox (+ (+ Hraise Tox) Tsi))
(define Hdevice (+ Hraise (+ Htox Tox)))

(define Dt (+ (* 2 Hraise) (* 2 Tox) Tsi))
(define Dl (+ (* 2 Lsd) (* 2 Tspacer) Lg))

; doping
(define SD_Dope 1E20)
(define SDext_Dope 1E19)
(define Channel_Dope 1E15)


; mesh refinement
(define Xmesh_sd_min 0.01)
(define Xmesh_sd_max 0.025)
(define Ymesh_sd_min 0.005)
(define Ymesh_sd_max 0.01)
(define Xmesh_channel_min 0.01)
(define Xmesh_channel_max 0.025)
(define Ymesh_channel_min 0.00025)
(define Ymesh_channel_max 0.0005)
(define Xmesh_spacer_min 0.0125)
(define Xmesh_spacer_max 0.025)
(define Ymesh_spacer_min 0.0025)
(define Ymesh_spacer_max 0.0125)
(define Xmesh_oxide_min 0.005)
(define Xmesh_oxide_max 0.00125)
(define Ymesh_oxide_min 0.00025)
(define Ymesh_oxide_max 0.001)


; --- Program run ---

(begin
(sde:clear)

; --- Create structure ---

(sdegeo:create-rectangle (position 0 0 0) (position Lsd Hdevice 0) "Silicon" "Source")
(sdegeo:create-rectangle (position Lsd 0 0) (position (+ Lsd Tspacer) Hdevice 0) "Si3N4" "Source_Spacer")
(sdegeo:create-rectangle (position Ldspacer 0 0) (position (+ Ldspacer Tspacer) Hdevice 0) "Si3N4" "Drain_Spacer")
(sdegeo:create-rectangle (position Lsd (+ Hraise Tox) 0) (position (+ Ldspacer Tspacer) Htox 0) "Silicon" "Channel")
(sdegeo:create-rectangle (position (+ Ldspacer Tspacer) 0 0) (position Ldevice Hdevice 0) "Silicon" "Drain")
(sdegeo:create-rectangle (position (+ Lsd Tspacer) Hraise  0) (position Ldspacer (+ Hraise Tox) 0) "Oxide" "Bot_Ox")
(sdegeo:create-rectangle (position (+ Lsd Tspacer) Htox  0) (position Ldspacer (+ Htox Tox) 0) "Oxide" "Top_Ox")

; --- Contacts ---

(sdegeo:define-contact-set "Ls_con" 4.0  (color:rgb 1.0 1.0 0.0 ) "##")
(sdegeo:set-current-contact-set "Ls_con")
(sdegeo:define-2d-contact (find-edge-id (position (* 0.5 Lsd) 0 0)) "Ls_con")

(sdegeo:define-contact-set "Ld_con" 4.0  (color:rgb 1.0 1.0 0.0 ) "##")
(sdegeo:set-current-contact-set "Ld_con")
(sdegeo:define-2d-contact (find-edge-id (position (- Dl (* 0.5 Lsd)) 0 0)) "Ld_con")

(sdegeo:define-contact-set "Ch_con_1" 4.0  (color:rgb 1.0 1.0 0.0 ) "##")
(sdegeo:set-current-contact-set "Ch_con_1")
(sdegeo:define-2d-contact (find-edge-id (position (+ Lsd Tspacer (* 0.5 Lg)) (- Dt Hraise) 0)) "Ch_con_1")

(sdegeo:define-contact-set "Ch_con_2" 4.0  (color:rgb 1.0 1.0 0.0 ) "##")
(sdegeo:set-current-contact-set "Ch_con_2")
(sdegeo:define-2d-contact (find-edge-id (position (+ Lsd Tspacer (* 0.5 Lg)) Hraise 0)) "Ch_con_2")

(sdegeo:define-contact-set "Ls_ext_con_1" 4.0  (color:rgb 1.0 1.0 0.0 ) "##")
(sdegeo:set-current-contact-set "Ls_ext_con_1")
(sdegeo:define-2d-contact (find-edge-id (position (+ Lsd Tspacer) (- Dt (* 0.5 Hraise)) 0)) "Ls_ext_con_1")

(sdegeo:define-contact-set "Ls_ext_con_2" 4.0  (color:rgb 1.0 1.0 0.0 ) "##")
(sdegeo:set-current-contact-set "Ls_ext_con_2")
(sdegeo:define-2d-contact (find-edge-id (position (+ Lsd Tspacer) (* 0.5 Hraise) 0)) "Ls_ext_con_2")

(sdegeo:define-contact-set "Ld_ext_con_1" 4.0  (color:rgb 1.0 1.0 0.0 ) "##")
(sdegeo:set-current-contact-set "Ld_ext_con_1")
(sdegeo:define-2d-contact (find-edge-id (position (- (- Dl Lsd) Tspacer) (- Dt (* 0.5 Hraise)) 0)) "Ld_ext_con_1")

(sdegeo:define-contact-set "Ld_ext_con_2" 4.0  (color:rgb 1.0 1.0 0.0 ) "##")
(sdegeo:set-current-contact-set "Ld_ext_con_2")
(sdegeo:define-2d-contact (find-edge-id (position (- (- Dl Lsd) Tspacer) (* 0.5 Hraise) 0)) "Ld_ext_con_2")



;Body Contact

; --- Reference windows and lines for doping and meshing ---
;Windows
(sdedr:define-refeval-window "RW_Source" "Rectangle" (position 0 0 0) (position Lsd Hdevice 0))
(sdedr:define-refeval-window "RW_Drain" "Rectangle" (position (+ Ldspacer Tspacer) 0 0) (position Ldevice Hdevice 0))
(sdedr:define-refeval-window "RW_Bot_Ox" "Rectangle" (position (+ Lsd Tspacer) Hraise  0) (position Ldspacer (+ Hraise Tox) 0))
(sdedr:define-refeval-window "RW_Top_Ox" "Rectangle" (position (+ Lsd Tspacer) Htox  0) (position Ldspacer (+ Htox Tox) 0))
(sdedr:define-refeval-window "RW_Source_Spacer" "Rectangle" (position Lsd 0 0) (position (+ Lsd Tspacer) Hdevice 0))
(sdedr:define-refeval-window "RW_Drain_Spacer" "Rectangle" (position (+ Ldspacer Tspacer) 0 0) (position Ldevice Hdevice 0))
(sdedr:define-refeval-window "RW_Channel" "Rectangle" (position Lsd (+ Hraise Tox) 0) (position (+ Ldspacer Tspacer) Htox 0))
(sdedr:define-refeval-window "RW_Channel_Source" "Rectangle" (position Lsd (+ Hraise Tox) 0) (position (+ Lsd Lext) Htox 0))
(sdedr:define-refeval-window "RW_Channel_Drain" "Rectangle" (position (- (- Ldevice Lsd) Lext) (+ Hraise Tox) 0) (position (- Ldevice Lsd) Htox 0))
(sdedr:define-refeval-window "RW_Channel_Mid" "Rectangle" (position (+ Lsd Lext) (+ Hraise Tox) 0) (position (- (- Ldevice Lsd) Lext) Htox 0))
;Lines
(sdedr:define-refeval-window "RW_Source_Line" "Line" (position (+ Lsd Lext) (+ Hraise Tox) 0) (position (+ Lsd Lext) Htox 0))
(sdedr:define-refeval-window "RW_Drain_Line" "Line" (position (- (- Ldevice Lsd) Lext) (+ Hraise Tox) 0) (position (- (- Ldevice Lsd) Lext) Htox 0))




; --- Doping ---
(sdedr:define-constant-profile "C_Channel_Dope" "BoronActiveConcentration" Channel_Dope)
(sdedr:define-constant-profile "C_Source_Dope" "ArsenicActiveConcentration" SD_Dope)
(sdedr:define-constant-profile "C_Drain_Dope" "ArsenicActiveConcentration" SD_Dope)
(sdedr:define-constant-profile "C_Source_Spacer_Dope" "ArsenicActiveConcentration" SDext_Dope)
(sdedr:define-constant-profile "C_Drain_Spacer_Dope" "ArsenicActiveConcentration" SDext_Dope)
(sdedr:define-gaussian-profile "G_SDext_Dope" "ArsenicActiveConcentration" "PeakPos" 0 "PeakVal" SDext_Dope "Length" 0.006 "Gauss" "Factor" 0)

(sdedr:define-constant-profile-region "C_PL_Channel" "C_Channel_Dope" "Channel")
(sdedr:define-constant-profile-region "C_PL_Source" "C_Source_Dope" "Source")
(sdedr:define-constant-profile-region "C_PL_Drain" "C_Drain_Dope" "Drain")
(sdedr:define-constant-profile-placement "C_PL_Source_Spacer" "C_Source_Spacer_Dope" "RW_Channel_Source")
(sdedr:define-constant-profile-placement "C_PL_Drain_Spacer" "C_Drain_Spacer_Dope" "RW_Channel_Drain")
(sdedr:define-analytical-profile-placement "APP_Source_ext" "G_SDext_Dope" "RW_Source_Line" "Negative" "NoReplace" "Eval" "RW_Channel_Mid" 0 "evalwin")
(sdedr:define-analytical-profile-placement "APP_Drain_ext" "G_SDext_Dope" "RW_Drain_Line" "Positve" "NoReplace" "Eval" "RW_Channel_Mid" 0 "evalwin")



; --- Creating Mesh ---
(sdedr:define-refinement-size "M_Source" Xmesh_sd_max Ymesh_sd_max Xmesh_sd_min  Ymesh_sd_min)
(sdedr:define-refinement-placement "M_PL_Source" "M_Source" "RW_Source" )

(sdedr:define-refinement-size "M_Drain" Xmesh_sd_max Ymesh_sd_max Xmesh_sd_min  Ymesh_sd_min)
(sdedr:define-refinement-placement "M_PL_Drain" "M_Drain" "RW_Drain" )

(sdedr:define-refinement-size "M_Channel" Xmesh_channel_max Ymesh_channel_max Xmesh_channel_min  Ymesh_channel_min)
(sdedr:define-refinement-placement "M_PL_Channel" "M_Channel" "RW_Channel" )

(sdedr:define-refinement-size "M_Ox" Xmesh_oxide_max Ymesh_oxide_max Xmesh_oxide_min  Ymesh_oxide_min)
(sdedr:define-refinement-placement "M_PL_Bot_Ox" "M_Ox" "RW_Bot_Ox" )
(sdedr:define-refinement-placement "M_PL_Top_Ox" "M_Ox" "RW_Top_Ox" )

(sdedr:define-refinement-size "M_Source_Spacer" Xmesh_spacer_max Ymesh_spacer_max Xmesh_spacer_min  Ymesh_spacer_min)
(sdedr:define-refinement-placement "M_PL_Source_Spacer" "M_Source_Spacer" "RW_Source_Spacer" )

(sdedr:define-refinement-size "M_Drain_Spacer" Xmesh_spacer_max Ymesh_spacer_max Xmesh_spacer_min  Ymesh_spacer_min)
(sdedr:define-refinement-placement "M_PL_Drain_Spacer" "M_Drain_Spacer" "RW_Drain_Spacer" )


; Build Mesh
(sde:build-mesh "mesh" "-d" filename)
)