Friend Module Data

    Friend CFastInputFile As String
    Friend CFASTSimulationTime As Single
    Friend CommandWindowVisible As Boolean = False
    Friend ExitCode As Integer = 0

    Friend myRecentFiles As RecentFiles
    Friend myErrors As New ErrorMessages
    Friend myEnvironment As New Environment
    Friend Const ErrorNames As String = "WarningError  Fatal  Log           "

    Friend myUnits As New EngineeringUnits

    Friend myCompartments As New CompartmentCollection

    Friend myHVents As New VentCollection
    Friend myVVents As New VentCollection
    Friend myMVents As New VentCollection
    Friend myHHeats As New VentCollection
    Friend myVHeats As New VentCollection
    Friend Const FaceNames As String = "FrontRightRear Left "
    Friend Const ShapeNames As String = "Round Square"
    Friend Const OrientationNames As String = "Vertical  Horizontal"

    Friend myTargets As New TargetCollection
    Friend myDetectors As New TargetCollection
    Friend Const SolutionMethodNames As String = "ImplicitExplicitSteady  "
    Friend Const SolutionThicknessNames As String = "ThickThin "
    Friend Const DetectorTypes As String = "Smoke    Heat     Sprinkler"
    Friend Const NormalPointsTo As String = "User SpecifiedRear Wall     Front Wall    Right Wall    Left Wall     Ceiling       Floor         "
    Friend NormalPointsToData() As Single = {0.0, 0.0, 0.0, 1.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, -1.0}

    Friend myFires As New FireCollection                            ' Fires defined for this test case
    Friend myFireObjects As New FireCollection                      ' Currently defined object fires
    Friend TempFireObjects As New FireCollection
    Friend Const IgnitionNames As String = "Time       TemperatureHeat Flux  "
    Friend Const FireTypeNames As String = "ConstrainedHeat Source"
    Friend Const CJetNames As String = "OFF    CEILINGWALLS  ALL    "
    Friend firefile() As Integer = {2, 4, 3, 5, 6, 9, 10, 8, 7, 11, 12, 13, 14}

    Friend myThermalProperties As New ThermalPropertiesCollection
    Friend TempThermalProperties As New ThermalPropertiesCollection
    Friend Const MaximumThermalProperties As Integer = 150

    Friend dataFileHeader As New Collection                         'comments for the header of a datafile (indicated as !*)
    Friend dataFileComments As New Collection                       'dead keywords and other comments
    Friend thermalFileComments As New Collection                    'comments in the thermal file
    Friend fireFilesComments As New Collection                      'comments in the fire file

    Friend DetailedCFASTOutput As Boolean = True                    ' True if detailed output file is desired (makes print interval negative

    Friend Enum BaseUnitsNum    ' Provides an index into the array of base units conversion by type of conversion
        Length = 0
        Mass
        Time
        Temperature
        Pressure
        Energy
    End Enum
    Friend Enum UnitsNum    ' Provides an index into the array of units conversion by type of conversion
        Time = 0
        Temperature
        TemperatureRise
        Pressure
        Length
        Area
        Velocity
        Flowrate
        RTI
        Mass
        MassLoss
        Density
        HRR
        HoC
        HoG
        HeatFlux
        Conductivity
        SpecificHeat
        FireTime = 0
        FireMdot
        FireQdot
        FireHeight
        FireArea
        FireHCN = 9
        FireHCl
    End Enum

    Friend Enum compaNum
        Name = 2
        Width
        Depth
        Height
        AbsXPos
        AbsYPos
        FlrHeight
        CeilingMat
        FloorMat
        WallMat
    End Enum

    Friend Enum hventNum
        firstcomp = 2
        secondcomp
        vent
        width
        soffit
        sill
        wind
        hall1
        hall2
        face
        initialfraction
    End Enum

    Friend Enum hallNum
        compartment = 2
        vel
        depth
        DecayDist
    End Enum

    Friend Enum vventNum
        firstcompartment = 2
        secondcompartment
        area
        shape
        intialfraction
    End Enum

    Friend Enum vheatNum
        firstcompartment = 2
        secondcompartment
    End Enum

    Friend Enum mventNum
        fromCompartment = 2
        toCompartment
        IDNumber
        fromOpenOrien
        fromHeight
        fromArea
        toOpenOrien
        toHeight
        toArea
        flow
        beginFlowDrop
        flowZero
        initialfraction
    End Enum

    Friend Enum fireNum
        compartment = 2
        xPosition
        yPosition
        zposition
        plumeType
    End Enum

    Friend Enum objfireNum
        name = 2
        compartment
        xPosition
        yPosition
        zposition
        plumeType
        ignType
        ignCriteria
        xNormal
        yNormal
        zNormal
    End Enum

    Friend Enum ambNum
        ambTemp = 2
        ambPress
        refHeight
        relHumidity
    End Enum

    Friend Enum timesNum
        simTime = 2
        printInterval
        historyInterval
        smokeviewInterval
        spreadsheetInterval
    End Enum

    Friend Enum windNum
        velocity = 2
        refHeight
        expLapseRate
    End Enum

    Friend Enum cjetNum
        type = 2
    End Enum

    Friend Enum djignNum
        igntemp = 2
    End Enum

    Friend Enum chemieNum
        limo2 = 2
        igntemp
        cjetType
    End Enum
    Friend Enum detectNum
        type = 2
        compartment
        activationTemp
        xPosition
        yPosition
        zPosition
        RTI
        suppression
        sprayDensity
    End Enum

    Friend Enum targetNum
        compartment = 2
        xPosition
        yPosition
        zPosition
        xNormal
        yNormal
        zNormal
        material
        method
        equationType
    End Enum

    Friend Enum hheatNum
        firstCompartment = 2
        num
        secondCompartment
        fraction
    End Enum

    Friend Enum CFASTlnNum
        keyWord = 1
        version
        title
    End Enum

    Friend Enum thermalNum
        shortName = 1
        Conductivity
        specificHeat
        density
        thickness
        emissivity
        HClCoefficients
        longName = 14
    End Enum

    Friend Enum eventNum
        ventType = 2
        firstCompartment
        secondCompartment
        ventNumber
        time
        finalFraction
        decaytime
    End Enum
End Module
