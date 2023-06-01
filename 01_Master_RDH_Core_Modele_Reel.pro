601,100
602,"01_Master_RDH_Core_Modele_Reel"
562,"NULL"
586,
585,
564,
565,"jC]6L]]gE0a21Ap[tvNL<5gMWga?I6t3eltW6aSbd53FWd3VPgt5`eTkP10gd7PtcIZINVix_9NcWl^tm>1WzmBsw]u=wvKhd2v?9ndzus:JPN=ef0kiJwCpk5KW`Qa=Iqbe>ULfo0OZ@J74bq<^xiYnpGV\s4U6LDZvFDK[;bDOH?1tqAWDit_wnW_qlsWknmr>Ng4M"
559,1
928,0
593,
594,
595,
597,
598,
596,
800,
801,
566,0
567,","
588,","
589," "
568,""""
570,
571,
569,0
592,0
599,1000
560,11
pPathSourceExcel
pPathTargetCSV
pSheetName
pFileSourceExcel
pFileTargetCSV
pDelim
pEncoding
pAnnee
pPhase
pVersion
pTypeVentilation
561,11
2
2
2
2
2
2
2
2
2
2
2
590,11
pPathSourceExcel,"D:\Refonte_Bud\INTERFACES\DATA\"
pPathTargetCSV,"D:\Refonte_Bud\INTERFACES\DATA\CSVFiles\"
pSheetName,"BASE BUDGET"
pFileSourceExcel,"20210121 BASE BUDGET MASTER 21.xlsx"
pFileTargetCSV,"Data.csv"
pDelim,";"
pEncoding,"UTF8"
pAnnee,"E21"
pPhase,"B"
pVersion,"V1"
pTypeVentilation,"avant_Ventil"
637,11
pPathSourceExcel,"Chemin du classeur Excel source."
pPathTargetCSV,"Chemin du fichier cible."
pSheetName,"Nom de la feuille Excel à convertir."
pFileSourceExcel,"Nom du classeur Excel source (suffixé avec .xlsx)."
pFileTargetCSV,"Nom du fichier csv cible à convertir (suffixé avec .csv)."
pDelim,"Délimiteur du csv . (`; par défaut)"
pEncoding,"Encodage du csv ? (UTF8 par défaut)"
pAnnee,"Quelle Année ?"
pPhase,"Quelle Phase ? "
pVersion,"Quelle Version ? "
pTypeVentilation,"apres_Ventil)"
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,83

#****Begin: Generated Statements***
#****End: Generated Statements****

#*****************************************************************************
# CREATEUR : DIMO SOFTWARE: GMU
# DATE DE CREATION : 11/09/2020
# DERNIERE MODIFICATION EFFECTUEE PAR : ...
# DATE DE DERNIERE MODIFICATION : ../../201.
# DESCRIPTION DU PROCESSUS : Mettre un fichier csv dans le bon format pour le processus Dim.Import

#*****************************************************************************
#***********************************************************************************************************
#                                  Définition des cubes
#***********************************************************************************************************

#Definition des cubes
sCubeParamP = 'ParametresSources' ;
sCubeParamT = 'ParametrageT' ;


#**********************************************************************************************************
#                                  Définition des constantes
#***********************************************************************************************************

cMainProcName = GetProcessName();
cRepertoireRacine = GetProcessErrorFileDirectory;
cTimeStamp = TimSt( Now, '\Y\m\d\h\i\s' );
cRandomInt = NumberToString( INT( RAND( ) * 1000 ));
cTimeProcess = cTimeStamp | '_' | cRandomInt;


#**********************************************************************************************************
#                                  Initialisation des variables
#**********************************************************************************************************

nProcessReturnCode= 0;
zLogNumero	= 1 ;

nMetaCount	= 0 ;
nDataCount	= 0 ;

nCountAttribut	= 0 ;
nCountParent	= 0 ;
nCountElement	= 0 ;
nCountWarn            = 0 ;

nErrors		= 0 ;

pLegacy		= 0 ;
#pDelim	             	= TRIM(pDelim);
pLogOutput             = 1 ;

# Déclaration de variables techniques
sProcessName = GetProcessName() ;
sProcessBegin = TimSt (Now(), '\d/\m/\Y - \h:\i:\s') ;
sProcessDateHeure = TimSt (Now(), '\d\m\Y_\hh\im\ss') ;
zCubeTech = 'ParametrageT' ;
sElemSource = 'Txt_RepertoireExe' ;
sElemTech = 'ValeurS' ;
nNbErrors = 0;

## 1- Exécution de la conversion de XLS vers CSV

sCompletePathXLS = pPathSourceExcel | pFileSourceExcel ;
sFileTargetCSV  =  pFileTargetCSV ;
sCompletePathCSV = pPathTargetCSV | sFileTargetCSV ;


ExecuteProcess( 'EXE_Convert_XLS_To_CSV' , 'pFileSourceExcel' , sCompletePathXLS , 'pSheetName' , pSheetName , 'pFileCibleCSV' , sCompletePathCSV , 'pDelim' , pDelim , 'pEncoding' , pEncoding );

## 3- Alimentation du cube à charger
# Définition du nom du fichier source                                      
sNomFichier = pFileTargetCSV ;
# Inserer un CellPutS dans le cube ParametresSources
CellPutS ( sNomFichier , 'ParametresSources' , 'Imp_Data_PL_Budget' , 'txt_NomFichier' );
# Execution du process
ExecuteProcess( 'Imp_Data_PL_Budget' , 'pAnnee', pAnnee , 'pPhase' , pPhase , 'pVersion' , pVersion , 'pTypeVentilation', pTypeVentilation  );





573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
575,3

#****Begin: Generated Statements***
#****End: Generated Statements****
576,CubeAction=1511DataAction=1503CubeLogChanges=0
930,0
638,1
804,0
1217,0
900,
901,
902,
938,0
937,
936,
935,
934,
932,0
933,0
903,
906,
929,
907,
908,
904,0
905,0
909,0
911,
912,
913,
914,
915,
916,
917,0
918,1
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
