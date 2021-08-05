File{
   Grid      = "dgate_tspace13_msh.tdr"
   Plot      = "dgate_tspace13.tdr"
   Current   = "dgate_tspace13.plt"
   Output    = "dgate_tspace13.log"
}

Electrode {
  { Name="Ls_con"    Voltage=0.0 }
  { Name="Ld_con"     Voltage=0.0 }
  { Name="Ch_con_2"      Voltage=0.0  Workfunction=4.63 }
  { Name="Ls_ext_con_1"      Voltage=0.0 }
}

Physics {
  Mobility( DopingDep HighFieldsat Enormal )
  EffectiveIntrinsicDensity( OldSlotboom )
}

Plot {
  eDensity  hDensity  eCurrent  hCurrent
  Potential  SpaceCharge  ElectricField
  eMobility  hMobility  eVelocity  hVelocity
  Doping  DonorConcentration   AcceptorConcentration
}

Math {
  Extrapolate
  RelErrControl
}

Solve { *initial solution
  Poisson
  Coupled { Poisson Electron }
  #ramp drain to 1V:
  Quasistationary ( MaxStep=0.5
                    Goal { Name="Ld_con" Voltage=1.0 } )
                  { Coupled { Poisson Electron } }
  Save(FilePrefix="vd1")

  #ramp gate for sat IdVg
  Load(FilePrefix="vd1")
  NewCurrentPrefix="sat_"
  Quasistationary ( MaxStep=0.017
                    Goal { Name="Ch_con_2" Voltage=1.0 } )
                  { Coupled { Poisson Electron } }

}
