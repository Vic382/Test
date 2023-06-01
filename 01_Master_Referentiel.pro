601,100
602,"01_Master_Referentiel"
562,"NULL"
586,
585,
564,
565,"caIaNcZ2[c\?dG<x]Mn^;6VPp7hvUFICR6m7XadTmh:2=4:56@DJaIAf=M?2vk9JE;Y_iks9?INV8eCvq=M<Ujp3rb5Z3:cKQ0^=aG<cmhR96k3aYYta:WBRPDU0GOTir8[_GlU4_\KV`z17`tMsEZ8;_8s0=g[9;d\iN5:Rl1sd8J2RG=]=w[z]7oAvwisZBPp09XM1"
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
560,6
pDim
pPathSourceExcel
pPathTargetCSV
pFileSourceExcel
pDelim
pEncoding
561,6
2
2
2
2
2
2
590,6
pDim,"Nature"
pPathSourceExcel,"D:\Refonte_Bud\INTERFACES\METADATA\"
pPathTargetCSV,"D:\Refonte_Bud\INTERFACES\METADATA\CSVFiles\"
pFileSourceExcel,"20220221 - Dimensions BAI TM1 V3.xlsx"
pDelim,";"
pEncoding,"UTF8"
637,6
pDim,"Dimension à charger?"
pPathSourceExcel,"Chemin du classeur Excel source."
pPathTargetCSV,"Chemin du fichier cible."
pFileSourceExcel,"Nom du classeur Excel source (suffixé avec .xlsx)."
pDelim,""
pEncoding,""
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,114

#****Begin: Generated Statements***
#****End: Generated Statements****

#*****************************************************************************
# CREATEUR : DIMO SOFTWARE: GMU
# DATE DE CREATION : 11/09/2020
# DESCRIPTION DU PROCESSUS : Mettre un fichier csv dans le bon format pour le processus Dim.Import
# DERNIERE MODIFICATION EFFECTUEE PAR : OST
# DATE DE DERNIERE MODIFICATION : 09/05/2022
# DESCRIPTION MODIFICATION : Calcul des paramètres pSheetName, pFileTargetCSV & pSheetName 

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


# Gestion du lancement par tÃ¢che planifiÃ©
IF ( SUBST ( TM1User() , 1 , 2 ) @= 'R*' ) ;
    cUtilisateur = 'Lanceur' ;
ELSE ;
    cUtilisateur        = TM1User();
ENDIF ;

cLenASCIICode = 3 ;

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

# Modif OST le 09/05/2022
#-------------------------------------
sFileTargetCSV  = 'Staging_' |  pDim | '.csv'; 
sSheetName = pDim ;

#Fin Modif OST
#-------------------------------------

## 1- Exécution de la conversion de XLS vers CSV
#sFileSourceExcel = 'D:\IBM\Instances\BRITTANYFERRIES\INTERFACES\METADATA\' ;
sCompletePathXLS = pPathSourceExcel | pFileSourceExcel ;
#sFileTargetCSV  = 'Staging_' |  pFileTargetCSV ;
sCompletePathCSV = pPathTargetCSV | sFileTargetCSV ;

# Modif OST le 09/05/2022
#-------------------------------------
#ExecuteProcess( 'EXE_Convert_XLS_To_CSV' , 'pFileSourceExcel' , sCompletePathXLS , 'pSheetName' , pSheetName , 'pFileCibleCSV' , sCompletePathCSV , 'pDelim' , pDelim , 'pEncoding' , pEncoding );
ExecuteProcess( 'EXE_Convert_XLS_To_CSV' , 'pFileSourceExcel' , sCompletePathXLS , 'pSheetName' , sSheetName , 'pFileCibleCSV' , sCompletePathCSV , 'pDelim' , pDelim , 'pEncoding' , pEncoding );

#Fin Modif OST
#-------------------------------------

## 2- Conversion de CSV vers le CSV au bon format pour intégration
# Voir pour modifier process lancé ou récupérer juste le nom du fichier pour lancement
# Inserer un CellPutS dans le cube ParametresSources
CellPutS ( sFileTargetCSV , 'ParametresSources' , 'Convert_CSV_To_CSV' , 'txt_NomFichier' );

# Modif OST le 09/05/2022
#-------------------------------------
ExecuteProcess( 'Convert_CSV_To_CSV' , 'pNomFichier' , sFileTargetCSV , 'pNomFichierCible' , pDim | '.csv' , 'pPathTargetCSV' , pPathTargetCSV );
#ExecuteProcess( 'Convert_CSV_To_CSV' , 'pNomFichier' , sFileTargetCSV , 'pNomFichierCible' , pDim | '.csv' , 'pPathTargetCSV' , pPathTargetCSV );

#Fin Modif OST
#-------------------------------------

## 3- Alimentation de la dimension à charger
# Définition du nom du fichier source                                      
sNomFichier =  pDim | '.csv' ;
# Inserer un CellPutS dans le cube ParametresSources
CellPutS ( sNomFichier , 'ParametresSources' , 'Process.Dim.Import' , 'txt_NomFichier' );
# Execution du process
ExecuteProcess( 'Process.Dim.Import' , 'pDim', pDim , 'pHier' , '' , 'pDelim' , ';' , 'pQuote' , '"' );
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
920,0
921,""
922,""
923,0
924,""
925,""
926,""
927,""
