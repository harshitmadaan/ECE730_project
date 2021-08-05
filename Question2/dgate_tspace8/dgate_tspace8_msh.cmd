Title "Untitled"

Controls {
}

Definitions {
	Constant "C_Channel_Dope" {
		Species = "BoronActiveConcentration"
		Value = 1e+15
	}
	Constant "C_Source_Dope" {
		Species = "ArsenicActiveConcentration"
		Value = 1e+20
	}
	Constant "C_Drain_Dope" {
		Species = "ArsenicActiveConcentration"
		Value = 1e+20
	}
	Constant "C_Source_Spacer_Dope" {
		Species = "ArsenicActiveConcentration"
		Value = 1e+19
	}
	Constant "C_Drain_Spacer_Dope" {
		Species = "ArsenicActiveConcentration"
		Value = 1e+19
	}
	AnalyticalProfile "G_SDext_Dope" {
		Species = "ArsenicActiveConcentration"
		Function = Gauss(PeakPos = 0, PeakVal = 1e+19, Length = 0.006)
		LateralFunction = Gauss(Factor = 0)
	}
	Refinement "M_Source" {
		MaxElementSize = ( 0.025 0.01 )
		MinElementSize = ( 0.01 0.005 )
	}
	Refinement "M_Drain" {
		MaxElementSize = ( 0.025 0.01 )
		MinElementSize = ( 0.01 0.005 )
	}
	Refinement "M_Channel" {
		MaxElementSize = ( 0.025 0.0005 )
		MinElementSize = ( 0.01 0.00025 )
	}
	Refinement "M_Ox" {
		MaxElementSize = ( 0.00125 0.001 )
		MinElementSize = ( 0.005 0.00025 )
	}
	Refinement "M_Source_Spacer" {
		MaxElementSize = ( 0.025 0.0125 )
		MinElementSize = ( 0.0125 0.0025 )
	}
	Refinement "M_Drain_Spacer" {
		MaxElementSize = ( 0.025 0.0125 )
		MinElementSize = ( 0.0125 0.0025 )
	}
}

Placements {
	Constant "C_PL_Channel" {
		Reference = "C_Channel_Dope"
		EvaluateWindow {
			Element = region ["Channel"]
		}
	}
	Constant "C_PL_Source" {
		Reference = "C_Source_Dope"
		EvaluateWindow {
			Element = region ["Source"]
		}
	}
	Constant "C_PL_Drain" {
		Reference = "C_Drain_Dope"
		EvaluateWindow {
			Element = region ["Drain"]
		}
	}
	Constant "C_PL_Source_Spacer" {
		Reference = "C_Source_Spacer_Dope"
		EvaluateWindow {
			Element = Rectangle [(0.15 0.0415) (0.16 0.0575)]
		}
	}
	Constant "C_PL_Drain_Spacer" {
		Reference = "C_Drain_Spacer_Dope"
		EvaluateWindow {
			Element = Rectangle [(0.206 0.0415) (0.216 0.0575)]
		}
	}
	AnalyticalProfile "APP_Source_ext" {
		Reference = "G_SDext_Dope"
		ReferenceElement {
			Element = Line [(0.16 0.0415) (0.16 0.0575)]
			Direction = negative
		}
		EvaluateWindow {
			Element = Rectangle [(0.16 0.0415) (0.206 0.0575)]
		}
	}
	AnalyticalProfile "APP_Drain_ext" {
		Reference = "G_SDext_Dope"
		ReferenceElement {
			Element = Line [(0.206 0.0415) (0.206 0.0575)]
		}
		EvaluateWindow {
			Element = Rectangle [(0.16 0.0415) (0.206 0.0575)]
		}
	}
	Refinement "M_PL_Source" {
		Reference = "M_Source"
		RefineWindow = Rectangle [(0 0) (0.15 0.099)]
	}
	Refinement "M_PL_Drain" {
		Reference = "M_Drain"
		RefineWindow = Rectangle [(0.216 0) (0.366 0.099)]
	}
	Refinement "M_PL_Channel" {
		Reference = "M_Channel"
		RefineWindow = Rectangle [(0.15 0.0415) (0.216 0.0575)]
	}
	Refinement "M_PL_Bot_Ox" {
		Reference = "M_Ox"
		RefineWindow = Rectangle [(0.158 0.04) (0.208 0.0415)]
	}
	Refinement "M_PL_Top_Ox" {
		Reference = "M_Ox"
		RefineWindow = Rectangle [(0.158 0.0575) (0.208 0.059)]
	}
	Refinement "M_PL_Source_Spacer" {
		Reference = "M_Source_Spacer"
		RefineWindow = Rectangle [(0.15 0) (0.158 0.099)]
	}
	Refinement "M_PL_Drain_Spacer" {
		Reference = "M_Drain_Spacer"
		RefineWindow = Rectangle [(0.216 0) (0.366 0.099)]
	}
}

