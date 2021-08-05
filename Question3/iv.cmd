File{
   Grid      = "dgate_tspace2_msh.tdr"
   Plot      = "dgate_tspace2.tdr"
   Current   = "dgate_tspace2.plt"
   Output    = "dgate_tspace2.log"
   Parameter = "./models.par" #added for when the dielectric constant was changed
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
  Save(FilePrefix="vg0")
  #ramp gate to 500mV:
  Quasistationary ( MaxStep=0.5
                    Goal { Name="Ch_con_2" Voltage=0.5 } )
                  { Coupled { Poisson Electron } }
  Save(FilePrefix="vg0.5")

  #ramp gate to 1V:
  Quasistationary ( MaxStep=0.5
                    Goal { Name="Ch_con_2" Voltage=1.0 } )
                  { Coupled { Poisson Electron } }
  Save(FilePrefix="vg1")

  #ramp drain for Ilow
  Load(FilePrefix="vg0.5")
  NewCurrentPrefix="Ilow_"
  Quasistationary ( MaxStep=0.01
                    Goal { Name="Ld_con" Voltage=1.0 } )
                  { Coupled { Poisson Electron } }

  #ramp drain for Ihigh
  Load(FilePrefix="vg1")
  NewCurrentPrefix="Ihigh_"
  Quasistationary ( MaxStep=0.01
                    Goal { Name="Ld_con" Voltage=1.0 } )
                  { Coupled { Poisson Electron } }

}
