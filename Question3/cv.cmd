Device DGATE {  
  Electrode {
    { Name="Ls_con"    Voltage=0.0 }
    { Name="Ld_con"     Voltage=0.0 }
    { Name="Ch_con_2"      Voltage=0.0  Workfunction=4.63 }
    { Name="Ls_ext_con_1"      Voltage=0.0 }
  }

  File {
      Grid      = "test_msh.tdr"
      Plot      = "test.tdr"
      Current   = "test.plt"
  }

  Physics {
        Mobility( DopingDep HighFieldSaturation Enormal )
        EffectiveIntrinsicDensity( oldSlotboom )
    }

    Plot {
      eDensity hDensity eCurrent hCurrent
        ElectricField eEparallel hEparallel
        eQuasiFermi hQuasiFermi
        Potential Doping SpaceCharge
        DonorConcentration AcceptorConcentration
    }
}

Math {
      Extrapolate
      RelErrControl
      Notdamped=50
      Iterations=20
}

File {
      Output    = "@log@"
      ACExtract = "@acplot@"
}

System {
      DGATE trans (Ld_con=d Ls_con=s Ch_con_2=g Ls_ext_con_1=b)
      Vsource_pset vd (d 0) {dc=0}
      Vsource_pset vs (s 0) {dc=0}
      Vsource_pset vg (g 0) {dc=0}
      Vsource_pset vb (b 0) {dc=0}
}

Solve {
      #-a) zero solution
      Poisson
      Coupled { Poisson Electron Hole }

      #-b) ramp drain to positive starting voltage
      Quasistationary (
                      InitialStep=0.1 MaxStep=0.5 Minstep=1.e-5
                      Goal { Parameter=vd.dc Voltage=3 }
                      )
                      { Coupled { Poisson Electron Hole } }
    
      #-c) ramp gate to negative starting voltage
      Quasistationary (
                      InitialStep=0.1 MaxStep=0.5 Minstep=1.e-5
                      Goal { Parameter=vg.dc Voltage=-2 }
                      )
                      { Coupled { Poisson Electron Hole } }
    
      #-d) ramp gate -2V ...+1V with AC analysis at each step.
      Quasistationary (
                      InitialStep=0.01 MaxStep=0.04 Minstep=1.e-5
                      Goal { Parameter=vg.dc Voltage=3 }
                      )
                      { ACCoupled (
                                  StartFrequency=10 EndFrequency=10
                                  NumberOfPoints=1 Decade
                                  Node(d s g b) Exclude(vd vs vg vb)
                                  )
                                  { Poisson Electron Hole }
                                  } 
}